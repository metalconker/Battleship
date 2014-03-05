//
//  BattleshipGame.m
//  Battleship
//
//  Created by Robert Schneidman on 2/9/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "BattleshipGame.h"
@interface BattleshipGame()
@property BOOL hostsTurn;
@property(strong, nonatomic) Fleet* hostFleet;
@property(strong, nonatomic) Fleet* joinFleet;

-(void)updateMap:(Fleet*) updatedFleet;
-(void)removeShipFromMap: (Ship*) s;
@end

@implementation BattleshipGame

-(instancetype) init {
    self = [super init];
    if (self) {
        _hostFleet = [[Fleet alloc] initWithPlayerID:1];
        _joinFleet = [[Fleet alloc] initWithPlayerID:2];
        _hostsTurn = true;
        self.hostView = [[Map alloc] init];
        [self updateMap: _hostFleet];
        [self updateMap: _joinFleet];
    }
    return self;
}
//must remove fleet and then add fleet back

-(void)updateMap:(Fleet*) updatedFleet{
    for(Ship* ship in updatedFleet.shipArray) {
        for(ShipSegment* seg in ship.blocks) {
            [_hostView.grid[seg.location.xCoord] removeObjectAtIndex:seg.location.yCoord];
            [_hostView.grid[seg.location.xCoord] insertObject:seg atIndex:seg.location.yCoord];
        }
    }
}

-(void)removeShipFromMap: (Ship*) s {
    for(ShipSegment* seg in s.blocks) {
        NSLog(@"%d, %d\n", seg.location.xCoord, seg.location.yCoord);
        [_hostView.grid[seg.location.xCoord] removeObjectAtIndex:seg.location.yCoord];
        [_hostView.grid[seg.location.xCoord] insertObject:[NSNumber numberWithInt:WATER] atIndex:seg.location.yCoord];
    }
}

-(void)moveShipfrom:(Coordinate *)origin to:(Coordinate *)destination {
    Ship* s;
    if (_hostsTurn) {
        s = [_hostFleet getShipWithCoord:origin];
        NSLog(@"%@", s.shipName);
    }
    else {
        s = [_joinFleet getShipWithCoord:origin];
    }
    [self removeShipFromMap: s];
    [s positionShip: destination];
    [self updateMap:_hostFleet];
    [self updateMap:_joinFleet];
}

-(NSMutableArray*) getValidMovesFrom:(Coordinate*)origin withRadarPositions:(BOOL)radarPositions {
    Ship* s;
    if (_hostsTurn) {
        s = [_hostFleet getShipWithCoord:origin];
    }
    else {
        s = [_joinFleet getShipWithCoord:origin];
    }
    NSMutableArray *validMoves = [s getHeadLocationsOfMove];
    NSMutableArray *movesToBeRemoved = [[NSMutableArray alloc] init];
    for (NSMutableArray* move in validMoves) {
        for(Coordinate* segmentLocation in move) {
            if ([_hostView.grid[segmentLocation.xCoord][segmentLocation.yCoord] isKindOfClass:[ShipSegment class]]) {
                ShipSegment *seg =_hostView.grid[segmentLocation.xCoord][segmentLocation.yCoord];
                if (![seg.shipName isEqualToString:s.shipName]) {
                    [movesToBeRemoved addObject:move];
                }
            }
            else if ([_hostView.grid[segmentLocation.xCoord][segmentLocation.yCoord] isKindOfClass:[NSNumber class]]) {
                if ([_hostView.grid[segmentLocation.xCoord][segmentLocation.yCoord] intValue] != WATER) {
                    [movesToBeRemoved addObject: move];
                }
                
            }
        }
        
    }
    for (NSMutableArray* move in movesToBeRemoved) {
        [validMoves removeObject:move];
    }
    
    NSMutableArray *validSegmentLocations = [[NSMutableArray alloc] init];
    for (NSMutableArray* move in validMoves) {
        Coordinate *c = move[0];
        [validSegmentLocations addObject:c];
    }
    if (!radarPositions) {
        return validSegmentLocations;
    }
    else {
        NSMutableArray *segmentsWithinMoveRange = [[NSMutableArray alloc] init];
        for (Coordinate* headLocation in validSegmentLocations) {
            [segmentsWithinMoveRange addObject:headLocation];
            if (headLocation.direction == NORTH) {
                if (headLocation.xCoord+1 == s.location.xCoord || headLocation.xCoord-1 == s.location.xCoord) {
                    for (int i = 1; i < s.size; i++) {
                        Coordinate* segLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
                        segLocation.xCoord = headLocation.xCoord;
                        segLocation.yCoord = headLocation.yCoord - i;
                        segLocation.direction = headLocation.direction;
                        [segmentsWithinMoveRange addObject:segLocation];
                    }
                }
            }
            else if (headLocation.direction == SOUTH) {
                if (headLocation.xCoord+1 == s.location.xCoord || headLocation.xCoord-1 == s.location.xCoord) {
                    for (int i = 1; i < s.size; i++) {
                        Coordinate* segLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
                        segLocation.xCoord = headLocation.xCoord;
                        segLocation.yCoord = headLocation.yCoord + i;
                        segLocation.direction = headLocation.direction;
                        [segmentsWithinMoveRange addObject:segLocation];
                    }
                }
            }
            else if (headLocation.direction == WEST) {
                if (headLocation.yCoord+1 == s.location.yCoord || headLocation.yCoord-1 == s.location.yCoord) {
                    for (int i = 1; i < s.size; i++) {
                        Coordinate* segLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
                        segLocation.xCoord = headLocation.xCoord + i;
                        segLocation.yCoord = headLocation.yCoord;
                        segLocation.direction = headLocation.direction;
                        [segmentsWithinMoveRange addObject:segLocation];
                    }
                }
            }
            else if (headLocation.direction == EAST) {
                if (headLocation.xCoord+1 == s.location.yCoord || headLocation.xCoord-1 == s.location.yCoord) {
                    for (int i = 1; i < s.size; i++) {
                        Coordinate* segLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
                        segLocation.xCoord = headLocation.xCoord;
                        segLocation.yCoord = headLocation.yCoord;
                        segLocation.direction = headLocation.direction;
                        [segmentsWithinMoveRange addObject:segLocation];
                    }
                }
            }
            
        }
        return segmentsWithinMoveRange;
    }
}


-(void) fireTorpedo:(Coordinate *)origin {
    Ship* s;
    if (_hostsTurn) {
        s = [_hostFleet getShipWithCoord:origin];
    }
    else {
        s = [_joinFleet getShipWithCoord:origin];
    }
    Coordinate* impactCoord = [_hostView collisionLocationOfTorpedo:s.location];
    
}
/*
-(Coordinate*) getCoordOfShip: (NSString*) shipName {
    Fleet *currentFleet;
    if (_hostsTurn) {
        currentFleet = _hostFleet;
    }
    else {
        currentFleet = _joinFleet;
    }
    for (Ship *s in currentFleet.shipArray) {
        if ([s.shipName isEqualToString:shipName]) {
            return s.location;
        }
    }
    return Nil;
}
 */
@end
