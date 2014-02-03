//
//  CrumbManagerDelegate.h
//  Crumb
//
//  Created by Arpan Ghosh on 1/22/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "Crumb.h"

@protocol CrumbManagerDelegate <NSObject>
@required

+(instancetype)getCrumbManager;
-(void)startServiceWithSuccess:(void (^)(void))successCallback
                   withFailure:(void (^)(NSError *error))failureCallback;
-(void)stopService;
-(NSString *)serviceName;

@end
