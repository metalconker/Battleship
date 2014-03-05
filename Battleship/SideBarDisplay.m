//
//  SideBarDisplay.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-03.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "SideBarDisplay.h"

@implementation SideBarDisplay

-(instancetype) initWithParentNode:(SKNode *)parent andVisualBarNode:(SKNode*) visualBar{
    self = [super init];
    if (self) {
        _parentNode = parent;
        _visualBarNode = visualBar;
        _displayedShip = [[SKSpriteNode alloc] init];
        _shipName = [[SKLabelNode alloc] init];
    }
    return self;
}

-(void) displayShipDetails: (SKNode*) shipSprite {
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
    NSLog(@"%@", shipSprite.name);
    ;    _displayedShip = [SKSpriteNode spriteNodeWithImageNamed:shipSprite.name];
    _displayedShip.zRotation = M_PI / 2;
    _displayedShip.position = CGPointMake(_parentNode.frame.size.width - _displayedShip.size.width/2 - _visualBarNode.frame.size.width/2, _parentNode.frame.size.height/2);
    _displayedShip.name = @"displayed";
    [_parentNode addChild:_displayedShip];
    
    _shipName = [SKLabelNode labelNodeWithFontNamed:@"displayedText"];
    _shipName.name = @"displayedText";
    [_shipName setText:shipSprite.name];
    [_shipName setFontSize:18];
    [_shipName setPosition:CGPointMake(_parentNode.frame.size.width - _displayedShip.size.width/2 - _visualBarNode.frame.size.width/2, _parentNode.frame.size.height/2 - _displayedShip.size.width * 1.5)];
    [_parentNode addChild:_shipName];

}
@end
