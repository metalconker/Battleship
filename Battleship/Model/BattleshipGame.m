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
        s = [_joinFleet getShipWithCoord:destination];
    }
    [self removeShipFromMap: s];
    [s positionShip: destination];
    [self updateMap:_hostFleet];
    [self updateMap:_joinFleet];
}
@end
