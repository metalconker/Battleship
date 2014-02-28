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

Fleet *testFleet;

SKSpriteNode *visualBar;


@interface MyScene()

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;

@property (nonatomic, strong) BattleshipGame *game;
@property UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong) SKNode *screenNode;
@property (nonatomic, strong) Helpers *helper;
@property (nonatomic, strong) SKSpriteNode *bg1;
@property (nonatomic, strong) SKSpriteNode *bg2;
@property (nonatomic, strong) SKNode *nodeTouched;
@property bool miniMapTouched;
@property bool shipClicked;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // Initializing the background - more time efficient as only loads the textures once
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        // Creates the battleship game
        _game = [[BattleshipGame alloc] init];
        
        // The overall image node
        _screenNode = [[SKNode alloc] init];
        
        // Visual Bar sprite
        [self initVisualBar];
        
        // Contains all the map data
        [self addChild:_screenNode];
        
        // Terrain sprites
        [self initTerrainSprites];
        // Ship sprites
        [self initShipSprites];
        Coordinate* testOrigin = [[Coordinate alloc] initWithXCoordinate:10 YCoordinate:3 initiallyFacing:NONE];
        [_game getValidMovesFrom:testOrigin];
        // MiniMap sprite
        [self initMiniMap];
        [self addChild:visualBar];
        
        // Creates the helper functions class
        _helper = [[Helpers alloc] initWithScreenWidth:self.frame.size.width screenHeight:self.frame.size.height visualBarWidth:visualBar.size.width];
    }
    
    return self;
}


// Draws ship sprites to screen
- (void) initShipSprites {
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    int widthDiv30 = (self.frame.size.width-visualBar.frame.size.width) / GRID_SIZE;
    int heightDiv30 = self.frame.size.height / GRID_SIZE;
    ShipSegment *s;
    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            
            if ([_game.hostView.grid[i][j] isKindOfClass:[ShipSegment class]])
            {
                s = _game.hostView.grid[i][j];
                if (s.isHead) {
                    if ([s.shipName isEqualToString:@"c1"] || [s.shipName isEqualToString:@"c2"])
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Cruiser"];
                    }
                    else if ([s.shipName isEqualToString:@"d1"] || [s.shipName isEqualToString:@"d2"] || [s.shipName isEqualToString:@"d3"])
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Destroyer"];
                    }
                    else if ([s.shipName isEqualToString:@"m1"] || [s.shipName isEqualToString:@"m2"])
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MineLayer"];
                    }
                    else if ([s.shipName isEqualToString:@"r1"])
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"RadarBoat"];
                        
                    }
                    else if ([s.shipName isEqualToString:@"t1"] || [s.shipName isEqualToString:@"t2"])
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"TorpedoBoat"];
                    }
                    sprite.name = s.shipName;
                    sprite.position = CGPointMake(s.location.xCoord*widthDiv30 + sprite.frame.size.width/2, s.location.yCoord*heightDiv30 + sprite.frame.size.height/2);
                    [overallImage addChild:sprite];
                }
            }
        }
    }
}
SKSpriteNode *bg1;
SKSpriteNode *bg2;



// Initializes the visual bar
- (void)initVisualBar{
    
    visualBar = [SKSpriteNode spriteNodeWithImageNamed:@"Mini Map"];
    visualBar.name = @"Visual Bar";
    visualBar.yScale = 5;
    visualBar.xScale = 0.5;
    //visualBar.anchorPoint = CGPointZero;
    visualBar.position = CGPointMake(self.frame.size.width - visualBar.frame.size.width/2, visualBar.frame.size.height/2);
    
    //visualBar.position = CGPointMake(0, 0);
    
}

