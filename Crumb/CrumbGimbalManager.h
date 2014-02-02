//
//  CrumbGimbalManager.h
//  Crumb
//
//  Created by Arpan Ghosh on 1/21/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import <GimbalProximity/FYX.h>
#import <GimbalProximity/FYXSightingManager.h>
#import <GimbalProximity/FYXVisitManager.h>
#import <GimbalProximity/FYXLogging.h>

#import "CrumbManagerDelegate.h"
#import "CrumbGimbalConstants.h"
#import "CrumbGimbalBeaconDelegate.h"



@interface CrumbGimbalManager : NSObject <CrumbManagerDelegate, FYXServiceDelegate>
@end
