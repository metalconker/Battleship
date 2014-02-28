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
            cruiser1 = [[Coordinate alloc] initWithXCoordinate:19 YCoordinate:5 initiallyFacing:NORTH];
            cruiser2 = [[Coordinate alloc] initWithXCoordinate:18 YCoordinate:5 initiallyFacing:NORTH];
            destroyer1 = [[Coordinate alloc] initWithXCoordinate:17 YCoordinate:4 initiallyFacing:NORTH];
            destroyer2 = [[Coordinate alloc] initWithXCoordinate:16 YCoordinate:4 initiallyFacing:NORTH];
            destroyer3 = [[Coordinate alloc] initWithXCoordinate:15 YCoordinate:4 initiallyFacing:NORTH];
            torpedo1 = [[Coordinate alloc] initWithXCoordinate:14 YCoordinate:3 initiallyFacing:NORTH];
            torpedo2 = [[Coordinate alloc] initWithXCoordinate:13 YCoordinate:3 initiallyFacing:NORTH];
            mineLayer1 = [[Coordinate alloc] initWithXCoordinate:12 YCoordinate:2 initiallyFacing:NORTH];
            mineLayer2 = [[Coordinate alloc] initWithXCoordinate:11 YCoordinate:2 initiallyFacing:NORTH];
            radar1 = [[Coordinate alloc] initWithXCoordinate:10 YCoordinate:3 initiallyFacing:NORTH];
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
        Cruiser *c1 = [[Cruiser alloc] initWithLocation: cruiser1 andName: @"Cruiser"];
        Cruiser *c2 = [[Cruiser alloc] initWithLocation: cruiser2 andName:@"Cruiser"];
        Destroyer *d1 = [[Destroyer alloc] initWithLocation: destroyer1 andName:@"Destroyer"];
        Destroyer *d2 = [[Destroyer alloc] initWithLocation: destroyer2 andName:@"Destroyer"];
        Destroyer *d3 = [[Destroyer alloc] initWithLocation: destroyer3 andName:@"Destroyer"];
        TorpedoBoat *t1 = [[TorpedoBoat alloc] initWithLocation: torpedo1 andName:@"TorpedoBoat"];
        TorpedoBoat *t2 = [[TorpedoBoat alloc] initWithLocation: torpedo2 andName:@"TorpedoBoat"];
        MineLayer *m1 = [[MineLayer alloc] initWithLocation: mineLayer1 andName:@"MineLayer"];
        MineLayer *m2 = [[MineLayer alloc] initWithLocation: mineLayer2 andName:@"MineLayer"];
        RadarBoat *r1 = [[RadarBoat alloc] initWithLocation: radar1 andName:@"RadarBoat"];
        
       
        // TODO: garbage code
     
        
        self.shipArray = [NSArray arrayWithObjects:c1,c2,d1,d2,d3,t1,t2,m1,m2,r1, nil];
    }
    return self;
}

-(Ship*) getShipWithCoord:(Coordinate *)location {
    for (Ship *s in _shipArray) {
        for (ShipSegment *seg in s.blocks) {
            if (seg.location.xCoord == location.xCoord && seg.location.yCoord == location.yCoord) {
                return s;
            }
        }
    }
    return Nil;
}

@end
