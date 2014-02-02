//
//  Crumb.m
//  Crumb
//
//  Created by Arpan Ghosh on 1/22/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "Crumb.h"
#import "CrumbManagerDelegate.h"
#import "CrumbManagerGenerator.h"


@implementation Crumb

#pragma mark - Public Methods

+ (void) startSweeping{
    _.array([CrumbManagerGenerator getCrumbManagers])
    .each(^(id<CrumbManagerDelegate> crumbManager){
        [crumbManager startServiceWithSuccess:^{
            NSLog(@"%@ : Service started successfully", [crumbManager serviceName]);
        } withFailure:^(NSError *error) {
            NSLog(@"%@ : Service failed to start with error :\n%@", [crumbManager serviceName], error);
        }];
    });
}

+ (void) stopSweeping{
    _.array([CrumbManagerGenerator getCrumbManagers])
    .each(^(id<CrumbManagerDelegate> crumbManager){
        [crumbManager stopService];
    });
}

@end
