//
//  MyScene.m
//  Battleship
//
//  Created by Rayyan Khoury on 1/30/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "MyScene.h"

// Okay.

// Enum representing what is contained within the array at this specific position for terrain
typedef enum
{
    base1,
    base2,
    coral,
    water
    
} TerrainType;

// Terrain Array that is accessible
NSMutableArray *terrainArray;

// Ship Array of this player
NSMutableArray *thisPlayer;

// Position of player 1 base;
NSMutableArray *player1BasePositions;

// Tracks the movable ship
static NSString * const kShipNodeName = @"movable";

@interface MyScene ()

@property (nonatomic, strong) SKSpriteNode *selectedShip;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        BattleshipGame *game = [[BattleshipGame alloc] init];
        SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
        Terrain ter;
        int widthDiv30 = self.frame.size.width / GRID_SIZE;
        int heightDiv30 = self.frame.size.height / GRID_SIZE;
        for (int i = 0; i < GRID_SIZE; i++)
        {
            for (int j = 0; j < GRID_SIZE; j++)
            {
                ter =  [game.hostView.grid[i][j] intValue];
                switch (ter)
                {
                    case HOST_BASE:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MidBase"];
                        sprite.zRotation = M_PI / 2;
                        break;
                        
                    case JOIN_BASE:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MidBase"];
                        sprite.zRotation = 3 * M_PI / 2;
                        break;
                        
                    case CORAL:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Coral"];
                        sprite.zRotation = 3 * M_PI / 2;
                        break;
                        
                    default:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"PureWater"];
                        sprite.zRotation = M_PI / 2;
                        break;
                        
                }
                sprite.yScale = 2.13;
                sprite.xScale = 1.55;
                sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
                [self addChild:sprite];
            }
        }

    
    }
    return self;
}


/*
 Initializes the ship locations on the base.
 This method uses a previously instantiated array of ship locations for the ships to be loaded.
 Right now it randomly loads them in a position on its base.
 */
- (void)initShips {
    
    int width30 = self.frame.size.width / 30;
    int height30 = self.frame.size.height / 30;
    
    // Loading the images of the ships
    NSArray *imageNames = @[@"Cruiser 2",
                            @"Cruiser 2",
                            @"Destoyer Ship 2",
                            @"Destoyer Ship 2",
                            @"Destoyer Ship 2",
                            @"Torpedo Ship 2",
                            @"Torpedo Ship 2",
                            @"Mine Ship 2",
                            @"Mine Ship 2",
                            @"Radar Boat 2"];
    
    // Copy the player base array
    NSMutableArray *shuffle = [[NSMutableArray alloc] initWithArray:player1BasePositions copyItems:YES];
    
    // Counts the numner of positions
    NSUInteger count = [shuffle count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [shuffle exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    // Load the sprites
    NSNumber *position;
    int pos;
    int width;
    int height;
    NSString *imageName;
    SKSpriteNode *sprite;
    
    for (int i = 0; i < [shuffle count]; i++)
    {
        imageName = [imageNames objectAtIndex:i];
        sprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        
        position = [shuffle objectAtIndex:i];
        pos = [position intValue];
        
        width = pos / 30;
        height = pos % 30;
        
        sprite.yScale = 1;
        sprite.xScale = 1;
        sprite.position = CGPointMake(width*width30 + sprite.frame.size.width/2, height*height30 + sprite.frame.size.height/2);
        [self addChild:sprite];
        
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Pew"];
        
        sprite.position = location;
        
//        sprite.yScale = 2.1;
//        sprite.xScale = 1.55;
        
        //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        //[sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
        
        
    }
    
    [self runAction:[SKAction playSoundFileNamed:@"Pew_Pew-DKnight556-1379997159.mp3" waitForCompletion:NO]];
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    
}

@end
