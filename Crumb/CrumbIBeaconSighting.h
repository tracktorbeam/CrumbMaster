//
//  CrumbIBeaconSighting.h
//  Crumb
//
//  Created by Arpan Ghosh on 2/3/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconManager.h"

@interface CrumbIBeaconSighting : NSObject

-(instancetype)initWithBeacon:(CLBeacon *)beacon;

-(NSDictionary *)toDictionary;

@end
