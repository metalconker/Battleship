//
//  MyScene.m
//  Battleship
//
//  Created by Rayyan Khoury on 1/30/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "MyScene.h"

@interface MyScene()

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;

@property (nonatomic, strong) BattleshipGame *game;
@property UIPinchGestureRecognizer *pinchRecognizer;
@property SKSpriteNode *bg1;
@property SKSpriteNode *bg2;

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
        // Ship sprites
        [self initShipSprites];
        //MiniMap sprite
        [self initMiniMap];
        Coordinate* testOrigin = [[Coordinate alloc] initWithXCoordinate:10 YCoordinate:1 initiallyFacing: NORTH];
        Coordinate* testDestination = [[Coordinate alloc] initWithXCoordinate:15 YCoordinate:17 initiallyFacing: NORTH];
        [_game moveShipfrom:testOrigin to:testDestination];
        //[self initTerrainSprites];
        [self initShipSprites];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view{
    
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action: @selector (handlePinch:)];
    [[self view] addGestureRecognizer:_pinchRecognizer];
    NSLog(@"this is getting called");
}

- (void) updateShipPosition {
    
}

// Draws ship sprites to screen
- (void) initShipSprites {
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    int widthDiv30 = self.frame.size.width / GRID_SIZE;
    int heightDiv30 = self.frame.size.height / GRID_SIZE;

    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            
            if ([_game.hostView.grid[i][j] isKindOfClass:[ShipSegment class]])
            {
                ShipSegment *s = _game.hostView.grid[i][j];
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
                    [self addChild:sprite];
                }
            }
        }
    }
}

// Draws terrain sprites to screen
- (void) initTerrainSprites {
    
    // Not my code
    _bg1 = [SKSpriteNode spriteNodeWithImageNamed:@"waterBackground"];
    _bg1.anchorPoint = CGPointZero;
    _bg1.position = CGPointMake(0, 0);
    [self addChild:_bg1];
    
    _bg2 = [SKSpriteNode spriteNodeWithImageNamed:@"waterBackground"];
    _bg2.anchorPoint = CGPointZero;
    _bg2.position = CGPointMake(_bg1.size.width-1, 0);
    [self addChild:_bg2];
    
    // Initilizes the different sprites
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    // Containers
    int widthDiv30 = self.frame.size.width / GRID_SIZE;
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
                        [self addChild:sprite];
                        break;
                        
                    case JOIN_BASE:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MidBase"];
                        sprite.name = @"joinbase";
                        sprite.zRotation = 3 * M_PI / 2;
                        sprite.xScale = 1.7;
                        sprite.yScale = 2.1;
                        sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
                        [self addChild:sprite];
                        break;
                        
                        // need to add an if visible clause
                    case CORAL:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"coral"];
                        sprite.name = @"coral";
                        sprite.zRotation = M_PI / 2;
                        sprite.xScale = 0.248;
                        sprite.yScale = 0.338;
                        sprite.position = CGPointMake(i*widthDiv30 + sprite.frame.size.width/2, j*heightDiv30 + sprite.frame.size.height/2);
                        [self addChild:sprite];
                        break;
                        
                    default:
                        //sprite = [SKSpriteNode spriteNodeWithImageNamed:@"water"];
                        //sprite.name = @"water";
                        //sprite.zRotation = M_PI / 2;
                        //sprite.xScale = 0.248;
                        //sprite.yScale = 0.338;
                        break;
                        
                }
            }
        }
    }
}

- (void)initMiniMap{
    
    // Initilize CGPoints
    int mapSize = self.frame.size.height / 6;
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
    SKNode *image = [SKSpriteNode spriteNodeWithImageNamed:@"Mini Map"];
    image.name = @"Mini Map";
    image.yScale = 0.4;
    image.xScale = 0.4;
    image.position = [[self.miniMapPositions objectAtIndex:0] CGPointValue];
    
    // This will keep the dots as children of the image SKNode
    [self initShipsMiniMap:image];
    [self addChild:image];
    
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
                if (s.isTail) {
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
/*
    Ship *ship;
    
    for (int i=0 ; i < [testFleet.shipArray count]; i++)
    {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Green Dot"];
        sprite.name = [NSString stringWithFormat:@"%@/Green Dot", ship.shipName];
        sprite.yScale = 0.3;
        sprite.xScale = 0.3;
        ship = [testFleet.shipArray objectAtIndex:i];
        sprite.position = CGPointMake(ship.location.xCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.width*1.4, ship.location.yCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.height*1.3);
        [miniMap addChild:sprite];
        
    }
    */
    // for all terrain in terrain array
    //Terrain ter;
    //NSMutableArray *innerArray;
    //SKSpriteNode *sprite;
    
    
    // for this player's ships'
    
    // get the x and y position of this ship
    
    // draw colored ship on mini map at this position
    
    // for enemy's ships
    
    // if visible by this players ships
    
    // draw other colors ship on mini map
    
}

bool miniMapTouched = false;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        NSLog(@"Location of touch: %@", NSStringFromCGPoint(location));
        
        SKNode *node = [self nodeAtPoint:location];
        if (YES) NSLog(@"Node name where touch began: %@", node.name);
        
        // If the initial touch was on the mini map
        if ([node.name isEqualToString:@"Mini Map"])
        {
            //CGPoint position = [node position];
            NSLog(@"we are touching the mini map bitch");
            miniMapTouched = true;
            //[node setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
            
        }
        
        
        
    }
    
    //[self runAction:[SKAction playSoundFileNamed:@"Pew_Pew-DKnight556-1379997159.mp3" waitForCompletion:NO]];
    
    
}


