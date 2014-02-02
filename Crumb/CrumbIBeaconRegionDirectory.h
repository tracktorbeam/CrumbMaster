//
//  CrumbIBeaconRegionDirectory.h
//  Crumb
//
//  Created by Arpan Ghosh on 1/24/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconManager.h"


@interface CrumbIBeaconRegionDirectory : NSObject

+ (NSArray *)getRegionWhitelist;

+ (NSArray *)getRegionBlacklist;

+ (NSDictionary *)getCurrentlyMonitoredCrumbRegionsFromBeaconManager:(CLLocationManager *)beaconManager;

+ (BOOL) isAValidCrumbBeaconRegion:(CLRegion *)region;

@end
