//
//  RadarBoat.m
//  Battleship
//
//  Created by Robert Schneidman on 2/3/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "RadarBoat.h"
#import "ShipSegment.h"

@implementation RadarBoat

#pragma mark - IS EXTENDED RADAR ON IS BROKEN
- (instancetype)initWithLocation:(Coordinate *)initialPosition andName:(NSString *)nameOfShip
{
    self = [super initWithLocation:initialPosition andName:nameOfShip];
    if (self) {
        self.size = 3;
        self.speed = 3;
        self.shipArmourType = NORMAL_ARMOUR;
        for (int i = 0; i < self.size; i++) {
            Coordinate* segCoord = [[Coordinate alloc] init];
            segCoord.direction = initialPosition.direction;
            switch (segCoord.direction) {
                case NORTH:
                    segCoord.xCoord = initialPosition.xCoord - i;
                    break;
                case SOUTH:
                    segCoord.xCoord = initialPosition.xCoord + i;
                    break;
                default:
                    break;
            }
            ShipSegment* nextSeg = [[ShipSegment alloc] initWithArmour:NORMAL_ARMOUR andPosition:i atLocation:segCoord belongingToShip:nameOfShip];
            self.blocks[i] = nextSeg;
        }
        [self.weapons addObject:[NSNumber numberWithInt:CANNON]];
        self.extendedRadarOn = NO;
        self.canonRange.rangeHeight = 5;
        self.canonRange.rangeWidth = 3;
        self.canonRange.startRange = -1;
    }
    return self;
}

@synthesize extendedRadarOn;

- (BOOL) extendedRadarOn
{
    return self.extendedRadarOn;
}

- (void) setExtendedRadarOn:(BOOL)isExtendedRadarOn {
    if (isExtendedRadarOn) {
        self.speed = 0;
        self.radarRange.rangeHeight = 9;
        
    }
    else {
        self.speed = 3;
        self.radarRange.rangeHeight = 6;
    }
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
    if(destination == FULL){
        if(self.location.direction == NORTH){
            self.location.yCoord-=3;
            self.location.direction=SOUTH;
        }
        if(self.location.direction == SOUTH){
            self.location.yCoord+=3;
            self.location.direction=NORTH;
        }
        if(self.location.direction == WEST){
            self.location.xCoord+=3;
            self.location.direction=EAST;
        }
        if(self.location.direction == EAST){
            self.location.xCoord-=3;
            self.location.direction=WEST;
        }
    }
}

@end
