//
//  Coordinate.m
//  Battleship
//
//  Created by Robert Schneidman on 2/5/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate

-(instancetype) initWithXCoordinate:(int)xCoordinate
                        YCoordinate:(int)yCoordinate
                    initiallyFacing:(Direction)facingDirection {
    self = [super init];
    if (self) {
        _xCoord = xCoordinate;
        _yCoord = yCoordinate;
        _direction = facingDirection;
    }
    return self;
}

@end