float mapScaleX;
float mapScaleY;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint previousPosition = [touch previousLocationInNode:self];
    CGPoint location = [touch locationInNode:self];
    
    CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    
    SKNode *node = [self nodeAtPoint:location];
    CGPoint position = [node position];
    //if (YES) NSLog(@"Node name where touch began: %@", node.name);
    
    // Moves the mini map according to the finger moving it
    if ([node.name isEqualToString:@"Mini Map"])
    {
        NSLog(@"we are touching the mini map bitch");
        [node setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        
    }
    
    // If the touches increase to greater than 2
    //if ([touches count] > 1 || [touches count] == 0)
    // {
    //   [self setMiniMapLocation:location];;
    //}
    
    
}

// Called when the finger is removed
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    // If the mini map was initially touched
    if (miniMapTouched)
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
    miniMapTouched = false;
    
}

bool up = false;
bool down = false;

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    // Not my code
    _bg1.position = CGPointMake(_bg1.position.x-0.5, _bg1.position.y);
    _bg2.position = CGPointMake(_bg2.position.x-0.5, _bg2.position.y);
    
    if (_bg1.position.x < -_bg1.size.width){
        _bg1.position = CGPointMake(_bg2.position.x + _bg2.size.width, _bg1.position.y);
    }
    
    if (_bg2.position.x < -_bg2.size.width) {
        _bg2.position = CGPointMake(_bg1.position.x + _bg1.size.width, _bg2.position.y);
    }
    
}

//CGFloat scale=1;
//CGPoint position;
//CGPoint mid;
//CGPoint currentPosition;
//CGPoint start;
//CGFloat temp = 0;
//CGFloat x=0;
//CGFloat y=0;
//CGFloat mLastScale=1;
//CGFloat mCurrentScale=1;
//CGPoint translation;
//

float scale;
-(void) handlePinch:(UIPinchGestureRecognizer *) recognizer {
    
    //NSLog(@"Pinch");
    
    if (_bg1.xScale < 2 && _bg1.yScale < 2 && recognizer.scale > 1)
    {
        _bg1.xScale = _bg1.xScale + (0.01);
        _bg1.yScale = _bg1.yScale + (0.01);
    }
    
    if (_bg1.xScale > 1 && _bg1.yScale > 1 && recognizer.scale < 1)
    {
        _bg1.xScale = _bg1.xScale - (0.01);
        _bg1.yScale = _bg1.yScale - (0.01);
        
        if (_bg1.xScale < 1 || _bg1.yScale < 1)
        {
            _bg1.xScale = 1;
            _bg1.yScale = 1;
        }
    }
    
    
    
    NSLog(@"%f",recognizer.scale);
    
    //    scale=scale*recognizer.scale;
    //
    //
    //    mCurrentScale += [recognizer scale] - mLastScale;
    //    mLastScale = [recognizer scale];
    //    if (recognizer.state == UIGestureRecognizerStateBegan)
    //    {
    //        //get midpoint
    //        CGPoint zero=[recognizer locationOfTouch:0 inView:self.view];
    //        CGPoint one=[recognizer locationOfTouch:1 inView:self.view];
    //        float x=zero.x+one.x;
    //        float y=zero.y+one.y;
    //        mid.x=x/2;
    //        mid.y=y/2;
    //    }
    //    else if (recognizer.state == UIGestureRecognizerStateEnded)
    //    {
    //        mLastScale = 1.0;
    //    }
    //
    //    self.scaleMode = scale;
    //NSString *xPosString = [NSString stringWithFormat:@"%.2f",mid.x];
    //NSString *yPosString = [NSString stringWithFormat:@"%.2f",mid.y];
    //xPosLabel.text=xPosString;
    
}

- (void) drawMiniMapPoints {
    
}

@end
