//
//  CrumbIBeaconManager.h
//  Crumb
//
//  Created by Arpan Ghosh on 1/24/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//


#import "CrumbManagerDelegate.h"
#import "CrumbIBeaconConstants.h"
#import "CrumbIBeaconRegionDirectory.h"
#import "CrumbIBeaconDelegate.h"
#import "CrumbIBeaconRegionRangingControlDelegate.h"

@interface CrumbIBeaconManager : NSObject <CrumbManagerDelegate, CrumbIBeaconRegionRangingControlDelegate>

@end
