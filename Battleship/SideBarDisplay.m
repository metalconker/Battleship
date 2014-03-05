//
//  SideBarDisplay.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-03.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "SideBarDisplay.h"

@implementation SideBarDisplay

-(instancetype) initWithParentNode:(SKNode *)parent andVisualBarNode:(SKNode*) visualBar usingGame:(BattleshipGame *)game andHelperInstance: (Helpers*) helper{
    self = [super init];
    if (self) {
        _helper = helper;
        _parentNode = parent;
        _visualBarNode = visualBar;
        _displayedShip = [[SKSpriteNode alloc] init];
        _shipName = [[SKLabelNode alloc] init];
        _functions = [[NSMutableArray alloc] init];
        _game = game;
    }
    return self;
}

-(NSMutableArray*) displayShipDetails: (SKNode*) shipSprite {
    
    NSMutableArray* shipAndFunctions = [[NSMutableArray alloc] init];
    // If there has been a ship previously displayed
    if ([_displayedShip.name isEqualToString:@"displayed"])
    {
        //[self removeChild:]
        [_parentNode enumerateChildNodesWithName:@"displayed" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        
    }
    // If there has been a ship previously displayed
    if ([_shipName.name isEqualToString:@"displayedText"])
    {
        //[self removeChild:]
        [_parentNode enumerateChildNodesWithName:@"displayedText" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        
    }
    
    // Remove previous nodes
    for (SKSpriteNode* sprite in _functions)
    {
        [_parentNode enumerateChildNodesWithName:sprite.name usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
    }
    
    // Delete all previously allocated functions
    [_functions removeAllObjects];
   
    // Ship coordinate
    Coordinate* thisCoordinate = [_helper fromTextureToCoordinate:shipSprite.position];
    
    // Gets the valid actions for this ship
    [_game getValidActionsFrom:thisCoordinate];
    
    // Displays the valid actions on screen
    int i = 1;
    for (NSString *s in [_game getValidActionsFrom:thisCoordinate])
    {
        SKSpriteNode* node = [SKSpriteNode spriteNodeWithImageNamed:s];
        node.position = CGPointMake(_parentNode.frame.size.width - node.size.width/2, _parentNode.frame.size.height/2 - node.size.height * i);
        node.name = s;
        i++;
        [_parentNode addChild:node];
        [_functions addObject:node];
        [shipAndFunctions addObject:node];
    }
    
    _displayedShip = [SKSpriteNode spriteNodeWithImageNamed:shipSprite.name];
    _displayedShip.zRotation = M_PI / 2;
    _displayedShip.position = CGPointMake(_parentNode.frame.size.width - _displayedShip.size.width/2 - _visualBarNode.frame.size.width/2, _parentNode.frame.size.height/2);
    _displayedShip.xScale = 1.5;
    _displayedShip.yScale = 1.5;
    _displayedShip.name = @"displayed";
    [shipAndFunctions addObject: shipSprite];
    [_parentNode addChild:_displayedShip];
    
    _shipName = [SKLabelNode labelNodeWithFontNamed:@"displayedText"];
    _shipName.name = @"displayedText";
    [_shipName setText:[self shipName:shipSprite.name]];
    [_shipName setFontSize:18];
    [_shipName setPosition:CGPointMake(_parentNode.frame.size.width - _displayedShip.size.width/2 - _visualBarNode.frame.size.width/2, _parentNode.frame.size.height/2 + _displayedShip.size.width * 1.5)];
    [_parentNode addChild:_shipName];
    
    return shipAndFunctions;
    return nil;
    
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
