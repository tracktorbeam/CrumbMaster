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

+(NSDictionary *)getCrumbManagers{
    //Fetch from backend.
    
    return @{CRUMB_SERVICE_GIMBAL_NAME : [CrumbGimbalManager getCrumbManager]};
}

@end
