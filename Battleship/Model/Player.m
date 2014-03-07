//
//  Player.m
//  Battleship
//
//  Created by Micah Elbaz on 3/5/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype) init {
    self = [super init];
    if (self) {
        
        self.radarGrid = [[NSMutableArray alloc] init];
        for(int i = 0; i<GRID_SIZE; i++){
            self.radarGrid[i] = [[NSMutableArray alloc] init];
            for(int j = 0; j < GRID_SIZE; j++){
                
                [self.radarGrid[i] insertObject:[NSNumber numberWithBool:NO] atIndex:j];          }
        }
    }
    self.playerFleet = [[Fleet alloc] initWithPlayerID:_playerID];
    return self;
}




@end
