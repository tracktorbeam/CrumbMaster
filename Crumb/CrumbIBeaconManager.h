//
//  CrumbIBeaconManager.h
//  Crumb
//
//  Created by Arpan Ghosh on 1/24/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Underscore.m/Underscore.h>


#import "CrumbManagerDelegate.h"
#import "CrumbConstants.h"
#import "CrumbIBeaconConstants.h"
#import "CrumbIBeaconRegionDirectory.h"
#import "CrumbIBeaconDelegate.h"
#import "CrumbIBeaconRegionRangingControlDelegate.h"

@interface CrumbIBeaconManager : NSObject <CrumbManagerDelegate, CrumbIBeaconRegionRangingControlDelegate>

@end
