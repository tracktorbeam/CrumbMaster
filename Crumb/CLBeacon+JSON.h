//
//  CLBeacon+JSON.h
//  Crumb
//
//  Created by Arpan Ghosh on 2/2/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconManager.h"

@interface CLBeacon (JSON)

-(NSDictionary *)toJSON;

@end
