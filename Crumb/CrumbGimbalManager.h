//
//  CrumbGimbalManager.h
//  Crumb
//
//  Created by Arpan Ghosh on 1/21/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import <FYX/FYX.h>
#import <FYX/FYXSightingManager.h>
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXLogging.h>

#import "CrumbManagerDelegate.h"
#import "CrumbConstants.h"
#import "CrumbGimbalConstants.h"
#import "CrumbGimbalBeaconDelegate.h"



@interface CrumbGimbalManager : NSObject <CrumbManagerDelegate, FYXServiceDelegate>
@end
