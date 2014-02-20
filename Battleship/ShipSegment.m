//
//  ShipSegment.m
//  Battleship
//
//  Created by Robert Schneidman on 2/8/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "ShipSegment.h"

@implementation ShipSegment

-(instancetype)initWithArmour:(ShipArmour)armour andShipName:(NSString *)name andPosition:(int)cell atLocation:(Coordinate*)initialLocation {
    self = [super init];
    if (self) {
        _segmentArmourType = armour;
        _shipName = name;
        _block = cell;
        _location = initialLocation;
    }
    return self;
}
@end
