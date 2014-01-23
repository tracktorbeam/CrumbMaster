//
//  CrumbGimbalBeaconDelegate.m
//  Crumb
//
//  Created by Arpan Ghosh on 1/21/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbGimbalBeaconDelegate.h"

@implementation CrumbGimbalBeaconDelegate

#pragma mark - FYXSightingDelegate Methods

- (void)didReceiveSighting:(FYXTransmitter *)transmitter time:(NSDate *)time RSSI:(NSNumber *)RSSI
{
    // this will be invoked when an authorized transmitter is sighted
    NSLog(@"Independent FYX sighting!!! %@ : %@", transmitter.name, RSSI);
}


#pragma mark - FYXVisitDelegate Methods

- (void)didArrive:(FYXVisit *)visit {
    // This will be invoked when a visit starts
    NSLog(@"FYX visit started!!! %@", visit.transmitter.name);
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI {
    // This will be invoked when a sighting comes in during a visit
    NSLog(@"Visit FYX sighting!!! %@ : %@", visit.transmitter.name, RSSI);
}

- (void)didDepart:(FYXVisit *)visit {
    // This will be invoked when a visit ends
    NSLog(@"FYX visit ended!!! %@ : %f", visit.transmitter.name, visit.dwellTime);
}

@end
