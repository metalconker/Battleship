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

-(NSMutableArray *)getHeadLocationsOfMove {
    NSMutableArray* possibleMoves = [[NSMutableArray alloc] init];
    Coordinate* headLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
    ShipSegment* headSeg = self.blocks[0];
    headLocation = headSeg.location;
    for (int i = -1; i <= 1; i++) {
        if (i != 0) {
            switch (headLocation.direction) {
                case NORTH | SOUTH:
                    headLocation.xCoord = headSeg.location.xCoord + i;
                    break;
                case WEST | EAST:
                    headLocation.yCoord = headSeg.location.yCoord + i;
                    break;
                default:
                    break;
            }
            [possibleMoves addObject:headLocation];
        }
    }
    headLocation = headSeg.location;
    switch (headLocation.direction) {
        case NORTH | SOUTH:
            headLocation.xCoord = headSeg.location.xCoord;
            break;
        case WEST | EAST:
            headLocation.yCoord = headSeg.location.yCoord;
            break;
        default:
            break;
    }
    for (int i = -1; i <= self.speed; i++) {
        if (i != 0) {
            switch (headLocation.direction) {
                case NORTH:
                    headLocation.yCoord = headSeg.location.yCoord + i;
                    break;
                case SOUTH:
                    headLocation.yCoord = headSeg.location.yCoord - i;
                    break;
                case WEST:
                    headLocation.xCoord = headSeg.location.xCoord - i;
                    break;
                case EAST:
                    headLocation.xCoord = headSeg.location.xCoord + i;
                    break;
                default:
                    break;
    
            }
            [possibleMoves addObject:headLocation];
        }
    }
    for (Coordinate *headLocation in possibleMoves) {
        Coordinate *tailLocation;
        switch (headLocation.direction) {
            case NORTH:
                tailLocation.xCoord = headLocation.xCoord - (self.size - 1);
                break;
            case SOUTH:
                tailLocation.xCoord = headLocation.xCoord + (self.size - 1);
                break;
            case WEST:
                tailLocation.yCoord = headLocation.xCoord + (self.size - 1);
                break;
            case EAST:
                tailLocation.xCoord = headLocation.xCoord - (self.size - 1);
                break;
            default:
                break;
        }
        if (![headLocation isWithinMap] || ![tailLocation isWithinMap]) {
            [possibleMoves removeObject:headLocation];
        }
    }
    return possibleMoves;
}
@end
