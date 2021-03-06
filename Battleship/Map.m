//
//  Map.m
//  Battleship
//
//  Created by Robert Schneidman on 2/5/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Map.h"

@interface Map()

-(void) initializeBase:(NSString*) player;

@end

@implementation Map

- (instancetype) init {
    self = [super init];
    if (self) {
        self.grid = [[NSMutableArray alloc] init];
        for(int i = 0; i<GRID_SIZE; i++){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [self.grid insertObject:array atIndex:i ];
            for(int j = 0; j < GRID_SIZE; j++){
                Terrain t = WATER;
                [self.grid[i] insertObject:[NSNumber numberWithInt:t] atIndex:j];
            }
        }
        [self initializeBase:@"host"];
        
        [self initializeBase:@"join"];
        [self initializeCoral];
    }
    
    return self;
}

-(void) initializeBase:(NSString*) player {
    int i;
    Terrain t;
    if ([player isEqualToString:@"host"]) {
        i = 0;
        t = HOST_BASE;
    }
    if ([player isEqualToString:@"join"]) {
        i = GRID_SIZE - 1;
        t = JOIN_BASE;
    }
    for(int j = BASE_START; j < BASE_START + BASE_LENGTH; j++) {
        [_grid[j] removeObjectAtIndex:i];
        [_grid[j] insertObject:[NSNumber numberWithInt:t] atIndex:i];
    }
}

-(void) initializeCoral {
    NSMutableSet *coralPositions = [[NSMutableSet alloc] init];
    while ([coralPositions count] < 24)    {
        int yCoord = 10 + arc4random_uniform(10);
        int xCoord = 3 + arc4random_uniform(24);
        int breakFlag = 0;
        Coordinate *c = [[Coordinate alloc]initWithXCoordinate:xCoord YCoordinate:yCoord initiallyFacing:NONE];
        for (Coordinate *contained in coralPositions) {
            if (contained.xCoord == c.xCoord && contained.yCoord == c.yCoord) {
                breakFlag = 1;
                continue;
            }
        }
        if (breakFlag == 1) {
            continue;
        }
        [coralPositions addObject:c];
    }
    for (Coordinate *contained in coralPositions)
    {
        Terrain t = CORAL;
        printf("%d,", contained.xCoord);
        printf("%d\n", contained.yCoord);
        [_grid[contained.xCoord] removeObjectAtIndex:contained.yCoord];
        [_grid[contained.xCoord] insertObject:[NSNumber numberWithInt:t] atIndex:contained.yCoord];
    }
}


@end
