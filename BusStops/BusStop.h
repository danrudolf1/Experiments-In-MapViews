//
//  BusStop.h
//  BusStops
//
//  Created by dan rudolf on 5/28/14.
//  Copyright (c) 2014 Dan Rudolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BusStop : MKPointAnnotation
@property NSString *name;
@property NSString *latitude;
@property NSString *longetude;
@property NSString *direction;
@property NSArray *stops;

- (BusStop *)initWithStopName:(NSString *)name latitude:(NSString *)lat longetude:(NSString *)lon direction:(NSString *)direction;
- (BusStop *)addStops:(NSString *)stops;

@end