-(void)initShipsMiniMap:(SKNode*) miniMap
{
    
    // Make this map movable and sticks to a particular position (bottom right, bottom left, top right, top left)
    
    // get the screen width and screen height
    //int miniMapDotPositions = miniMap.frame.size.height / 30;
    
    // make a square based on this size
    // resize the sprite images according to this size by dividing by 30
    //float spriteSquareSize = squareSize / 30;
    
    // This player's ships
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    ShipSegment *s;
    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            
            if ([_game.hostView.grid[i][j] isKindOfClass:[ShipSegment class]])
            {
                s = _game.hostView.grid[i][j];
                if (s.isHead) {
                    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Green Dot"];
                    sprite.name = [NSString stringWithFormat:@"%@/Green Dot", s.shipName];
                    sprite.yScale = 0.3;
                    sprite.xScale = 0.3;
                    sprite.position = CGPointMake(s.location.xCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.width*1.4, s.location.yCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.height*1.3);
                    [miniMap addChild:sprite];
                }
            }
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    int widthDiv30 = (self.frame.size.width-visualBar.frame.size.width) / GRID_SIZE;
    int heightDiv30 = self.frame.size.height / GRID_SIZE;
    
    SKSpriteNode *shipDisplay;
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        Coordinate *newMove = [_helper fromTextureToCoordinate:location];
        
        _nodeTouched = [self nodeAtPoint:location];
        
        // If the initial touch was on the mini map
        if ([_nodeTouched.name isEqualToString:@"Mini Map"])
        {
            _miniMapTouched = true;
            
        }
        
        // If the initial touch was a cruiser
        if ([_nodeTouched.name isEqualToString:@"c1"])
        {
            shipDisplay = [SKSpriteNode spriteNodeWithImageNamed:@"Cruiser"];
            shipDisplay.zRotation = M_PI / 2;
            shipDisplay.position = CGPointMake(self.frame.size.width - shipDisplay.size.width/2 - visualBar.frame.size.width/2, self.frame.size.height/2);
            [self addChild:shipDisplay];
            _shipClicked = true;
        }
        
        if (_shipClicked)
        {
            _nodeTouched.position = CGPointMake(newMove.xCoord*widthDiv30 + _nodeTouched.frame.size.width/2, newMove.yCoord*heightDiv30 + _nodeTouched.frame.size.height/2);
        }
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint previousPosition = [touch previousLocationInNode:self];
    CGPoint location = [touch locationInNode:self];
    
    CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    
    SKNode *node = [self nodeAtPoint:location];
    CGPoint position = [node position];
    
    // Mini Map Movement
    if ([node.name isEqualToString:@"Mini Map"])
    {
        [node setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
    }
}

// Called when the finger is removed
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // If the mini map was initially touched
    if (_miniMapTouched)
    {
        [self setMiniMapLocation:location];
    }
}

// Always set the minimap in a specific location - due to bugs with touching
- (void) setMiniMapLocation:(CGPoint)location {
    
    SKNode* minimap = [self childNodeWithName:@"Mini Map"];
    
    CGFloat minDistance = FLT_MAX;
    CGFloat temp;
    CGFloat xDistance = 0;
    CGFloat yDistance = 0;
    CGPoint corner;
    int pos;
    
    // Comparing to the destination nodes
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
    [minimap setPosition:[[self.miniMapPositions objectAtIndex:pos] CGPointValue]];
    _miniMapTouched = false;
    
}

// INITIALIZATION

// Initializes mini map
- (void)initMiniMap{
    
    // Initilize CGPoints
    int mapSize = self.frame.size.height / 6;
    self.miniMapPositions = [[NSMutableArray alloc] init];
    
    // Point locations
    CGPoint point1 = CGPointMake(self.frame.size.width - mapSize - visualBar.frame.size.width, self.frame.size.height - mapSize);
    CGPoint point2 = CGPointMake(mapSize, self.frame.size.height - mapSize);
    CGPoint point3 = CGPointMake(self.frame.size.width - mapSize - visualBar.frame.size.width, mapSize);
    CGPoint point4 = CGPointMake(mapSize, mapSize);
    
    // Adding to array
    [self.miniMapPositions addObject:[NSValue valueWithCGPoint:point1]];
    [self.miniMapPositions addObject:[NSValue valueWithCGPoint:point2]];
    [self.miniMapPositions addObject:[NSValue valueWithCGPoint:point3]];
    [self.miniMapPositions addObject:[NSValue valueWithCGPoint:point4]];
    
    // Mini Map
    SKNode *image = [SKSpriteNode spriteNodeWithImageNamed:@"Mini Map"];
    image.name = @"Mini Map";
    image.yScale = 0.4;
    image.xScale = 0.4;
    image.position = [[self.miniMapPositions objectAtIndex:0] CGPointValue];
    
    // This will keep the dots as children of the image SKNode
    [self initShipsMiniMap:image];
    [self addChild:image];
    
}

