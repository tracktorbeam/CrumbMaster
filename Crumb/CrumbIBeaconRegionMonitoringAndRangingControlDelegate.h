//
//  CrumbIBeaconRegionMonitoringAndRangingControlDelegate.h
//  Crumb
//
//  Created by Arpan Ghosh on 2/1/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//


#import "CrumbIBeaconManager.h"


@protocol CrumbIBeaconRegionMonitoringAndRangingControlDelegate <NSObject>
@required

-(void)stopRangingInBeaconRegion:(CLBeaconRegion *)beaconRegion;
-(void)stopRangingBeacons;
-(void)stopMonitoringBeaconRegion:(CLBeaconRegion *)beaconRegion;

@end
