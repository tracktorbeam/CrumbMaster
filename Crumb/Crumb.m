//
//  Crumb.m
//  Crumb
//
//  Created by Arpan Ghosh on 1/22/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "Crumb.h"
#import "CrumbManagerDelegate.h"
#import "CrumbConstants.h"
#import "CrumbManagerGenerator.h"


@implementation Crumb

#pragma mark - Public Methods

+ (void) startSweeping{
    for(id<CrumbManagerDelegate> crumbManager in
        [[CrumbManagerGenerator getCrumbManagers] allValues]){
        [crumbManager startServiceWithSuccess:^(NSDictionary *response) {
            NSLog(@"%@ : Service started successfully", response[CRUMB_SERVICE_NAME_KEY]);
        } withFailure:^(NSDictionary *response, NSError *error) {
            NSLog(@"%@ : Service failed to start with error :\n%@", response[CRUMB_SERVICE_NAME_KEY], error);
        }];
    }
}

+ (void) stopSweeping{
    for(id<CrumbManagerDelegate> crumbManager in
        [[CrumbManagerGenerator getCrumbManagers] allValues]){
        [crumbManager stopService];
    }
}

@end
