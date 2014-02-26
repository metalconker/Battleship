//
//  Ship.m
//  Battleship
//
//  Created by Robert Schneidman on 1/27/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Ship.h"

@implementation Ship

-(instancetype) initWithLocation:(Coordinate *)initialPosition andName:(NSString *)nameOfShip {
    self = [super init];
    if (self) {
        _shipName = nameOfShip;
        _location = initialPosition;
        self.blocks = [[NSMutableArray alloc] init];
        self.weapons = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)repair {
    for (int i = 0; i < self.size; i++) {
        ShipSegment *nextSeg = self.blocks[i];
        if (nextSeg.segmentArmourType != self.shipArmourType) {
            nextSeg.segmentArmourType = self.shipArmourType;
            break;
        }
    }
}

-(void)positionShip:(Coordinate *)destination {
    _location.xCoord = destination.xCoord;
    _location.yCoord = destination.yCoord;
    _location.direction = destination.direction;
    int i = 0;
    for (ShipSegment* seg in self.blocks) {
        switch (destination.direction) {
            case NORTH:
                seg.location.yCoord = destination.yCoord - i;
                break;
            case SOUTH:
                seg.location.yCoord = destination.yCoord + i;
                break;
            default:
                break;
        }
        i++;
    }
}

-(void)rotate:(Rotation) destination {
 //abstract class
}

@end
