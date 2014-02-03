//
//  CrumbIBeaconRegionDirectory.m
//  Crumb
//
//  Created by Arpan Ghosh on 1/24/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconRegionDirectory.h"

@implementation CrumbIBeaconRegionDirectory

+ (NSArray *)getBeaconRegionWhitelist{
#warning "Fetch this from backend as part of config & persist."
    CLBeaconRegion *all = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:CRUMB_IBEACON_REGION_UUID_ALL]
                                                             identifier:CRUMB_IBEACON_REGION_IDENTIFIER_ALL];
    all.notifyEntryStateOnDisplay = YES;
    return @[all];
}

+ (NSArray *)getBeaconRegionBlacklist{
#warning "Fetch this from backend as part of config & persist."
    return @[[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:CRUMB_IBEACON_REGION_UUID_EVIL]
                                                identifier:CRUMB_IBEACON_REGION_IDENTIFIER_EVIL]];
}

#warning "This method assumes that Crumb is the only entity in the app monitoring any CLBeaconRegions"
+ (NSDictionary *)getCurrentlyMonitoredCrumbBeaconRegionsFromBeaconManager:(CLLocationManager *)beaconManager{
    NSMutableDictionary *currentlyMonitoredBeaconRegions =
    [[NSMutableDictionary alloc] init];
    Underscore.array([beaconManager.monitoredRegions allObjects])
    .filter(^BOOL(CLRegion *region){
        return ([region isMemberOfClass:[CLBeaconRegion class]]);
    })
    .each(^(CLBeaconRegion *beaconRegion){
        [currentlyMonitoredBeaconRegions setValue:beaconRegion
                                           forKey:beaconRegion.identifier];
    });
    return currentlyMonitoredBeaconRegions;
}

+ (BOOL)isAValidCrumbBeaconRegion:(CLRegion *)region{
    if ([region isMemberOfClass:[CLBeaconRegion class]]) {
        return (Underscore.array([CrumbIBeaconRegionDirectory getBeaconRegionWhitelist])
                .find(^BOOL(CLBeaconRegion *whitelistedBeaconRegion){
            return [whitelistedBeaconRegion.identifier isEqualToString:region.identifier];
        }) != nil);
    }else{
        return NO;
    }
}


@end
