//
//  Fleet.m
//  Battleship
//
//  Created by Micah Elbaz on 2/5/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Fleet.h"

@implementation Fleet

- (instancetype)initWithPlayerID:(int)playerID
{
    self = [super init];
    if(self){
        Coordinate *c = [[Coordinate alloc] initWithXCoordinate:1 YCoordinate:1 initiallyFacing:NORTH];
        Cruiser *c1 = [[Cruiser alloc] initWithLocation: c];
        Cruiser *c2 = [[Cruiser alloc] initWithLocation: c];
        Cruiser *c3 = [[Cruiser alloc] initWithLocation: c];
        Destroyer *d1 = [[Destroyer alloc] initWithLocation: c];
        Destroyer *d2 = [[Destroyer alloc] initWithLocation: c];
        Destroyer *d3 = [[Destroyer alloc] initWithLocation: c];
        TorpedoBoat *t1 = [[TorpedoBoat alloc] initWithLocation: c];
        TorpedoBoat *t2 = [[TorpedoBoat alloc] initWithLocation: c];
        MineLayer *m1 = [[MineLayer alloc] initWithLocation: c];
        MineLayer *m2 = [[MineLayer alloc] initWithLocation: c];
        RadarBoat *r1 = [[RadarBoat alloc] initWithLocation: c];
        
        self.shipArray = [NSArray arrayWithObjects:c1,c2,c3,d1,d2,d3,t1,t2,m1,m2,r1,nil];
    }
    return self;
}


@end
