//
//  BattleshipGame.m
//  Battleship
//
//  Created by Robert Schneidman on 2/9/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "BattleshipGame.h"
@interface BattleshipGame()

-(void)updateMap:(Fleet*) updatedFleet;

@end

@implementation BattleshipGame

-(instancetype) init {
    self = [super init];
    if (self) {
        //Fleet* hostFleet = [[Fleet alloc] initWithPlayerID:1];
        //Fleet* joinFleet = [[Fleet alloc] initWithPlayerID:2];
        self.hostView = [[Map alloc] init];
        //[self updateMap: hostFleet];
        //[self updateMap: joinFleet];
    }
    return self;
}

-(void)updateMap:(Fleet*) updatedFleet{
    for(Ship* ship in updatedFleet.shipArray) {
        for(ShipSegment* seg in ship.blocks) {
            [_hostView.grid[seg.location.xCoord] removeObjectAtIndex:seg.location.yCoord];
            [_hostView.grid[seg.location.xCoord] insertObject:seg atIndex:seg.location.yCoord];
        }
    }
}

@end
