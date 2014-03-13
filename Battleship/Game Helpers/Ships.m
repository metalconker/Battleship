//
//  Ships.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

//
//  Ships.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Ships.h"

@implementation Ships

- (instancetype) initShipsWithNode:(SKNode*) shipsNode
                          andSizes:(Sizes*) sizes
                          andNames:(Names*) names
                           andGame:(BattleshipGame*) game
                         andHelper:(Helpers*) helper
                      andVisualBar:(VisualBar*) visualBar
                     andForeground:(Foreground*) foreground{
    self = [super init];
    if (self) {
        _game = game;
        _names = names;
        _sizes = sizes;
        _shipsNode = shipsNode;
        _helper = helper;
        _visualBar = visualBar;
        _foreground = foreground;
        _movingShip = [[NSMutableArray alloc] init];
        _movingShipOldLocation = [[NSMutableArray alloc] init];
        _movingShipNewLocation = [[NSMutableArray alloc] init];
        [self initShipSprites];
    }
    return self;
}

// Initializes the Ships
- (void) initShipSprites {
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    ShipSegment *s;
    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            if ([_game.gameMap.grid[i][j] isKindOfClass:[ShipSegment class]])
            {
                s = _game.gameMap.grid[i][j];
                if (s.isHead) {
                    
                    if ([s.shipName isEqualToString:@"c1"] || [s.shipName isEqualToString:@"c2"])
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:_names.cruiserImageName];
                    }
                    else if ([s.shipName isEqualToString:@"d1"] || [s.shipName isEqualToString:@"d2"] || [s.shipName isEqualToString:@"d3"])
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:_names.destroyerImageName];
                    }
                    else if ([s.shipName isEqualToString:@"m1"] || [s.shipName isEqualToString:@"m2"])
                    {
                        
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:_names.mineLayerImageName];
                    }
                    else if ([s.shipName isEqualToString:@"r1"])
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:_names.radarBoatImageName];
                        
                    }
                    else if ([s.shipName isEqualToString:@"t1"] || [s.shipName isEqualToString:@"t2"])
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:_names.torpedoBoatImageName];
                    }
                    sprite.name = s.shipName;
                    sprite.yScale = (_sizes.tileHeight * s.shipSize)/sprite.frame.size.height;
                    sprite.xScale = _sizes.tileWidth/sprite.frame.size.width;
                    if (s.location.direction == SOUTH) {
                        sprite.zRotation = M_PI;
                    }
                    sprite.position = [self positionShipSprite:sprite atCoordinate:s.location];
                    [_shipsNode addChild:sprite];
                }
            }
        }
    }
}

// Updates the ship location based on foreground node
- (void) updateShipLocation:(SKNode*) newShipLocation
{
    Coordinate* newLoc = [_helper fromTextureToCoordinate:newShipLocation.position];
    Coordinate* oldLoc = [_helper fromTextureToCoordinate:_visualBar.shipActuallyClicked.position];
    
    
    [_movingShip addObject:_visualBar.shipActuallyClicked];
    [_movingShipOldLocation addObject:oldLoc];
    [_movingShipNewLocation addObject:newLoc];
    
    [_visualBar.shipFunctions removeAllChildren];
    [_visualBar.shipClicked removeAllChildren];
    [_visualBar.shipClickedName removeAllChildren];
    [_foreground.movementLocationsSprites removeAllChildren];
}

// Animates the ship movement - seems to work imperfectly
- (void) animateShips:(NSInteger)intervals{
    
    SKSpriteNode* ship = [_movingShip objectAtIndex:0];
    Coordinate* newCoord = [_movingShipNewLocation objectAtIndex:0];
    Coordinate* oldCoord = [_movingShipOldLocation objectAtIndex:0];
    int difference = newCoord.yCoord - oldCoord.yCoord;
    CGFloat translation = (CGFloat) difference * (100 - intervals)/100;
    
    ship.position = CGPointMake((CGFloat)newCoord.xCoord * _sizes.tileWidth + _sizes.tileWidth/2,
                                ((CGFloat)oldCoord.yCoord) * (CGFloat)_sizes.tileHeight
                                + translation * (CGFloat)_sizes.tileHeight
                                - ship.frame.size.height/2 + _sizes.tileHeight);
    
    if (intervals == 0)
    {
        // Check the direction of the coordinate
        if (newCoord.yCoord > oldCoord.yCoord)
        {
            [oldCoord setDirection:NORTH];
        }
        
        else if (newCoord.yCoord < oldCoord.yCoord)
        {
            [oldCoord setDirection:SOUTH];
        }
        
        else if (newCoord.xCoord > oldCoord.xCoord)
        {
            [oldCoord setDirection:EAST];
        }
        
        else if (newCoord.xCoord < oldCoord.xCoord)
        {
            [oldCoord setDirection:WEST];
        }
        
        [_movingShip removeObjectAtIndex:0];
        [_movingShipNewLocation removeObjectAtIndex:0];
        [_movingShipOldLocation removeObjectAtIndex:0];
        [_game moveShipfrom:oldCoord to:newCoord];
    }
}


-(CGPoint)positionShipSprite:(SKNode *)sprite atCoordinate:(Coordinate *)c {
    if (sprite.zRotation == 0) {
        return CGPointMake((double)c.xCoord * _sizes.tileWidth + _sizes.tileWidth/2 ,
                           (double)c.yCoord * _sizes.tileHeight - sprite.frame.size.height/2 + _sizes.tileHeight);
    }
    else if ((int)sprite.zRotation == (int) M_PI) {
        return CGPointMake((double)c.xCoord * _sizes.tileWidth + _sizes.tileWidth/2 ,
                           (double)c.yCoord * _sizes.tileHeight + sprite.frame.size.height/2);
    }
    else if ((int) sprite.zRotation == (int) M_PI/2) {
        return CGPointMake((double)c.xCoord * _sizes.tileWidth - sprite.frame.size.width/2 + _sizes.tileWidth,
                           (double)c.yCoord * _sizes.tileHeight + _sizes.tileHeight/2);
    }
    else {
        return CGPointMake((double)c.xCoord * _sizes.tileWidth + sprite.frame.size.width/2 + _sizes.tileWidth,
                           (double)c.yCoord * _sizes.tileHeight + _sizes.tileHeight/2);
    }
}




@end