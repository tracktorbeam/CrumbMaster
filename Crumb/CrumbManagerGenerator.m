//
//  CrumbManagerGenerator.m
//  Crumb
//
//  Created by Arpan Ghosh on 1/22/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbManagerGenerator.h"

@implementation CrumbManagerGenerator

#pragma mark - Public Methods

+(NSArray *)getCrumbManagers{
    //Fetch from backend.
    
    return @[[CrumbGimbalManager getCrumbManager],
             [CrumbIBeaconManager getCrumbManager]];
}

@end