// Initializes Ships
- (void) initShipSprites {
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    int widthDiv30 = (self.frame.size.width-visualBar.frame.size.width) / GRID_SIZE;
    int heightDiv30 = self.frame.size.height / GRID_SIZE;
    ShipSegment *s;
    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            
            if ([_game.hostView.grid[i][j] isKindOfClass:[ShipSegment class]])
            {
                s = _game.hostView.grid[i][j];
                if (s.isTail) {
                    if (s.isTail && ([s.shipName isEqualToString:@"c1"] || [s.shipName isEqualToString:@"c2"]))
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Cruiser"];
                    }
                    else if (s.isTail && ([s.shipName isEqualToString:@"d1"] || [s.shipName isEqualToString:@"d2"] || [s.shipName isEqualToString:@"d3"]))
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Destroyer"];
                    }
                    else if (s.isTail && ([s.shipName isEqualToString:@"m1"] || [s.shipName isEqualToString:@"m2"]))
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MineLayer"];
                    }
                    else if (s.isTail && [s.shipName isEqualToString:@"r1"])
                    {
                        NSLog(@"%d, %d\n", s.location.xCoord, s.location.yCoord);
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"RadarBoat"];
                        
                    }
                    else if (s.isTail && ([s.shipName isEqualToString:@"t1"] || [s.shipName isEqualToString:@"t2"]))
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"TorpedoBoat"];
                    }
                    sprite.name = s.shipName;
                    sprite.position = CGPointMake(s.location.xCoord*widthDiv30 + sprite.frame.size.width/2, s.location.yCoord*heightDiv30 + sprite.frame.size.height/2);
                    [_screenNode addChild:sprite];
                }
            }
        }
    }
}

// Initializes Terrain
- (void) initTerrainSprites{
    
    _bg1 = [SKSpriteNode spriteNodeWithImageNamed:@"waterBackground"];
    _bg1.anchorPoint = CGPointZero;
    _bg1.name = @"bg1";
    [_screenNode addChild:_bg1];
    
    _bg2 = [SKSpriteNode spriteNodeWithImageNamed:@"waterBackground"];
    _bg2.anchorPoint = CGPointZero;
    _bg2.position = CGPointMake(_bg1.frame.size.width-1, 0);
    _bg2.name = @"bg2";
    [_screenNode addChild:_bg2];
    
    // Initilizes the different sprites
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    // Containers
    int widthDiv30 = (self.frame.size.width-visualBar.frame.size.width) / GRID_SIZE;
    int heightDiv30 = self.frame.size.height / GRID_SIZE;
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
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MidBase"];
                        sprite.name = @"hostbase";
                        sprite.zRotation =  M_PI / 2;
                        sprite.xScale = 1.7;
                        sprite.yScale = 2.1;
                        sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
                        [_screenNode addChild:sprite];
                        break;
                        
                    case JOIN_BASE:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MidBase"];
                        sprite.name = @"joinbase";
                        sprite.zRotation = 3 * M_PI / 2;
                        sprite.xScale = 1.7;
                        sprite.yScale = 2.1;
                        sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
                        [_screenNode addChild:sprite];
                        break;
                        
                        // need to add an if visible clause
                    case CORAL:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"coral"];
                        sprite.name = @"coral";
                        sprite.zRotation = M_PI / 2;
                        sprite.xScale = 0.248;
                        sprite.yScale = 0.338;
                        sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
                        [_screenNode addChild:sprite];
                        break;
                        
                    default:
                        break;
                        
                }
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    // Scrolls the backgrounds
    [_helper scrollBackground1:_bg1 background2:_bg2];
}

// Handles the pinch
-(void) handlePinch:(UIPinchGestureRecognizer *) recognizer {
    // Makes the screen node larger
    if (_screenNode.xScale < 2 && _screenNode.yScale < 2 && recognizer.scale > 1)
    {
        _screenNode.xScale = _screenNode.xScale + (0.01);
        _screenNode.yScale = _screenNode.yScale + (0.01);
    }
    
    // Makes the screen node smaller
    if (_screenNode.xScale > 1 && _screenNode.yScale > 1 && recognizer.scale < 1)
    {
        _screenNode.xScale = _screenNode.xScale - (0.01);
        _screenNode.yScale = _screenNode.yScale - (0.01);
        
        if (_screenNode.xScale < 1 || _screenNode.yScale < 1)
        {
            _screenNode.xScale = 1;
            _screenNode.yScale = 1;
        }
    }
}

// Adds the pinch recognizer to the scene
- (void)didMoveToView:(SKView *)view{
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action: @selector (handlePinch:)];
    [[self view] addGestureRecognizer:_pinchRecognizer];
}

@end
