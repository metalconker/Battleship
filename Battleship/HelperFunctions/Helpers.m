//
//  Helpers.m
//  Battleship
//
//  Created by Rayyan Khoury on 2/28/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

-(instancetype) initWithScreenWidth:(float)sWidth
                       screenHeight:(float)sHeight
                     visualBarWidth:(float)vBWidth {
    self = [super init];
    if (self) {
        _screenWidth30 = (sWidth - vBWidth) / GRID_SIZE;
        _screenHeight30 = sHeight / GRID_SIZE;
    }
    return self;
}

// Returns a coordinate of the click to coordinate value
- (Coordinate*) fromTextureToCoordinate:(CGPoint) point {
    return [[Coordinate alloc] initWithXCoordinate:(int)(point.x / _screenWidth30)
                                       YCoordinate:(int)(point.y / _screenHeight30)
                                   initiallyFacing: NONE];
}

// Scolls the background screens
- (void) scrollBackground1:(SKSpriteNode*) bg1 background2:(SKSpriteNode*)bg2 {
    bg1.position = CGPointMake(bg1.position.x-0.5, bg1.position.y);
    bg2.position = CGPointMake(bg2.position.x-0.5, bg2.position.y);

    if (bg1.position.x < -bg1.frame.size.width){
        bg1.position = CGPointMake(bg2.position.x + bg2.size.width, bg1.position.y);
    }

    if (bg2.position.x < -bg2.size.width) {
        bg2.position = CGPointMake(bg1.position.x + bg1.frame.size.width, bg2.position.y);
    }
}

@end
