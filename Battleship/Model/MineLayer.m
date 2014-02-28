//
//  MineLayer.m
//  Battleship
//
//  Created by Robert Schneidman on 2/3/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "MineLayer.h"

@implementation MineLayer

- (instancetype)initWithLocation:(Coordinate *)initialPosition andName:(NSString *)nameOfShip
{
    self = [super initWithLocation:initialPosition andName:nameOfShip];
    if (self) {
        self.size = 2;
        self.speed = 6;
        self.shipArmourType = HEAVY_ARMOUR;
        for (int i = 0; i < self.size; i++) {
            Coordinate* segCoord = [[Coordinate alloc] init];
            segCoord.direction = initialPosition.direction;
            segCoord.xCoord = initialPosition.xCoord;
            switch (segCoord.direction) {
                case NORTH:
                    segCoord.yCoord = initialPosition.yCoord - i;
                    break;
                case SOUTH:
                    segCoord.yCoord = initialPosition.yCoord + i;
                    break;
                default:
                    break;
            }
            ShipSegment* nextSeg = [[ShipSegment alloc] initWithArmour:HEAVY_ARMOUR andPosition:i atLocation:segCoord belongingToShip:nameOfShip];
            if (i == 0) {
                nextSeg.isHead = YES;
            }
            else {
                nextSeg.isHead = NO;
            }
            self.blocks[i] = nextSeg;
        }
        [self.viableActions addObject:@"Fire with Cannon"];
        self.radarRange.rangeHeight = 6;
        self.radarRange.rangeWidth = 5;
        self.radarRange.startRange = -2;
        self.numMines = 5;
        self.radarRange.rangeHeight = 4;
        self.radarRange.rangeWidth = 5;
        self.radarRange.startRange = -1;
    }
    return self;
}
-(void)rotate:(Rotation)destination{
    if(destination == RIGHT){
        if(self.location.direction == NORTH){
            self.location.xCoord+=1;
            self.location.yCoord-=1;
            self.location.direction=EAST;
        }
        if(self.location.direction == SOUTH){
            self.location.xCoord-=1;
            self.location.yCoord+=1;
            self.location.direction=WEST;
        }
        if(self.location.direction == WEST){
            self.location.xCoord+=1;
            self.location.yCoord+=1;
            self.location.direction=NORTH;
        }
        if(self.location.direction == EAST){
            self.location.xCoord-=1;
            self.location.yCoord-=1;
            self.location.direction=SOUTH;
        }
    }
    if(destination == LEFT){
        if(self.location.direction == NORTH){
            self.location.xCoord-=1;
            self.location.yCoord-=1;
            self.location.direction=WEST;
        }
        if(self.location.direction == SOUTH){
            self.location.xCoord+=1;
            self.location.yCoord+=1;
            self.location.direction=EAST;
        }
        if(self.location.direction == WEST){
            self.location.xCoord+=1;
            self.location.yCoord-=1;
            self.location.direction=SOUTH;
        }
        if(self.location.direction == EAST){
            self.location.xCoord-=1;
            self.location.yCoord+=1;
            self.location.direction=NORTH;
        }
    }
}

@end
