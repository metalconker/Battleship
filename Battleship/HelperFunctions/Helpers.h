//
//  Helpers.h
//  Battleship
//
//  Created by Rayyan Khoury on 2/28/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"
#import "Map.h"

@interface Helpers : NSObject

@property float screenWidth30;
@property float screenHeight30;
@property float visualBarWidth;

-(instancetype) initWithScreenWidth:(float)sWidth
                       screenHeight:(float)sHeight
                     visualBarWidth:(float)vBWidth;

-(Coordinate*) fromTextureToCoordinate:(CGPoint) point;

- (void) scrollBackground1:(SKSpriteNode*) bg1 background2:(SKSpriteNode*)bg2;

- (CGPoint) positionShipSprite: (SKNode*) sprite atCoordinate: (Coordinate*) c;

@end
