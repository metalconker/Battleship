//
//  Background.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Background.h"

@implementation Background

- (instancetype) initBackgroundWithNode:(SKNode*) backgroundNode
                          andSizes:(Sizes*) sizes
                          andNames:(Names*) names
                           andGame:(BattleshipGame*) game{
    self = [super init];
    if (self) {
        _game = game;
        _names = names;
        _sizes = sizes;
        _backgroundNode = backgroundNode;
        [self initBackgroundSprites];
        [self initTerrainSprites];
    }
    return self;
}


// Initializes the Background
- (void) initBackgroundSprites{
    
    SKSpriteNode* background1 = [SKSpriteNode spriteNodeWithImageNamed:_names.waterBackgroundImageName];
    background1.anchorPoint = CGPointZero;
    background1.name = _names.background1SpriteName;
    [_backgroundNode addChild:background1];
    
    SKSpriteNode* background2 = [SKSpriteNode spriteNodeWithImageNamed:_names.waterBackgroundImageName];
    background2.anchorPoint = CGPointZero;
    background2.position = CGPointMake(background1.frame.size.width-1, 0);
    background2.name = _names.background2SpriteName;
    [_backgroundNode addChild:background2];
}

// Initializes Terrain
- (void) initTerrainSprites{
    
    // Initilizes the different sprites
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    
    // Drawing the sprites to screen in position
    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            if ([_game.hostView.grid[i][j] isKindOfClass:[NSNumber class]]) {
                Terrain terType = [_game.hostView.grid[i][j] intValue];
                switch (terType)
                {
                    case HOST_BASE:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:_names.baseImageName];
                        sprite.name = _names.hostBaseSpriteName;
                        sprite.zRotation =  M_PI / 2;
                        sprite.xScale = 1.7;
                        sprite.yScale = 2.1;
                        sprite.position = CGPointMake(i * _sizes.tileWidth + sprite.frame.size.width/2,
                                                      j * _sizes.tileHeight + sprite.frame.size.height/2);
                        [_backgroundNode addChild:sprite];
                        break;
                        
                    case JOIN_BASE:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:_names.baseImageName];
                        sprite.name = _names.joinBaseSpriteName;
                        
                        sprite.xScale = 1.7;
                        sprite.yScale = 2.1;
                        sprite.zRotation = 3 * M_PI / 2;
                        sprite.position = CGPointMake(i * _sizes.tileWidth + sprite.frame.size.width/2,
                                                      j * _sizes.tileHeight + sprite.frame.size.height/2);
                        [_backgroundNode addChild:sprite];
                        break;
                        
                        // need to add an if visible clause
                    case CORAL:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:_names.coralImageName];
                        sprite.name = _names.coralSpriteName;
                        sprite.zRotation = M_PI / 2;
                        sprite.xScale = 0.248;
                        sprite.yScale = 0.338;
                        sprite.position = CGPointMake(i * _sizes.tileWidth + sprite.frame.size.width/2,
                                                      j * _sizes.tileHeight + sprite.frame.size.height/2);
                        [_backgroundNode addChild:sprite];
                        break;
                        
                    default:
                        break;
                        
                }
            }
        }
    }
}

// Scolls the background screens
- (void) scrollBackgrounds {
    SKNode* background1 = [_backgroundNode childNodeWithName:_names.background1SpriteName];
    SKNode* background2 = [_backgroundNode childNodeWithName:_names.background2SpriteName];
    
    background1.position = CGPointMake(background1.position.x-0.5, background1.position.y);
    background2.position = CGPointMake(background2.position.x-0.5,
                                       background2.position.y);
    
    if (background1.position.x < -background1.frame.size.width){
        background1.position = CGPointMake(background2.position.x + background2.frame.size.width,
                                   background1.position.y);
    }
    
    if (background2.position.x < -background2.frame.size.width) {
        background2.position = CGPointMake(background1.position.x + background1.frame.size.width,
                                           background2.position.y);
    }
}

@end
