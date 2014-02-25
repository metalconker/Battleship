//
//  Cruiser.m
//  Battleship
//
//  Created by Robert Schneidman on 1/27/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Cruiser.h"

@interface Cruiser()

@end

@implementation Cruiser

- (instancetype)initWithLocation:(Coordinate *)initialPosition andName:(NSString *)nameOfShip
{
    self = [super initWithLocation:initialPosition andName:nameOfShip];
    if (self) {
        self.size = 5;
        self.speed = 10;
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
            if (i == self.size -1) {
                nextSeg.isTail = YES;
            }
            else {
                nextSeg.isTail = NO;
            }
            self.blocks[i] = nextSeg;
        }
        [self.weapons addObject:[NSNumber numberWithInt:HEAVY_CANNON]];
        self.radarRange.rangeHeight = 10;
        self.radarRange.rangeWidth = 3;
        self.radarRange.startRange = 1;
        self.canonRange.rangeHeight = 15;
        self.canonRange.rangeWidth = 11;
        self.canonRange.startRange = -5;
    }
    return self;
}

-(void)rotate:(Rotation)destination{
    if(destination == RIGHT){
        if(self.location.direction == NORTH){
            self.location.xCoord+=4;
            self.location.yCoord-=4;
            self.location.direction=EAST;
        }
        if(self.location.direction == SOUTH){
            self.location.xCoord-=4;
            self.location.yCoord+=4;
            self.location.direction=WEST;
        }
        if(self.location.direction == WEST){
            self.location.xCoord+=4;
            self.location.yCoord+=4;
            self.location.direction=NORTH;
        }
        if(self.location.direction == EAST){
            self.location.xCoord-=4;
            self.location.yCoord-=4;
            self.location.direction=SOUTH;
        }
    }
    if(destination == LEFT){
        if(self.location.direction == NORTH){
            self.location.xCoord-=4;
            self.location.yCoord-=4;
            self.location.direction=WEST;
        }
        if(self.location.direction == SOUTH){
            self.location.xCoord+=4;
            self.location.yCoord+=4;
            self.location.direction=EAST;
        }
        if(self.location.direction == WEST){
            self.location.xCoord+=4;
            self.location.yCoord-=4;
            self.location.direction=SOUTH;
        }
        if(self.location.direction == EAST){
            self.location.xCoord-=4;
            self.location.yCoord+=4;
            self.location.direction=NORTH;
        }
    }
}
@end