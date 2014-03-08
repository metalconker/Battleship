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
-(void) displayShipDetails: (SKNode*) shipSprite {
    
    NSMutableArray* shipAndFunctions = [[NSMutableArray alloc] init];

    // Removes previously displayed ship
    [_visualBarNode enumerateChildNodesWithName:@"displayed" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
    // Removes previously displayed text
    [_visualBarNode enumerateChildNodesWithName:@"displayedText" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
    
    // Remove previous nodes
    [_shipFunctions removeAllChildren];
    
    // Ship coordinate
    Coordinate* thisCoordinate = [_helper fromTextureToCoordinate:shipSprite.position];
    
    // Gets the valid actions for this ship
    [_game getValidActionsFrom:thisCoordinate];
    
    // Displays the valid actions on screen
    int i = 1;
//    for (NSString *s in [_game getValidActionsFrom:thisCoordinate])
//    {
//        SKSpriteNode* node = [SKSpriteNode spriteNodeWithImageNamed:s];
//        node.position = CGPointMake(_parentNode.frame.size.width - node.size.width/2, _parentNode.frame.size.height/2 - node.size.height * i);
//        node.name = s;
//        i++;
//        [_parentNode addChild:node];
//        [_functions addObject:node];
//        [shipAndFunctions addObject:node];
//    }
//    
//    _displayedShip = [SKSpriteNode spriteNodeWithImageNamed:shipSprite.name];
//    _displayedShip.zRotation = M_PI / 2;
//    _displayedShip.position = CGPointMake(_parentNode.frame.size.width - _displayedShip.size.width/2 - _visualBarNode.frame.size.width/2, _parentNode.frame.size.height/2);
//    _displayedShip.xScale = 1.5;
//    _displayedShip.yScale = 1.5;
//    _displayedShip.name = @"displayed";
//    [shipAndFunctions addObject: shipSprite];
//    [_parentNode addChild:_displayedShip];
//    
//    _shipName = [SKLabelNode labelNodeWithFontNamed:@"displayedText"];
//    _shipName.name = @"displayedText";
//    [_shipName setText:[self shipName:shipSprite.name]];
//    [_shipName setFontSize:18];
//    [_shipName setPosition:CGPointMake(_parentNode.frame.size.width - _displayedShip.size.width/2 - _visualBarNode.frame.size.width/2, _parentNode.frame.size.height/2 + _displayedShip.size.width * 1.5)];
//    [_parentNode addChild:_shipName];
//    
//    return shipAndFunctions;
//    return nil;
    
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
