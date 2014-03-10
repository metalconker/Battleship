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
                         andForeground:(Foreground*) foreground
                             andHelper:(Helpers*) helper{
    self = [super init];
    if (self) {
        _game = game;
        _names = names;
        _sizes = sizes;
        _visualBarNode = visualBarNode;
        _foreground = foreground;
        _helper = helper;
        [self initVisualBarSprite];
        _shipClickedName = [[SKNode alloc] init];
        _shipFunctions = [[SKNode alloc] init];
        _shipClicked = [[SKNode alloc] init];
        [_visualBarNode addChild:_shipClicked];
        [_visualBarNode addChild:_shipFunctions];
        [_visualBarNode addChild:_shipClickedName];
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
- (void) displayShipDetails: (SKSpriteNode*) shipSprite {
    // Remove previous nodes
    [_shipFunctions removeAllChildren];
    [_shipClicked removeAllChildren];
    [_shipClickedName removeAllChildren];
    [_foreground.movementLocationsSprites removeAllChildren];
    
    _shipActuallyClicked = shipSprite;
    
    CGFloat positionFromTop = 0;
    
    positionFromTop += [self displayShipNameWithPositionFromTop:positionFromTop];
    positionFromTop += [self displayShipSpriteWithPositionFromTop:positionFromTop];
    positionFromTop += [self displayHealthBarWithPositionFromTop:positionFromTop];
    positionFromTop += [self displayValidMovesWithPositionFromTop:positionFromTop];
    
}

// Displays the ship name
- (float) displayShipNameWithPositionFromTop: (float) positionFromTop
{
    SKLabelNode *shipLabel = [SKLabelNode labelNodeWithFontNamed:@"displayedText"];
    [shipLabel setText:[self shipName:_shipActuallyClicked.name]];
    [shipLabel setFontSize:30];
    positionFromTop += shipLabel.frame.size.height*1.5;
    [shipLabel setPosition:CGPointMake(_sizes.fullScreenWidth - _sizes.visualBarWidth/2,
                                       _sizes.visualBarHeight - positionFromTop)];
    [_shipClickedName addChild:shipLabel];
    return positionFromTop;
}

// Displays the ship sprite
- (float) displayShipSpriteWithPositionFromTop:(float) positionFromTop
{
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:_shipActuallyClicked.name];
    ship.name = _shipActuallyClicked.name;
    ship.zRotation = M_PI / 2;
    ship.xScale = 1.5;
    ship.yScale = 1.5;
    positionFromTop += ship.frame.size.height*1.5;
    ship.position = CGPointMake(_sizes.fullScreenWidth - _sizes.visualBarWidth/2,
                                _sizes.visualBarHeight - positionFromTop);
    [_shipClicked addChild:ship];
    return positionFromTop;
}

// Displays the health bar
- (float) displayHealthBarWithPositionFromTop:(float) positionFromTop
{
    NSMutableArray *shipDamages = [_game getShipDamages:[_helper fromTextureToCoordinate:_shipActuallyClicked.position]];
    SKSpriteNode *damage;
    NSNumber *armour;
    positionFromTop += [_shipClicked childNodeWithName:_shipActuallyClicked.name].frame.size.height;
    for (int i = 0; i < [shipDamages count]; i++)
    {
        armour = [shipDamages objectAtIndex:i];
        
        if ([armour intValue] == 0)
        {
            NSLog(@"hello");
            damage = [SKSpriteNode spriteNodeWithImageNamed:_names.destroyedArmourImageName];
        }
        
        else if ([armour intValue] == 1)
        {
            NSLog(@"hello2");
            damage = [SKSpriteNode spriteNodeWithImageNamed:_names.normalArmourImageName];
        }
        
        else if ([armour intValue] == 2)
        {
            NSLog(@"hello3");
            damage = [SKSpriteNode spriteNodeWithImageNamed:_names.heavyArmourImageName];
        }
        
        damage.xScale = (([_shipClicked childNodeWithName:_shipActuallyClicked.name].frame.size.width)/[shipDamages count])/damage.frame.size.width;
        damage.yScale = 0.3;
        damage.position = CGPointMake(_sizes.fullScreenWidth + (i * damage.frame.size.width)
                                      - _sizes.visualBarWidth/2
                                      - (((((float)[shipDamages count]-1)/2) * damage.frame.size.width)),
                                      _sizes.visualBarHeight - positionFromTop);
        NSLog(@"xposition: %f", damage.position.x);
        [_shipClicked addChild:damage];
    }
    return positionFromTop;
}

// Displays the valid moves for this ship
- (float) displayValidMovesWithPositionFromTop:(float) positionFromTop
{
    // Gets the valid actions for this ship
    [_game getValidActionsFrom:[_helper fromTextureToCoordinate:_shipActuallyClicked.position]];
    
    // Displays the valid actions on screen
    int i = 1;
    for (NSString *s in [_game getValidActionsFrom:[_helper fromTextureToCoordinate:_shipActuallyClicked.position]])
    {
        SKSpriteNode* node = [SKSpriteNode spriteNodeWithImageNamed:s];
        positionFromTop += node.frame.size.height;
        node.position = CGPointMake(_sizes.fullScreenWidth - _sizes.visualBarWidth/2,
                                    _sizes.visualBarHeight - positionFromTop);
        node.name = s;
        i++;
        [_shipFunctions addChild:node];
    }
    return positionFromTop;
}

// Detects which function is clicked
- (void) detectFunction:(SKNode*) functionSprite {
    
    if ([functionSprite.name isEqual:_names.moveImageName])
    {
        [_foreground displayMoveAreasForShip:_shipActuallyClicked];
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