//
//  Foreground.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Foreground.h"

@implementation Foreground

- (instancetype) initForegroundWithNode:(SKNode*) foregroundNode
                               andSizes:(Sizes*) sizes
                               andNames:(Names*) names
                                andGame:(BattleshipGame*) game
                              andHelper:(Helpers*)helper{
    self = [super init];
    if (self) {
        _game = game;
        _names = names;
        _sizes = sizes;
        _foregroundNode = foregroundNode;
        _helper = helper;
        _movementLocationsSprites = [[SKNode alloc] init];
        [_foregroundNode addChild:_movementLocationsSprites];
    }
    return self;
}

// Displays the ship movements
- (void)displayMoveAreasForShip:(SKNode*)shipActuallyClicked
{
    NSMutableArray* validMoves = [_game getValidMovesFrom:
                                  [_helper fromTextureToCoordinate:shipActuallyClicked.position]
                                       withRadarPositions:false];
    for (Coordinate* c in validMoves)
    {
        SKSpriteNode* range = [[SKSpriteNode alloc] initWithImageNamed:_names.moveRangeImageName];
        range.xScale = _sizes.tileWidth/range.frame.size.width;
        range.yScale = _sizes.tileHeight/range.frame.size.height;
        range.position = CGPointMake(c.xCoord * _sizes.tileWidth + _sizes.tileWidth/2,
                                     c.yCoord * _sizes.tileHeight + _sizes.tileHeight/2);
        [_movementLocationsSprites addChild:range];
    }
    
}

@end
