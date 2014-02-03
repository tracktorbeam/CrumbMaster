//
//  CrumbIBeaconUploader.h
//  Crumb
//
//  Created by Arpan Ghosh on 2/2/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import "CrumbIBeaconManager.h"


@interface CrumbIBeaconUploader : NSObject

+(instancetype)getCrumbIBeaconUploader;

-(void)adjustUploadThreshold:(NSInteger)threshold;

-(void)stageBeaconSighting:(CLBeacon *)beacon;

-(void)stageBeaconRegion:(NSString *)beaconRegionIdentifier Occupancy:(BOOL)isOccupied;

@end
