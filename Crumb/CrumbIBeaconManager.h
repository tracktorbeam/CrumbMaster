//
//  CrumbIBeaconManager.h
//  Crumb
//
//  Created by Arpan Ghosh on 1/24/14.
//  Copyright (c) 2014 Tracktor Beam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Underscore.m/Underscore.h>
#import <AFNetworking/AFNetworking.h>
#import <AdSupport/AdSupport.h>


#import "CrumbManagerDelegate.h"
#import "CrumbConstants.h"
#import "CrumbIBeaconConstants.h"
#import "CrumbIBeaconRegionDirectory.h"
#import "CrumbIBeaconDelegate.h"
#import "CrumbIBeaconRegionRangingControlDelegate.h"
#import "CrumbIBeaconUploader.h"
#import "CLBeacon+Dictionary.h"

@interface CrumbIBeaconManager : NSObject <CrumbManagerDelegate, CrumbIBeaconRegionRangingControlDelegate>

@end
