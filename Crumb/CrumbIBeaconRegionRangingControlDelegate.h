//
//  CrumbIBeaconRegionRangingControlDelegate.h
//  Crumb
//
//  Created by Arpan Ghosh on 2/1/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//


#import "CrumbIBeaconManager.h"

#warning "This protocol should only allow CrumbIBeaconDelegate to notify CrumbIBeaconManager of events."
@protocol CrumbIBeaconRegionRangingControlDelegate <NSObject>
@required

-(void)startRangingInBeaconRegion:(CLBeaconRegion *)beaconRegion;
-(void)stopRangingInBeaconRegion:(CLBeaconRegion *)beaconRegion;
-(void)stopRangingBeacons;

@end
