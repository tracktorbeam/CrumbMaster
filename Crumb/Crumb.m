//
//  Crumb.m
//  Crumb
//
//  Created by Arpan Ghosh on 1/22/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import <Underscore.m/Underscore.h>

#import "Crumb.h"
#import "CrumbManagerDelegate.h"
#import "CrumbManagerGenerator.h"
#import "CrumbPassManager.h"


@implementation Crumb

#pragma mark - Public Methods

+ (void) startSweeping{
    Underscore.array([CrumbManagerGenerator getCrumbManagers])
    .each(^(id<CrumbManagerDelegate> crumbManager){
        [crumbManager startServiceWithSuccess:^{
            NSLog(@"%@ : Service started successfully", [crumbManager serviceName]);
        } withFailure:^(NSError *error) {
            NSLog(@"%@ : Service failed to start with error :\n%@", [crumbManager serviceName], error);
        }];
    });
    
    [CrumbPassManager getCrumbPassManager];
}

+ (void) stopSweeping{
    Underscore.array([CrumbManagerGenerator getCrumbManagers])
    .each(^(id<CrumbManagerDelegate> crumbManager){
        [crumbManager stopService];
    });
}

@end
