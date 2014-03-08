//
//  Helpers.m
//  Battleship
//
//  Created by Rayyan Khoury on 2/28/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

-(instancetype) initWithSizes:(Sizes*) sizes {
    self = [super init];
    if (self) {
        _sizes = sizes;
    }
    return self;
}

// Returns a coordinate of the click to coordinate value
- (Coordinate*) fromTextureToCoordinate:(CGPoint) point {
    return [[Coordinate alloc] initWithXCoordinate:(int)(point.x / _sizes.tileWidth)
                                       YCoordinate:(int)(point.y / _sizes.tileHeight)
                                   initiallyFacing: NONE];
}

@end
