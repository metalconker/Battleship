//
//  BattleshipGame.m
//  Battleship
//
//  Created by Robert Schneidman on 2/9/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "BattleshipGame.h"

@implementation BattleshipGame

-(instancetype) init {
    self = [super init];
    if (self) {
        //Fleet* hostFleet = [[Fleet alloc] initWithPlayerID:1];
        //Fleet* joinFleet = [[Fleet alloc] initWithPlayerID:2];
        self.hostView = [[Map alloc] init];
    }
    return self;
}
@end
