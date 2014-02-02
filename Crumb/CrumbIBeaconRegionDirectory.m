//
//  CrumbIBeaconRegionDirectory.m
//  Crumb
//
//  Created by Arpan Ghosh on 1/24/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconRegionDirectory.h"

@implementation CrumbIBeaconRegionDirectory

+ (NSArray *)getRegionWhitelist{
    return @[[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:CRUMB_IBEACON_REGION_UUID_ALL]
                                                identifier:CRUMB_IBEACON_REGION_IDENTIFIER_ALL]];
}

+ (NSArray *)getRegionBlacklist{
    return @[[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:CRUMB_IBEACON_REGION_UUID_EVIL]
                                                identifier:CRUMB_IBEACON_REGION_IDENTIFIER_EVIL]];
}

+ (NSDictionary *)getCurrentlyMonitoredCrumbRegionsFromBeaconManager:(CLLocationManager *)beaconManager{
    NSMutableDictionary *allPossibleCrumbBeaconRegions =
    [[NSMutableDictionary alloc] init];
    _.array([CrumbIBeaconRegionDirectory getRegionWhitelist])
    .each(^(CLBeaconRegion *beaconRegion){
        [allPossibleCrumbBeaconRegions setValue:beaconRegion
                                         forKey:beaconRegion.identifier];
    });
    _.array([CrumbIBeaconRegionDirectory getRegionBlacklist])
    .each(^(CLBeaconRegion *beaconRegion){
        [allPossibleCrumbBeaconRegions setValue:beaconRegion
                                         forKey:beaconRegion.identifier];
    });
    
    NSMutableDictionary *currentlyMonitoredBeaconRegions =
    [[NSMutableDictionary alloc] init];
    _.array([beaconManager.monitoredRegions allObjects])
    .filter(^BOOL(CLRegion *region){
        return ([region isMemberOfClass:[CLBeaconRegion class]] &&
                ([allPossibleCrumbBeaconRegions valueForKey:region.identifier] != nil));
    })
    .each(^(CLBeaconRegion *beaconRegion){
        [currentlyMonitoredBeaconRegions setValue:beaconRegion
                                           forKey:beaconRegion.identifier];
    });
    return currentlyMonitoredBeaconRegions;
}

+ (BOOL) isAValidCrumbBeaconRegion:(CLRegion *)region{
    if ([region isMemberOfClass:[CLBeaconRegion class]]) {
        return (_.array([CrumbIBeaconRegionDirectory getRegionWhitelist])
                .find(^BOOL(CLBeaconRegion *whitelistedBeaconRegion){
            return [whitelistedBeaconRegion.identifier isEqualToString:region.identifier];
        }) != nil);
    }else{
        return NO;
    }
}

@end
