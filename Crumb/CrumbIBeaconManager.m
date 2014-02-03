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

@property (nonatomic, strong) NSError *iBeaconMonitoringNotSupportedError;
@property (nonatomic, strong) NSError *iBeaconMonitoringNotPermittedError;

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

-(NSString *)serviceName{
    return CRUMB_SERVICE_IBEACON_NAME;
}


#pragma mark - Initializers

-(instancetype)init{
    self = [super init];
    if (self){
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

-(NSError *)iBeaconMonitoringNotSupportedError{
    if (!_iBeaconMonitoringNotSupportedError){
        NSDictionary* errorDetails =
        @{NSLocalizedDescriptionKey :
              @"iBeacon monitoring not supported on this device.",
          NSLocalizedFailureReasonErrorKey :
              @"Device lacks Bluetooth hardware or has iOS version older than 7.0."};
        _iBeaconMonitoringNotSupportedError =
        [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                            code:CRUMB_GENERIC_ERROR_CODE
                        userInfo:errorDetails];
    }
    return _iBeaconMonitoringNotSupportedError;
}

-(NSError *)iBeaconMonitoringNotPermittedError{
    if (!_iBeaconMonitoringNotPermittedError){
        NSDictionary* errorDetails =
        @{NSLocalizedDescriptionKey :
              @"iBeacon monitoring not permitted by user.",
          NSLocalizedFailureReasonErrorKey :
              @"User has disabled 'Background App Refresh'."};
        _iBeaconMonitoringNotPermittedError =
        [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                            code:CRUMB_GENERIC_ERROR_CODE
                        userInfo:errorDetails];
    }
    return _iBeaconMonitoringNotPermittedError;
}


#pragma mark - CrumbIBeaconRegionRangingControlDelegate Methods

-(void)startRangingInBeaconRegion:(CLBeaconRegion *)beaconRegion{
    [self.iBeaconManager startRangingBeaconsInRegion:beaconRegion];
}

-(void)stopRangingInBeaconRegion:(CLBeaconRegion *)beaconRegion{
    [self.iBeaconManager stopRangingBeaconsInRegion:beaconRegion];
}

-(void)stopRangingBeacons{
    [self stopRangingBeaconsInAllRegions];
}


#pragma mark - iBeacon Start/Stop Controls

-(void)startIBeacon{
    if (![self iBeaconMonitoringSupportedByDevice]) {
        self.failureCallback(self.iBeaconMonitoringNotSupportedError);
    }
    
    if (![self iBeaconMonitoringPermittedByUser]) {
        self.failureCallback(self.iBeaconMonitoringNotPermittedError);
    }
    
    [self startMonitoringNewIBeaconRegionsInWhitelist];
    [self stopMonitoringIBeaconRegionsInBlacklist];
    self.successCallback();
}

-(void)stopIBeacon{
    [self stopRangingBeaconsInAllRegions];
    [self stopMonitoringAllRegions];
}

-(void)startMonitoringNewIBeaconRegionsInWhitelist{
    NSDictionary *currentlyMonitoredBeaconRegions =
    [CrumbIBeaconRegionDirectory
     getCurrentlyMonitoredCrumbBeaconRegionsFromBeaconManager:self.iBeaconManager];
    
    Underscore.array([CrumbIBeaconRegionDirectory getBeaconRegionWhitelist])
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
     getCurrentlyMonitoredCrumbBeaconRegionsFromBeaconManager:self.iBeaconManager];
    
    Underscore.array([CrumbIBeaconRegionDirectory getBeaconRegionBlacklist])
    .reject(^BOOL (CLBeaconRegion *blacklistedBeaconRegion){
        return ![currentlyMonitoredBeaconRegions
                 valueForKey:blacklistedBeaconRegion.identifier];
    })
    .each(^(CLBeaconRegion *beaconRegionToStopMonitoring){
        [self.iBeaconManager stopMonitoringForRegion:beaconRegionToStopMonitoring];
    });
}

-(void)stopMonitoringAllRegions{
    Underscore.dict([CrumbIBeaconRegionDirectory
     getCurrentlyMonitoredCrumbBeaconRegionsFromBeaconManager:self.iBeaconManager])
    .each(^(NSString *identifier, CLBeaconRegion *beaconRegionToStopMonitoring){
        [self.iBeaconManager stopMonitoringForRegion:beaconRegionToStopMonitoring];
    });
}

-(void)stopRangingBeaconsInAllRegions{
    Underscore.dict([CrumbIBeaconRegionDirectory
            getCurrentlyMonitoredCrumbBeaconRegionsFromBeaconManager:self.iBeaconManager])
    .each(^(NSString *identifier, CLBeaconRegion *beaconRegionToStopMonitoring){
        [self.iBeaconManager stopRangingBeaconsInRegion:beaconRegionToStopMonitoring];
    });
}

@end
