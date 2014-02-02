//
//  CrumbIBeaconManager.h
//  Crumb
//
//  Created by Arpan Ghosh on 1/24/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLBeaconRegion.h>
#import <UIKit/UIKit.h>

#import "CrumbManagerDelegate.h"
#import "CrumbIBeaconConstants.h"
#import "CrumbIBeaconRegionDirectory.h"
#import "CrumbIBeaconDelegate.h"
#import "CrumbIBeaconRegionMonitoringAndRangingControlDelegate.h"

@interface CrumbIBeaconManager : NSObject <CrumbManagerDelegate,
                                            CrumbIBeaconRegionMonitoringAndRangingControlDelegate>

@end
