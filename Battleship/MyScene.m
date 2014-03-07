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

SKNode *visualBar;


@interface MyScene()

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;

@property (nonatomic, strong) BattleshipGame *game;
@property UIPinchGestureRecognizer *pinchRecognizer;

// Overall Sprite Node that contains all the subcontainers
@property (nonatomic, strong) SKNode *screenNode;

// Undernodes
// Background container
@property (nonatomic, strong) SKNode *backgroundNode;
// VisualBar container
@property (nonatomic, strong) SKNode *visualBarNode;
// Foreground container
@property (nonatomic, strong) SKNode *foregroundNode;
// Active Ships container
@property (nonatomic, strong) SKNode *activeShipsNode;
// Destroyed Ships container
@property (nonatomic, strong) SKNode *destroyedShipsNode;
// Minimap container
@property (nonatomic, strong) SKNode *miniMapNode;



@property (nonatomic, strong) Helpers *helper;
@property (nonatomic, strong) SKSpriteNode *bg1;
@property (nonatomic, strong) SKSpriteNode *bg2;
@property (nonatomic, strong) SKNode *ships;
@property (nonatomic, strong) SKNode *shipDisplay;
@property (nonatomic, strong) SKNode *nodeTouched;
@property (nonatomic, strong) SideBarDisplay* display;
@property (nonatomic, strong) NSMutableArray *shipFunctions;

@property (nonatomic, strong) NSMutableArray *movementLocations;
@property (nonatomic, strong) SKNode *movementLocationsSprites;
@property bool miniMapTouched;
@property bool shipClicked;

@end

@implementation MyScene

// Node Names
const NSString* screenNodeName = @"Overall";
const NSString* backgroundNodeName = @"Background";
const NSString* visualBarNodeName = @"Visual Bar";
const NSString* foregroundNodeName = @"Foreground";
const NSString* activeShipsNodeName = @"Active Ships";
const NSString* destroyedShipsNodeName = @"Destroyed Ships";
const NSString* miniMapNodeName = @"Mini Map";


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // Initializing the background - more time efficient as only loads the textures once
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        // Creates the battleship game
        _game = [[BattleshipGame alloc] init];
        
        // The overall image node
        _screenNode = [[SKNode alloc] init];
        _screenNode.name = @"Overall Node";
        
        // The ships
        _ships = [[SKNode alloc] init];
        
        // Move Locations
        _movementLocationsSprites = [[SKNode alloc] init];
        
        // Ship display
        ///_shipDisplay = [[SKNode alloc] init];
        //[self addChild:_shipDisplay];
        
        // Visual Bar sprite
        [self initVisualBar];
        
        // Contains all the map data
        [self addChild:_screenNode];
        
        // Terrain sprites
        [self initTerrainSprites];
        // Ship sprites
        
        // MiniMap sprite
        [self initMiniMap];
        [self addChild:visualBar];
        
        // Locations
        [self addChild:_movementLocationsSprites];
        
        // Creates the helper functions class
        _helper = [[Helpers alloc] initWithScreenWidth:self.frame.size.width screenHeight:self.frame.size.height visualBarWidth:visualBar.frame.size.width];
        [self initShipSprites];
        // Initilize the SideBarDisplay
        _display = [[SideBarDisplay alloc] initWithParentNode:self andVisualBarNode:visualBar usingGame:_game andHelperInstance:_helper];
    }
    
    return self;
}


// Draws ship sprites to screen
- (void) initShipSprites {
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    double widthDiv30 = (self.frame.size.width-visualBar.frame.size.width) / GRID_SIZE;
    double heightDiv30 = self.frame.size.height / GRID_SIZE;
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
                    sprite.yScale = (heightDiv30 * s.shipSize)/sprite.frame.size.height;
                    sprite.xScale = widthDiv30/sprite.frame.size.width;
                    if (s.location.direction == SOUTH) {
                        sprite.zRotation = M_PI;
                    }
                    sprite.position = [_helper positionShipSprite:sprite atCoordinate:s.location];
                    [_ships addChild:sprite];
                }
            }
        }
    }
    [_screenNode addChild:_ships];
}

