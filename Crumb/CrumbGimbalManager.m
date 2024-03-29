//
//  CrumbGimbalManager.m
//  Crumb
//
//  Created by Arpan Ghosh on 1/21/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbGimbalManager.h"


@interface CrumbGimbalManager() 

@property (nonatomic, strong) CrumbGimbalBeaconDelegate *crumbGimbalBeaconDelegate;
@property (nonatomic, strong) FYXSightingManager *gimbalSightingManager;
@property (nonatomic, strong) FYXVisitManager *gimbalVisitManager;

@property (nonatomic) BOOL gimbalServiceActive;
@property (nonatomic) BOOL gimbalBeaconScanningActive;

@property (nonatomic, weak) void (^successCallback)(void);
@property (nonatomic, weak) void (^failureCallback)(NSError *);

@end


@implementation CrumbGimbalManager


#pragma mark - FYXServiceDelegate Methods

-(void)serviceStarted{
    self.gimbalServiceActive = YES;
    [self startGimbalBeaconScanning];
    self.successCallback();
}

-(void)startServiceFailed:(NSError *)error{
    [self stopService];
    self.failureCallback(error);
}


#pragma mark - CrumbManagerDelegate Methods

+(id<CrumbManagerDelegate>)getCrumbManager{
    static CrumbGimbalManager *singletonCrumbGimbalManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonCrumbGimbalManager = [[self alloc] init];
    });
    return singletonCrumbGimbalManager;
}

-(void)startServiceWithSuccess:(void (^)(void))successCallback
                   withFailure:(void (^)(NSError *error))failureCallback{
    self.successCallback = successCallback;
    self.failureCallback = failureCallback;
    [self startGimbal];
}

-(void)stopService{
    [self stopGimbal];
}

-(NSString *)serviceName{
    return CRUMB_SERVICE_GIMBAL_NAME;
}


#pragma mark - Initializers

-(instancetype)init{
    self = [super init];
    if (self){
        _gimbalServiceActive = NO;
        _gimbalBeaconScanningActive = NO;
        [[NSUserDefaults standardUserDefaults] setInteger:CRUMB_GIMBAL_POST_TO_SERVER_INTERVAL_IN_SECONDS_VALUE forKey:CRUMB_GIMBAL_POST_TO_SERVER_INTERVAL_IN_SECONDS_KEY];
        [FYX setAppId:CRUMB_GIMBAL_APPLICATION_ID appSecret:CRUMB_GIMBAL_APPLICATION_SECRET callbackUrl:CRUMB_GIMBAL_CALLBACK_URL];
        [FYXLogging setLogLevel:FYX_LOG_LEVEL_VERBOSE];
        //[FYXLogging enableFileLogging];
        
        _crumbGimbalBeaconDelegate = [[CrumbGimbalBeaconDelegate alloc] init];
        
        _gimbalSightingManager = [FYXSightingManager new];
        _gimbalSightingManager.delegate = self.crumbGimbalBeaconDelegate;
        
        _gimbalVisitManager = [FYXVisitManager new];
        _gimbalVisitManager.delegate = self.crumbGimbalBeaconDelegate;
        
    }
    return self;
}


#pragma mark - Gimbal Start/Stop Controls

-(void)startGimbal{
    if (!self.gimbalServiceActive) {
        [FYX startService:self];
    }
}

-(void)startGimbalBeaconScanning{
    if (!self.gimbalBeaconScanningActive) {
        [self.gimbalSightingManager scanWithOptions:@{FYXSightingOptionSignalStrengthWindowKey : [NSNumber numberWithInt: FYXSightingOptionSignalStrengthWindowMedium]}];
        [self.gimbalVisitManager startWithOptions:@{FYXSightingOptionSignalStrengthWindowKey: [NSNumber numberWithInt:FYXSightingOptionSignalStrengthWindowMedium],
                                                    FYXVisitOptionDepartureIntervalInSecondsKey: [NSNumber numberWithInt:CRUMB_GIMBAL_VISIT_DEPARTURE_INTERVAL_IN_SECONDS],
                                                    FYXVisitOptionArrivalRSSIKey: [NSNumber numberWithInt:CRUMB_GIMBAL_VISIT_ARRIVAL_THRESHOLD_RSSI],
                                                    FYXVisitOptionDepartureRSSIKey: [NSNumber numberWithInt:CRUMB_GIMBAL_VISIT_DEPARTURE_THRESHOLD_RSSI]}];
        self.gimbalBeaconScanningActive = YES;
    }
}

-(void)stopGimbalBeaconScanning{
    if (self.gimbalBeaconScanningActive){
        [self.gimbalVisitManager stop];
        [self.gimbalSightingManager stopScan];
        self.gimbalBeaconScanningActive = NO;
    }
    
}

-(void)stopGimbal{
    if (self.gimbalServiceActive){
        [self stopGimbalBeaconScanning];
        [FYX stopService];
        self.gimbalServiceActive = NO;
    }
}

@end
