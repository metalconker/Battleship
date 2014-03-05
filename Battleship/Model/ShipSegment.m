//
//  ShipSegment.m
//  Battleship
//
//  Created by Robert Schneidman on 2/8/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "ShipSegment.h"

@implementation ShipSegment

-(instancetype)initWithArmour:(ShipArmour)armour andPosition:(int)cell atLocation:(Coordinate*)initialLocation belongingToShip:(NSString *)ship withShipSize:(int)shipSize {
    self = [super init];
    if (self) {
        _segmentArmourType = armour;
        _shipName = ship;
        _block = cell;
        _location = initialLocation;
        _shipSize = shipSize;
        self.viableActions = [[NSMutableArray alloc] init];
        [_viableActions addObject:@"Move"];
        [_viableActions addObject:@"Rotate"];
    }
    return self;
}
@end
