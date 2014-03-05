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
    NSMutableArray* viableMoves = [[NSMutableArray alloc] init];
    NSMutableArray* headLocations = [[NSMutableArray alloc] init];
    ShipSegment* headSeg = self.blocks[0];
    for (int i = -1; i <= 1; i++) {
        if (i != 0) {
            Coordinate* headLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
            headLocation.xCoord = headSeg.location.xCoord;
            headLocation.yCoord = headSeg.location.yCoord;
            headLocation.direction = headSeg.location.direction;
            switch (headLocation.direction) {
                case NORTH:
                    headLocation.xCoord = headSeg.location.xCoord + i;
                    break;
                case SOUTH:
                    headLocation.xCoord = headSeg.location.xCoord + i;
                    break;
                case WEST:
                    headLocation.yCoord = headSeg.location.yCoord + i;
                    break;
                case EAST:
                    headLocation.yCoord = headSeg.location.yCoord + i;
                    break;
                default:
                    break;
            }
            [headLocations addObject:headLocation];
        }
    }
    for (int i = -1; i <= self.speed; i++) {
        if (i != 0) {
            Coordinate* headLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
            headLocation.xCoord = headSeg.location.xCoord;
            headLocation.yCoord = headSeg.location.yCoord;
            headLocation.direction = headSeg.location.direction;
            switch (headLocation.direction) {
                case NORTH:
                    headLocation.xCoord = headSeg.location.xCoord;
                    headLocation.yCoord = headSeg.location.yCoord + i;
                    break;
                case SOUTH:
                    headLocation.xCoord = headSeg.location.xCoord;
                    headLocation.yCoord = headSeg.location.yCoord - i;
                    break;
                case WEST:
                    headLocation.xCoord = headSeg.location.xCoord - i;
                    headLocation.yCoord = headSeg.location.yCoord;
                    break;
                case EAST:
                    headLocation.xCoord = headSeg.location.xCoord + i;
                    headLocation.yCoord = headSeg.location.yCoord;
                    break;
                default:
                    break;
    
            }
            [headLocations addObject:headLocation];
        }
    }
    NSMutableArray *coordsToBeRemoved = [[NSMutableArray alloc] init];
    for (Coordinate *headLocation in headLocations) {
        Coordinate *tailLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
        tailLocation.xCoord = headLocation.xCoord;
        tailLocation.yCoord = headLocation.yCoord;
        tailLocation.direction = headLocation.direction;
        switch (headLocation.direction) {
            case NORTH:
                tailLocation.yCoord = headLocation.yCoord - (self.size - 1);
                break;
            case SOUTH:
                tailLocation.yCoord = headLocation.yCoord + (self.size - 1);
                break;
            case WEST:
                tailLocation.xCoord = headLocation.xCoord + (self.size - 1);
                break;
            case EAST:
                tailLocation.xCoord = headLocation.xCoord - (self.size - 1);
                break;
            default:
                break;
        }
        if (![headLocation isWithinMap]) {
            [coordsToBeRemoved addObject:headLocation];
        }
        if(![tailLocation isWithinMap]) {
            [coordsToBeRemoved addObject:headLocation];
        }
    }
    for (Coordinate *c in coordsToBeRemoved) {
        [headLocations removeObject:c];
    }
    for (Coordinate* headLocation in headLocations) {
        NSMutableArray *shipLocations = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.size; i++) {
            Coordinate *segmentLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
            segmentLocation.xCoord = headLocation.xCoord;
            segmentLocation.yCoord = headLocation.yCoord;
            segmentLocation.direction = headLocation.direction;
            switch (segmentLocation.direction) {
                case NORTH:
                    segmentLocation.yCoord = headLocation.yCoord - i;
                    break;
                case SOUTH:
                    segmentLocation.yCoord = headLocation.yCoord - i;
                    break;
                case WEST:
                    segmentLocation.xCoord = headLocation.xCoord - i;
                    break;
                case EAST:
                    segmentLocation.xCoord = headLocation.xCoord - i;
                    break;
                default:
                    break;
            }
            [shipLocations addObject:segmentLocation];
        }
        [viableMoves addObject:shipLocations];
    }
    return viableMoves;
}
@end
