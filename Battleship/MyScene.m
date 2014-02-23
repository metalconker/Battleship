//
//  MyScene.m
//  Battleship
//
//  Created by Rayyan Khoury on 1/30/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "MyScene.h"


// Ship Array of this player
NSMutableArray *thisPlayer;

// Position of player 1 base;
NSMutableArray *player1BasePositions;

@interface MyScene ()

@property (nonatomic, strong) BattleshipGame *game;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        // Initializing the background - more time efficient as only loads the textures once
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        // Creates the battleship game
        _game = [[BattleshipGame alloc] init];
        // Terrain sprites
        [self initTerrainSprites];
        // MiniMap sprite
        [self initMiniMap];
        
    }
    
    return self;
}

// Draws terrain sprites to screen
- (void) initTerrainSprites {

    // Initilizes the different sprites
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    // Containers
    Terrain ter;
    int widthDiv30 = self.frame.size.width / GRID_SIZE;
    int heightDiv30 = self.frame.size.height / GRID_SIZE;
    // Drawing the sprites to screen in position
    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            ter =  [_game.hostView.grid[i][j] intValue];
            switch (ter)
            {
                case HOST_BASE:
                    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MidBase"];
                    sprite.name = @"hostbase";
                    sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
                    sprite.zRotation =  M_PI / 2;
                    [self addChild:sprite];
                    break;
                    
                case JOIN_BASE:
                    sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
                    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MidBase"];
                    sprite.name = @"joinbase";
                    sprite.zRotation = 3 * M_PI / 2;
                    [self addChild:sprite];
                    break;
                    
                    // need to add an if visible clause
                case CORAL:
                    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Coral"];
                    sprite.name = @"coral";
                    sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
                    sprite.zRotation = 3 * M_PI / 2;
                    [self addChild:sprite];
                    break;
                    
                default:
                    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"PureWater"];
                    sprite.name = @"water";
                    sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
                    sprite.zRotation = M_PI / 2;
                    [self addChild:sprite];
                    break;
                    
            }
        }
    }
}

- (void)initMiniMap{
    
    // Initilize CGPoints
    int mapSize = self.frame.size.height / 4;
    self.miniMapPositions = [[NSMutableArray alloc] init];
    
    // Point locations
    CGPoint point1 = CGPointMake(self.frame.size.width - mapSize, self.frame.size.height - mapSize);
    CGPoint point2 = CGPointMake(mapSize, self.frame.size.height - mapSize);
    CGPoint point3 = CGPointMake(self.frame.size.width - mapSize, mapSize);
    CGPoint point4 = CGPointMake(mapSize, mapSize);
    
    // Adding to array
    [self.miniMapPositions addObject:[NSValue valueWithCGPoint:point1]];
    [self.miniMapPositions addObject:[NSValue valueWithCGPoint:point2]];
    [self.miniMapPositions addObject:[NSValue valueWithCGPoint:point3]];
    [self.miniMapPositions addObject:[NSValue valueWithCGPoint:point4]];

    // Mini Map
    SKSpriteNode *image = [SKSpriteNode spriteNodeWithImageNamed:@"Mini Map"];
    image.name = @"Mini Map";
    image.yScale = 0.3;
    image.xScale = 0.3;
    image.position = [[self.miniMapPositions objectAtIndex:0] CGPointValue];
    [self addChild:image];
    
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

-(void)initLittleMap
{
    
    // Make this map movable and sticks to a particular position (bottom right, bottom left, top right, top left)
    
    // get the screen width and screen height
    int squareSize = self.frame.size.width/4;
    
    // make a square based on this size
    // resize the sprite images according to this size by dividing by 30
    float spriteSquareSize = squareSize / 30;
    
    // for all terrain in terrain array
    Terrain ter;
    NSMutableArray *innerArray;
    SKSpriteNode *sprite;
    
    for (int i = 0; i < [_game.hostView.grid count]; i++)
    {
        innerArray = [_game.hostView.grid objectAtIndex:i];
        
        for (int j = 0; j < [innerArray count]; j++)
        {
            ter = [[innerArray objectAtIndex:j] intValue];
            
            switch (ter)
            {
                case HOST_BASE:
                    // draw base 1
                    break;
                    
                case JOIN_BASE:
                    // draw base 2
                    break;
                    
                case CORAL:
                    // if coral is seen by the ships of THIS player, draw coral. else draw water
                    break;
                    
                default:
                    // draw water
                    break;
                    
            }
        }
    }
    
    
    
    // for this player's ships'
    
    // get the x and y position of this ship
    
    // draw colored ship on mini map at this position
    
    // for enemy's ships
    
    // if visible by this players ships
    
    // draw other colors ship on mini map
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        NSLog(@"Location of touch: %@", NSStringFromCGPoint(location));
        
        SKNode *node = [self nodeAtPoint:location];
        if (YES) NSLog(@"Node name where touch began: %@", node.name);
        
        if ([node.name isEqualToString:@"Mini Map"])
        {
            CGPoint position = [node position];
            NSLog(@"we are touching the mini map bitch");
            //[node setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
            
        }
        
        
        
    }
    
    //[self runAction:[SKAction playSoundFileNamed:@"Pew_Pew-DKnight556-1379997159.mp3" waitForCompletion:NO]];
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint positionInScene = [touch locationInNode:self];
	CGPoint previousPosition = [touch previousLocationInNode:self];
    CGPoint location = [touch locationInNode:self];
    
	CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    
    SKNode *node = [self nodeAtPoint:location];
    CGPoint position = [node position];
    if (YES) NSLog(@"Node name where touch began: %@", node.name);
    
    if ([node.name isEqualToString:@"Mini Map"])
    {
        NSLog(@"we are touching the mini map bitch");
        [node setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
	//CGPoint positionInScene = [touch locationInNode:self];
	//CGPoint previousPosition = [touch previousLocationInNode:self];
    CGPoint location = [touch locationInNode:self];
    
	//CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    
    SKNode *node = [self nodeAtPoint:location];
    //CGPoint position = [node position];
    //if (YES) NSLog(@"Node name where touch began: %@", node.name);
    
    
    
    // Checking min distance between four locations on screen
    if ([node.name isEqualToString:@"Mini Map"])
    {
        NSLog(@"NOT TOUCHING MINI MAP ANYMORE");
        
        CGFloat minDistance = FLT_MAX;
        CGFloat temp;
        CGFloat xDistance = 0;
        CGFloat yDistance = 0;
        CGPoint corner;
        int pos;
        
        for (int i = 0; i < [self.miniMapPositions count]; i++)
        {
            corner = [[self.miniMapPositions objectAtIndex:i] CGPointValue];
            xDistance = corner.x - location.x;
            yDistance = corner.y - location.y;
            temp = sqrt((xDistance * xDistance) + (yDistance * yDistance));
            if (temp < minDistance)
            {
                pos = i;
                minDistance = temp;
            }
            
        }
        
        [node setPosition:[[self.miniMapPositions objectAtIndex:pos] CGPointValue]];
        
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    
}

@end
