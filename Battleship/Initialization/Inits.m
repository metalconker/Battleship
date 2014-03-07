//
//  Inits.m
//  Battleship
//
//  Created by Rayyan Khoury on 2/28/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Inits.h"

@implementation Inits

-(instancetype)initWithOverallScreenNode:(SKNode*)screenNode
               andBattleshipGameInstance:(BattleshipGame*)bGame
                         andHelperInstance:(Helpers*) helperInstance{
    self = [super init];
    if (self) {
        _overallNode = screenNode;
        _game = bGame;
        _helper = helperInstance;
    }
    return self;
}

// Initializes Terrain
- (void) initTerrainSprites{
    
    SKSpriteNode* background1 = [SKSpriteNode spriteNodeWithImageNamed:@"waterBackground"];
    background1.anchorPoint = CGPointZero;
    background1.name = @"background1";
    [_overallNode addChild:background1];
    
    SKSpriteNode* background2 = [SKSpriteNode spriteNodeWithImageNamed:@"waterBackground"];
    background2.anchorPoint = CGPointZero;
    background2.position = CGPointMake(background1.frame.size.width-1, 0);
    background2.name = @"background2";
    [_overallNode addChild:background2];
    
    // Initilizes the different sprites
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    
//    // Drawing the sprites to screen in position
//    for (int i = 0; i < GRID_SIZE; i++)
//    {
//        for (int j = 0; j < GRID_SIZE; j++)
//        {
//            if ([_game.hostView.grid[i][j] isKindOfClass:[NSNumber class]]) {
//                Terrain terType = [_game.hostView.grid[i][j] intValue];
//                switch (terType)
//                {
//                    case HOST_BASE:
//                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MidBase"];
//                        sprite.name = @"hostbase";
//                        sprite.zRotation =  M_PI / 2;
//                        sprite.xScale = 1.7;
//                        sprite.yScale = 2.1;
//                        sprite.position = CGPointMake(i * screenWidth30 + screenWidth30/2,
//                                                      j*heightDiv30 + sprite.frame.size.height/2);
//                        [_screenNode addChild:sprite];
//                        break;
//                        
//                    case JOIN_BASE:
//                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MidBase"];
//                        sprite.name = @"joinbase";
//                        
//                        sprite.xScale = 1.7;
//                        sprite.yScale = 2.1;
//                        sprite.zRotation = 3 * M_PI / 2;
//                        sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
//                        [_screenNode addChild:sprite];
//                        break;
//                        
//                        // need to add an if visible clause
//                    case CORAL:
//                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"coral"];
//                        sprite.name = @"coral";
//                        sprite.zRotation = M_PI / 2;
//                        sprite.xScale = 0.248;
//                        sprite.yScale = 0.338;
//                        sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
//                        [_screenNode addChild:sprite];
//                        break;
//                        
//                    default:
//                        break;
//                        
//                }
//            }
//        }
//    }
}

@end