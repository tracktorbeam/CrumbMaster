//
//  CrumbIBeaconUploader.m
//  Crumb
//
//  Created by Arpan Ghosh on 2/2/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconUploader.h"

#warning "Need to persist sightings in Core Data backed sighting and operation queue"

@interface CrumbIBeaconUploader()

@property (nonatomic, strong) NSMutableArray *beaconSightingQueue;
@property (nonatomic) NSInteger uploadThreshold;
@property (nonatomic, strong) AFHTTPRequestOperationManager *beaconSightingUploadManager;

#warning "This state needs to be maintained in CrumbIBeaconManager."
@property (nonatomic, strong) NSMutableDictionary *beaconRegionOccupancy;

@end


@implementation CrumbIBeaconUploader

+(instancetype)getCrumbIBeaconUploader{
    static CrumbIBeaconUploader *singletonCrumbIBeaconUploader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonCrumbIBeaconUploader = [[self alloc] init];
    });
    return singletonCrumbIBeaconUploader;
}

- (instancetype)init{
    self = [super init];
    if (self){
        _beaconSightingQueue = [[NSMutableArray alloc] initWithCapacity:CRUMB_IBEACON_SIGHTINGS_UPLOAD_THRESHOLD * 2];
        _uploadThreshold = CRUMB_IBEACON_SIGHTINGS_UPLOAD_THRESHOLD;
        _beaconRegionOccupancy = [[NSMutableDictionary alloc] init];
        
        _beaconSightingUploadManager =
        [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:CRUMB_BACKEND_URL]];
        NSOperationQueue *beaconSightingUploaderOperationQueue = _beaconSightingUploadManager.operationQueue;
        [_beaconSightingUploadManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"Network is reachable");
                    [beaconSightingUploaderOperationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                case AFNetworkReachabilityStatusUnknown:
                default:
                    NSLog(@"Network is not reachable. Suspending queue.");
                    [beaconSightingUploaderOperationQueue setSuspended:YES];
                    break;
            }
        }];
        [_beaconSightingUploadManager.reachabilityManager startMonitoring];
        
    }
    return self;
}

-(void)stageBeaconSighting:(CLBeacon *)beacon{
    [self.beaconSightingQueue addObject:beacon];
    if ([self.beaconSightingQueue count] > self.uploadThreshold){
        [self uploadAllBeaconSightingsSoFar];
    }
}

-(void)adjustUploadThreshold:(NSInteger)threshold{
    self.uploadThreshold = threshold;
    if ([self.beaconSightingQueue count] > self.uploadThreshold){
        [self uploadAllBeaconSightingsSoFar];
    }
}

-(void)uploadAllBeaconSightingsSoFar{
    [self.beaconSightingUploadManager POST:CRUMB_BACKEND_IBEACON_SIGHTINGS_UPLOAD_PATH
                                parameters:[self dequeueSightingsAndPackageAsRequestParamters]
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSLog(@"Success : Uploaded beacon sightings");
    }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"Error : Beacon sighting upload failed with error :\n%@", error);
    }];
}

- (void)stageBeaconRegion:(NSString *)beaconRegionIdentifier Occupancy:(BOOL)isOccupied{
    [self.beaconRegionOccupancy setValue:[NSNumber numberWithBool:isOccupied]
                                  forKey:beaconRegionIdentifier];
    if (!Underscore.array([self.beaconRegionOccupancy allValues])
    .find(^BOOL(NSNumber *occupancy){
        return [occupancy boolValue];
    }) && ([self.beaconSightingQueue count] > 0)){
        [self uploadAllBeaconSightingsSoFar];
    }
}

-(NSDictionary *)dequeueSightingsAndPackageAsRequestParamters{
    
    NSArray *sightings = Underscore.array(self.beaconSightingQueue)
    .map(^(CLBeacon *beaconSighting){
        return [beaconSighting toDictionary];
    }).unwrap;
    
    [self.beaconSightingQueue removeAllObjects];
    
    return @{@"crumb_id" : [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
             @"sightings" : sightings};
}

@end
