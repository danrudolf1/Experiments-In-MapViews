//
//  BusStop.m
//  BusStops
//
//  Created by dan rudolf on 5/28/14.
//  Copyright (c) 2014 Dan Rudolf. All rights reserved.
//

#import "BusStop.h"

@implementation BusStop

- (BusStop *)initWithStopName:(NSString *)name latitude:(NSString *)lat longetude:(NSString *)lon direction:(NSString *)direction{
    
    self.name = name;
    self.latitude = lat;
    self.longetude = lon;
    self.direction = direction;
    return self;
}

- (BusStop *)addStops:(NSString *)stops{
    self.stops = [stops componentsSeparatedByString:@","];
    return self;
}



@end
