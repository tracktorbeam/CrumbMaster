//
//  CLBeacon+JSON.m
//  Crumb
//
//  Created by Arpan Ghosh on 2/2/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CLBeacon+JSON.h"

@implementation CLBeacon (JSON)

-(NSDictionary *)toJSON{
    return @{@"uuid" : [self.proximityUUID UUIDString],
             @"major" : self.major,
             @"minor" : self.minor,
             @"accuracy" : [NSNumber numberWithDouble:self.accuracy],
             @"rssi" : [NSNumber numberWithInt:self.rssi],
             @"proximity" : [NSNumber numberWithInt:self.proximity]};
}

@end
