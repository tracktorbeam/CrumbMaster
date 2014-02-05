//
//  CrumbIBeaconSighting.m
//  Crumb
//
//  Created by Arpan Ghosh on 2/3/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconSighting.h"

@interface CrumbIBeaconSighting()

@property (nonatomic, strong) NSDate *observedAt;
@property (nonatomic, strong) CLBeacon *beacon;

@end


@implementation CrumbIBeaconSighting

-(instancetype)initWithBeacon:(CLBeacon *)beacon{
    self = [super init];
    if (self){
        self.beacon = beacon;
        self.observedAt = [NSDate date];
    }
    return self;
}

-(NSDictionary *)toDictionary{
    return @{@"observed_at" : self.observedAt,
             @"beacon" : @{@"uuid" : [self.beacon.proximityUUID UUIDString],
                           @"major" : self.beacon.major,
                           @"minor" : self.beacon.minor,
                           @"accuracy" : [NSNumber numberWithDouble:self.beacon.accuracy],
                           @"rssi" : [NSNumber numberWithInt:self.beacon.rssi],
                           @"proximity" : [NSNumber numberWithInt:self.beacon.proximity]}};
}

@end
