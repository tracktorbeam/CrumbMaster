//
//  CrumbManagerDelegate.h
//  Crumb
//
//  Created by Arpan Ghosh on 1/22/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//


@protocol CrumbManagerDelegate <NSObject>
@required

+(instancetype)getCrumbManager;
-(void)startServiceWithSuccess:(void (^)(void))successCallback
                   withFailure:(void (^)(NSError *error))failureCallback;
-(void)stopService;
-(BOOL)serviceActive;
-(BOOL)beaconScanningActive;
-(NSString *)serviceName;

@end
