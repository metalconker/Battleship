//
//  VisualBar.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "VisualBar.h"

@implementation VisualBar

- (instancetype) initVisualBarWithNode:(SKNode*) visualBarNode
                              andSizes:(Sizes*) sizes
                              andNames:(Names*) names
                               andGame:(BattleshipGame*) game
                    andActiveShipsNode:(SKNode*) activeShipsNode
                             andHelper:(Helpers*) helper{
    self = [super init];
    if (self) {
        _game = game;
        _names = names;
        _sizes = sizes;
        _visualBarNode = visualBarNode;
        _activeShipsNode = activeShipsNode;
        _helper = helper;
        [self initVisualBarSprite];
        _shipClickedName = [[SKNode alloc] init];
        _shipFunctions = [[SKNode alloc] init];
        _shipClicked = [[SKNode alloc] init];
        _movementLocationsSprites = [[SKNode alloc] init];
        [_visualBarNode addChild:_shipClicked];
        [_visualBarNode addChild:_shipFunctions];
        [_visualBarNode addChild:_shipClickedName];
        [_visualBarNode addChild:_movementLocationsSprites];
    }
    return self;
    
}

// Initializes the Visual Bar
- (void)initVisualBarSprite{
    SKSpriteNode* visualBar = [SKSpriteNode spriteNodeWithImageNamed:_names.visualBarImageName];
    visualBar.name = _names.visualBarNodeName;
    visualBar.xScale = _sizes.visualBarWidth/visualBar.frame.size.width;
    visualBar.yScale = _sizes.visualBarHeight/visualBar.frame.size.height;
    visualBar.position = CGPointMake(_sizes.fullScreenWidth - visualBar.frame.size.width/2,
                                     visualBar.frame.size.height/2);
    [_visualBarNode addChild:visualBar];
}

// Displays the ship on the visual bar
- (void) displayShipDetails: (SKNode*) shipSprite {
    // Remove previous nodes
    [_shipFunctions removeAllChildren];
    [_shipClicked removeAllChildren];
    [_shipClickedName removeAllChildren];
    [_movementLocationsSprites removeAllChildren];
    
    _shipActuallyClicked = shipSprite;
    
    // Ship coordinate
    Coordinate* thisCoordinate = [_helper fromTextureToCoordinate:shipSprite.position];
    
    // Gets the valid actions for this ship
    [_game getValidActionsFrom:thisCoordinate];
    
    // Displays the valid actions on screen
    int i = 1;
    for (NSString *s in [_game getValidActionsFrom:thisCoordinate])
    {
        SKSpriteNode* node = [SKSpriteNode spriteNodeWithImageNamed:s];
        node.position = CGPointMake(_sizes.fullScreenWidth - node.size.width/2,
                                    _sizes.visualBarHeight/2 - node.size.height * i);
        node.name = s;
        i++;
        [_shipFunctions addChild:node];
    }

    // Displays the ship
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:shipSprite.name];
    ship.zRotation = M_PI / 2;
    ship.xScale = 1.5;
    ship.yScale = 1.5;
    ship.position = CGPointMake((_sizes.fullScreenWidth - _sizes.visualBarWidth/2) - ship.frame.size.height/2,
                                         _sizes.visualBarHeight/2);
    [_shipClicked addChild:ship];
    
    // Displays the ship name
    SKLabelNode *shipLabel = [SKLabelNode labelNodeWithFontNamed:@"displayedText"];
    [shipLabel setText:[self shipName:shipSprite.name]];
    [shipLabel setFontSize:18];
    [shipLabel setPosition:CGPointMake(_sizes.fullScreenWidth - ship.frame.size.height/2 - _sizes.visualBarWidth/2,
                                               _sizes.visualBarHeight/2 + ship.size.width * 1.5)];
    [_shipClickedName addChild:shipLabel];
}

// Displays the ship movements
- (void) displayMoveAreas
{
    NSMutableArray* validMoves = [_game getValidMovesFrom:
                                  [_helper fromTextureToCoordinate:_shipActuallyClicked.position]
                                       withRadarPositions:false];
    for (Coordinate* c in validMoves)
    {
        NSLog(@"hello");
        SKSpriteNode* range = [[SKSpriteNode alloc] initWithImageNamed:_names.moveRangeImageName];
        range.xScale = _sizes.tileWidth/range.frame.size.width;
        range.yScale = _sizes.tileHeight/range.frame.size.height;
        range.position = CGPointMake(c.xCoord * _sizes.tileWidth + _sizes.tileWidth/2,
                                 c.yCoord * _sizes.tileHeight + _sizes.tileHeight/2);
        [_movementLocationsSprites addChild:range];
    }
    
}

- (void) updateShipLocation:(SKNode*) newShipLocation
{
    Coordinate* c = [_helper fromTextureToCoordinate:newShipLocation.position];
    _shipActuallyClicked.position = CGPointMake((double)c.xCoord * _sizes.tileWidth + _sizes.tileWidth/2,
                                        (double)c.yCoord * _sizes.tileHeight - _shipActuallyClicked.frame.size.height/2 + _sizes.tileHeight);
    [_shipFunctions removeAllChildren];
    [_shipClicked removeAllChildren];
    [_shipClickedName removeAllChildren];
    [_movementLocationsSprites removeAllChildren];
}

- (void) detectFunction:(SKNode*) functionSprite {
 
    if ([functionSprite.name isEqual:_names.moveImageName])
    {
        [self displayMoveAreas];
    }
    
    else if ([functionSprite.name isEqual:_names.rotateImageName])
    {
        
    }
    
    else if ([functionSprite.name isEqual:_names.fireTorpedoImageName])
    {
        
        
    }
    
}

// Changes the ship name to a representable string
-(NSString*) shipName: (NSString*) carbon{
    
    if ([[carbon substringToIndex:1] isEqualToString:@"c"])
    {
        return @"Cruiser";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"d"])
    {
        return @"Destroyer";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"t"])
    {
        return @"Torpedo Boat";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"r"])
    {
        return @"Radar Boat";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"m"])
    {
        return @"Mine Layer";
    }
    
    return carbon;
}

@end
