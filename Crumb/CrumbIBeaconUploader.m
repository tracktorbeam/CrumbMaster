//
//  CrumbIBeaconUploader.m
//  Crumb
//
//  Created by Arpan Ghosh on 2/2/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconUploader.h"

@interface CrumbIBeaconUploader()

@property (nonatomic, strong) NSMutableArray *beaconSightingQueue;
@property (nonatomic) NSInteger uploadThreshold;
@property (nonatomic, strong) NSMutableDictionary *beaconRegionOccupancy;
@property (nonatomic, strong) AFHTTPRequestOperationManager *beaconSightingUploadManager;

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
        _beaconSightingQueue = [[NSMutableArray alloc] init];
        _uploadThreshold = CRUMB_IBEACON_SIGHTINGS_UPLOAD_THRESHOLD;
        _beaconSightingUploadManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:CRUMB_BACKEND_URL]];
        _beaconRegionOccupancy = [[NSMutableDictionary alloc] init];
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
    NSLog(@"Starting beacon sighting upload");
    [self.beaconSightingUploadManager POST:CRUMB_BACKEND_IBEACON_SIGHTINGS_UPLOAD_PATH
                                parameters:[self dequeueSightingsAndCreateUploadRequestParamters]
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

-(NSDictionary *)dequeueSightingsAndCreateUploadRequestParamters{
    NSArray *sightings = Underscore.array(self.beaconSightingQueue)
    .map(^(CLBeacon *beaconSighting){
        return [beaconSighting toJSON];
    }).unwrap;
    
    [self.beaconSightingQueue removeAllObjects];
    
    return @{@"crumb_id" : [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
             @"sightings" : sightings};
}

@end
