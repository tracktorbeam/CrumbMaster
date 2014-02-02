//
//  CrumbIBeaconManager.m
//  Crumb
//
//  Created by Arpan Ghosh on 1/24/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconManager.h"

@interface CrumbIBeaconManager()

@property (nonatomic, strong) CLLocationManager *iBeaconManager;
@property (nonatomic, strong) id<CLLocationManagerDelegate> iBeaconDelegate;

@property (nonatomic, weak) void (^successCallback)(void);
@property (nonatomic, weak) void (^failureCallback)(NSError *);

@property (nonatomic) BOOL iBeaconServiceActive;
@property (nonatomic) BOOL iBeaconBeaconScanningActive;

@end


@implementation CrumbIBeaconManager

#pragma mark - CrumbManagerDelegate Methods

+(id<CrumbManagerDelegate>)getCrumbManager{
    static CrumbIBeaconManager *singletonCrumbIBeaconManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonCrumbIBeaconManager = [[self alloc] init];
    });
    return singletonCrumbIBeaconManager;
}

-(void)startServiceWithSuccess:(void (^)(void))successCallback
                   withFailure:(void (^)(NSError *error))failureCallback{
    self.successCallback = successCallback;
    self.failureCallback = failureCallback;
    [self startIBeacon];
}

-(void)stopService{
    [self stopIBeacon];
}

-(BOOL)serviceActive{
    return self.iBeaconServiceActive;
}

-(BOOL)beaconScanningActive{
    return self.iBeaconBeaconScanningActive;
}

-(NSString *)serviceName{
    return CRUMB_SERVICE_IBEACON_NAME;
}


#pragma mark - Initializers

-(instancetype)init{
    self = [super init];
    if (self){
        _iBeaconServiceActive = NO;
        _iBeaconBeaconScanningActive = NO;
        
        _iBeaconDelegate = [[CrumbIBeaconDelegate alloc] init];
        _iBeaconManager = [[CLLocationManager alloc] init];
        _iBeaconManager.activityType = CLActivityTypeFitness;
        _iBeaconManager.delegate = _iBeaconDelegate;
    }
    return self;
}


#pragma mark - iBeacon Compatibility Determination Methods

- (BOOL) iBeaconMonitoringSupportedByDevice{
    BOOL isRangingPossibleOnDevice = [CLLocationManager isRangingAvailable];
    BOOL isBeaconMonitoringPossibleOnDevice
    = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    return (isBeaconMonitoringPossibleOnDevice && isRangingPossibleOnDevice);
}

- (BOOL) iBeaconMonitoringPermittedByUser{
    BOOL hasUserEnabledBackgroundAppRefresh =
    [UIApplication sharedApplication].backgroundRefreshStatus
    == UIBackgroundRefreshStatusAvailable;
    // Need another 'limited' mode for when 'Background App Refresh'
    // is disabled, which only performs active ranging whenever the app
    // is in the foreground.
    return hasUserEnabledBackgroundAppRefresh;
}

- (BOOL) iBeaconMonitoringPossible{
    return ([self iBeaconMonitoringSupportedByDevice] &&
            [self iBeaconMonitoringPermittedByUser]);
}


#pragma mark - CrumbIBeaconRegionMonitoringAndRangingControlDelegate Methods

-(void)stopRangingInBeaconRegion:(CLBeaconRegion *)beaconRegion{
    [self.iBeaconManager stopRangingBeaconsInRegion:beaconRegion];
}

-(void)stopRangingBeacons{
    [self stopRangingBeaconsInAllRegions];
}

-(void)stopMonitoringBeaconRegion:(CLBeaconRegion *)beaconRegion{
    [self.iBeaconManager stopMonitoringForRegion:beaconRegion];
}


#pragma mark - iBeacon Start/Stop Controls

-(void)startIBeacon{
    if ([self iBeaconMonitoringPossible]) {
        [self startMonitoringNewIBeaconRegionsInWhitelist];
        [self stopMonitoringIBeaconRegionsInBlacklist];
    }
}

-(void)stopIBeacon{
    [self stopRangingBeaconsInAllRegions];
    [self stopMonitoringAllRegions];
}

-(void)startMonitoringNewIBeaconRegionsInWhitelist{
    NSDictionary *currentlyMonitoredBeaconRegions =
    [CrumbIBeaconRegionDirectory
     getCurrentlyMonitoredCrumbRegionsFromBeaconManager:self.iBeaconManager];
    
    _.array([CrumbIBeaconRegionDirectory getRegionWhitelist])
    .filter(^BOOL (CLBeaconRegion *whitelistedBeaconRegion){
        return ![currentlyMonitoredBeaconRegions
                 valueForKey:whitelistedBeaconRegion.identifier];
    })
    .each(^(CLBeaconRegion *beaconRegionToStartMonitoring){
        [self.iBeaconManager startMonitoringForRegion:beaconRegionToStartMonitoring];
    });
}

-(void)stopMonitoringIBeaconRegionsInBlacklist{
    NSDictionary *currentlyMonitoredBeaconRegions =
    [CrumbIBeaconRegionDirectory
     getCurrentlyMonitoredCrumbRegionsFromBeaconManager:self.iBeaconManager];
    
    _.array([CrumbIBeaconRegionDirectory getRegionBlacklist])
    .reject(^BOOL (CLBeaconRegion *blacklistedBeaconRegion){
        return ![currentlyMonitoredBeaconRegions
                 valueForKey:blacklistedBeaconRegion.identifier];
    })
    .each(^(CLBeaconRegion *beaconRegionToStopMonitoring){
        [self.iBeaconManager stopMonitoringForRegion:beaconRegionToStopMonitoring];
    });
}

-(void)stopMonitoringAllRegions{
    _.dict([CrumbIBeaconRegionDirectory
     getCurrentlyMonitoredCrumbRegionsFromBeaconManager:self.iBeaconManager])
    .each(^(NSString *identifier, CLBeaconRegion *beaconRegionToStopMonitoring){
        [self.iBeaconManager stopMonitoringForRegion:beaconRegionToStopMonitoring];
    });
}

-(void)stopRangingBeaconsInAllRegions{
    _.dict([CrumbIBeaconRegionDirectory
            getCurrentlyMonitoredCrumbRegionsFromBeaconManager:self.iBeaconManager])
    .each(^(NSString *identifier, CLBeaconRegion *beaconRegionToStopMonitoring){
        [self.iBeaconManager stopRangingBeaconsInRegion:beaconRegionToStopMonitoring];
    });
}



@end
