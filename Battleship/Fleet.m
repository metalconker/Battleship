//
//  Fleet.m
//  Battleship
//
//  Created by Micah Elbaz on 2/5/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Fleet.h"

@implementation Fleet

#pragma mark - TODO: the coordinate setting system is broken. please fix.

- (instancetype)initWithPlayerID:(int)playerID
{
    self = [super init];
    if(self){
        Coordinate *cruiser1;
        Coordinate *cruiser2;
        Coordinate *destroyer1;
        Coordinate *destroyer2;
        Coordinate *destroyer3;
        Coordinate *torpedo1;
        Coordinate *torpedo2;
        Coordinate *mineLayer1;
        Coordinate *mineLayer2;
        Coordinate *radar1;
        if(playerID == 1){
            cruiser1 = [[Coordinate alloc] initWithXCoordinate:19 YCoordinate:1 initiallyFacing:NORTH];
            cruiser2 = [[Coordinate alloc] initWithXCoordinate:18 YCoordinate:1 initiallyFacing:NORTH];
            destroyer1 = [[Coordinate alloc] initWithXCoordinate:17 YCoordinate:1 initiallyFacing:NORTH];
            destroyer2 = [[Coordinate alloc] initWithXCoordinate:16 YCoordinate:1 initiallyFacing:NORTH];
            destroyer3 = [[Coordinate alloc] initWithXCoordinate:15 YCoordinate:1 initiallyFacing:NORTH];
            torpedo1 = [[Coordinate alloc] initWithXCoordinate:14 YCoordinate:1 initiallyFacing:NORTH];
            torpedo2 = [[Coordinate alloc] initWithXCoordinate:13 YCoordinate:1 initiallyFacing:NORTH];
            mineLayer1 = [[Coordinate alloc] initWithXCoordinate:12 YCoordinate:1 initiallyFacing:NORTH];
            mineLayer2 = [[Coordinate alloc] initWithXCoordinate:11 YCoordinate:1 initiallyFacing:NORTH];
            radar1 = [[Coordinate alloc] initWithXCoordinate:10 YCoordinate:1 initiallyFacing:NORTH];
        }
        else{
            cruiser1 = [[Coordinate alloc] initWithXCoordinate:19 YCoordinate:24 initiallyFacing:SOUTH];
            cruiser2 = [[Coordinate alloc] initWithXCoordinate:18 YCoordinate:24 initiallyFacing:SOUTH];
            destroyer1 = [[Coordinate alloc] initWithXCoordinate:17 YCoordinate:25 initiallyFacing:SOUTH];
            destroyer2 = [[Coordinate alloc] initWithXCoordinate:16 YCoordinate:25 initiallyFacing:SOUTH];
            destroyer3 = [[Coordinate alloc] initWithXCoordinate:15 YCoordinate:25 initiallyFacing:SOUTH];
            torpedo1 = [[Coordinate alloc] initWithXCoordinate:14 YCoordinate:26 initiallyFacing:SOUTH];
            torpedo2 = [[Coordinate alloc] initWithXCoordinate:13 YCoordinate:26 initiallyFacing:SOUTH];
            mineLayer1 = [[Coordinate alloc] initWithXCoordinate:12 YCoordinate:27 initiallyFacing:SOUTH];
            mineLayer2 = [[Coordinate alloc] initWithXCoordinate:11 YCoordinate:27 initiallyFacing:SOUTH];
            radar1 = [[Coordinate alloc] initWithXCoordinate:10 YCoordinate:26 initiallyFacing:SOUTH];
        }
        
        // TODO: Problem is happening in here
        Cruiser *c1 = [[Cruiser alloc] initWithLocation: cruiser1];
        Cruiser *c2 = [[Cruiser alloc] initWithLocation: cruiser2];
        Destroyer *d1 = [[Destroyer alloc] initWithLocation: destroyer1];
        Destroyer *d2 = [[Destroyer alloc] initWithLocation: destroyer2];
        Destroyer *d3 = [[Destroyer alloc] initWithLocation: destroyer3];
        TorpedoBoat *t1 = [[TorpedoBoat alloc] initWithLocation: torpedo1];
        TorpedoBoat *t2 = [[TorpedoBoat alloc] initWithLocation: torpedo2];
        MineLayer *m1 = [[MineLayer alloc] initWithLocation: mineLayer1];
        MineLayer *m2 = [[MineLayer alloc] initWithLocation: mineLayer2];
        RadarBoat *r1 = [[RadarBoat alloc] initWithLocation: radar1];
        
        
        // TODO: garbage code
        c1.location = cruiser1;
        c2.location = cruiser2;
        d1.location = destroyer1;
        d2.location = destroyer2;
        d3.location = destroyer3;
        t1.location = torpedo1;
        t2.location = torpedo2;
        m1.location = mineLayer1;
        m2.location = mineLayer2;
        r1.location = radar1;
        
        // Set ship names;
        c1.shipName = @"c1";
        c2.shipName = @"c2";
        d1.shipName = @"d1";
        d2.shipName = @"d2";
        d3.shipName = @"d3";
        t1.shipName = @"t1";
        t2.shipName = @"t2";
        m1.shipName = @"m1";
        m2.shipName = @"m2";
        r1.shipName = @"r1";
        
        self.shipArray = [NSArray arrayWithObjects:c1,c2,d1,d2,d3,t1,t2,m1,m2,r1,nil];
    }
    return self;
}


@end
