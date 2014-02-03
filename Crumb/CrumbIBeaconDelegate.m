//
//  CrumbIBeaconDelegate.m
//  Crumb
//
//  Created by Arpan Ghosh on 2/1/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconDelegate.h"

@implementation CrumbIBeaconDelegate

#pragma mark - CLLocationManagerDelegate Methods

-(void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    if ([CrumbIBeaconRegionDirectory isAValidCrumbBeaconRegion:region]){
        [[CrumbIBeaconManager getCrumbManager] startRangingInBeaconRegion:(CLBeaconRegion *)region];
        NSLog(@"Entered region %@ and started ranging", region.identifier);
        [[CrumbIBeaconUploader getCrumbIBeaconUploader] stageBeaconRegion:region.identifier
                                                                Occupancy:YES];
    }
}

-(void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    if ([CrumbIBeaconRegionDirectory isAValidCrumbBeaconRegion:region]){
        [[CrumbIBeaconManager getCrumbManager] stopRangingInBeaconRegion:(CLBeaconRegion *)region];
        NSLog(@"Exited region %@ and stopped ranging", region.identifier);
        [[CrumbIBeaconUploader getCrumbIBeaconUploader] stageBeaconRegion:region.identifier
                                                                Occupancy:NO];
    }
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    if ([CrumbIBeaconRegionDirectory isAValidCrumbBeaconRegion:region]){
        switch (state) {
            case CLRegionStateInside:
                NSLog(@"Did determine state for region %@ : Inside", region.identifier);
                [[CrumbIBeaconUploader getCrumbIBeaconUploader] stageBeaconRegion:region.identifier
                                                                        Occupancy:YES];
                break;
            case CLRegionStateOutside:
                NSLog(@"Did determine state for region %@ : Outside", region.identifier);
                [[CrumbIBeaconUploader getCrumbIBeaconUploader] stageBeaconRegion:region.identifier
                                                                        Occupancy:NO];
                break;
            case CLRegionStateUnknown:
                NSLog(@"Did determine state for region %@ : Unknown", region.identifier);
                [[CrumbIBeaconUploader getCrumbIBeaconUploader] stageBeaconRegion:region.identifier
                                                                        Occupancy:NO];
                break;
        }
    }
}

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons
                inRegion:(CLBeaconRegion *)region{
    Underscore.array(beacons)
    .each(^(CLBeacon *beacon){
        NSLog(@"Ranged a beacon in region : %@", region.identifier);
        [[CrumbIBeaconUploader getCrumbIBeaconUploader] stageBeaconSighting:beacon];
    });
}


#warning "Figure out which of these errors requires a call to stageBeaconRegionOccupancy"
- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
#warning "Figure out what kind of retry mechanism (if any) needs to be implemented here."
    if ([CrumbIBeaconRegionDirectory isAValidCrumbBeaconRegion:region]){
        NSLog(@"Error monitoring region %@.\n%@", region.identifier,
              [error localizedDescription]);
    }
}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error{
#warning "Figure out what kind of retry mechanism (if any) needs to be implemented here."
    if ([CrumbIBeaconRegionDirectory isAValidCrumbBeaconRegion:region]){
        NSLog(@"Error ranging beacon region %@.\n%@", region.identifier,
              [error localizedDescription]);
    }
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status != kCLAuthorizationStatusAuthorized) {
        NSLog(@"User has revoked/not yet granted access to use location services");
        [[CrumbIBeaconManager getCrumbManager] stopRangingBeacons];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    switch (error.code) {
        case kCLErrorDenied: //Access to the location service was denied by the user.
        case kCLErrorRegionMonitoringDenied: //Access to the region monitoring service was denied by the user.
        case kCLErrorRangingUnavailable: //Airplane mode or if Bluetooth or location services are disabled
            NSLog(@"Error code : %ld\nError : %@", (long)error.code, [error localizedDescription]);
            //Keep monitoring the Beacon regions, but stop the ranging if it is occurring.
            [[CrumbIBeaconManager getCrumbManager] stopRangingBeacons];
            break;
            
#warning "Figure out what kind of retry mechanism (if any) needs to be implemented here."
        case kCLErrorRangingFailure: //A general ranging error occurred.
            NSLog(@"Error code : %ld\nError : %@", (long)error.code, [error localizedDescription]);
            //Keep monitoring the Beacon regions, but stop the ranging if it is occurring.
            [[CrumbIBeaconManager getCrumbManager] stopRangingBeacons];
            break;

#warning "Figure out the error handling that needs to be implemented here."
            //Non-permission-revocation or non-capability-disablement related errors.
        case kCLErrorRegionMonitoringFailure: //app has exceeded the maximum number of regions that it can monitor simultaneously.
        case kCLErrorRegionMonitoringSetupDelayed: //Core Location could not initialize the region monitoring feature immediately.
        case kCLErrorRegionMonitoringResponseDelayed: //Core Location will deliver events but they may be delayed
        default:
            NSLog(@"Error code : %ld\nError : %@", (long)error.code, [error localizedDescription]);
            break;
    }
}



@end