// Initializes the visual bar
- (void)initVisualBar{
    visualBar = [SKSpriteNode spriteNodeWithImageNamed:@"Mini Map"];
    visualBar.name = @"Visual Bar";
    visualBar.yScale = 5;
    visualBar.xScale = 0.5;
    visualBar.position = CGPointMake(self.frame.size.width - visualBar.frame.size.width/2, visualBar.frame.size.height/2);
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
                    sprite.yScale = 0.3 * s.shipSize;
                    sprite.xScale = 0.3;
                    
                    if (s.location.direction == SOUTH)
                    {
                    sprite.position = CGPointMake(s.location.xCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.width*1.4, s.location.yCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.height*1.3 + s.shipSize*miniMap.frame.size.height/10 - (miniMap.frame.size.height/10 * 5));
                    }
                    
                    else if (s.location.direction == NORTH)
                    {
                    sprite.position = CGPointMake(s.location.xCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.width*1.4, s.location.yCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.height*1.3 - s.shipSize*miniMap.frame.size.height/10 + (miniMap.frame.size.height/10 * 2));
                    }
                    [miniMap addChild:sprite];
                }
            }
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    double widthDiv30 = (self.frame.size.width-visualBar.frame.size.width) / GRID_SIZE;
    double heightDiv30 = self.frame.size.height / GRID_SIZE;
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        Coordinate *newMove = [_helper fromTextureToCoordinate:location];
        
        
        _nodeTouched = [self nodeAtPoint:location];
        
        // If the initial touch was on the mini map
        if ([_nodeTouched.name isEqualToString:@"Mini Map"])
        {
            _miniMapTouched = true;
        }
        
        //SpriteNode *displayShip = [self ];
        
        // If the touch is a ship
        if ([_nodeTouched.parent isEqual:_ships] && ![_shipFunctions containsObject:_nodeTouched])
        {
            _shipFunctions = [_display displayShipDetails:_nodeTouched];
            _shipDisplay = _nodeTouched;
            
        }
        
        // Displaying the sidebar
        if ([_shipFunctions containsObject:_nodeTouched])
        {
            if ([_nodeTouched.name isEqual:@"Move"])
            {
                
                Coordinate* c = [_helper fromTextureToCoordinate:_shipDisplay.position];
                NSMutableArray* d = [_game getValidMovesFrom:c withRadarPositions:false];
                [_movementLocationsSprites removeAllChildren];
                for (Coordinate* e in d)
                {

                    SKSpriteNode* f = [[SKSpriteNode alloc] initWithImageNamed:@"Move Range"];
                    f.xScale = widthDiv30/f.frame.size.width;
                    f.yScale = heightDiv30/f.frame.size.height;
                    f.position = CGPointMake(e.xCoord * widthDiv30 + widthDiv30/2, e.yCoord * heightDiv30 + heightDiv30/2);
                    [_movementLocationsSprites addChild:f];
                }
                
                //sfor (Coordinate* c in [)
            }
            
        }
        
        if ([[_movementLocationsSprites children] containsObject:_nodeTouched])
        {
            Coordinate* c = [_helper fromTextureToCoordinate:_nodeTouched.position];
            _shipDisplay.position = CGPointMake((double)c.xCoord * widthDiv30 + widthDiv30/2 , (double)c.yCoord * heightDiv30 - _shipDisplay.frame.size.height/2 + heightDiv30);
            //sprite.position = CGPointMake((double) (s.location.xCoord)*widthDiv30 + widthDiv30/2, (s.location.yCoord*heightDiv30) - sprite.frame.size.height/2 + heightDiv30);
            
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
    double widthDiv30 = (self.frame.size.width-visualBar.frame.size.width) / GRID_SIZE;
    double heightDiv30 = self.frame.size.height / GRID_SIZE;
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
                        sprite.position = CGPointMake(i*widthDiv30 + widthDiv30/2, j*heightDiv30 + sprite.frame.size.height/2);
                        [_screenNode addChild:sprite];
                        break;
                        
                    case JOIN_BASE:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"MidBase"];
                        sprite.name = @"joinbase";
                        
                        sprite.xScale = 1.7;
                        sprite.yScale = 2.1;
                        sprite.zRotation = 3 * M_PI / 2;
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
    // Scrolls the backgrounds according to current time
    [_helper
     scrollBackground1:(SKSpriteNode*)[_screenNode childNodeWithName:@"background1"]
     background2:(SKSpriteNode*)[_screenNode childNodeWithName:@"background2"]];
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
