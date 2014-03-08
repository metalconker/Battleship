//
//  MyScene.m
//  Battleship
//
//  Created by Rayyan Khoury on 1/30/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // Initializing the background - more time efficient as only loads the textures once
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        // Creates the battleship game
        _game = [[BattleshipGame alloc] init];
        
        // Creates the main game controller
        _mainGameController = [[MainGameController alloc] initMainGameControllerWithGame:_game
                                                                                andFrame:self.frame.size];
        
        [self addChild:_mainGameController.containers.overallNode];
        
        // Move Locations
        _movementLocationsSprites = [[SKNode alloc] init];
        
        // Locations
        [self addChild:_movementLocationsSprites];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        //Coordinate *newMove = [_helper fromTextureToCoordinate:location];
        
        
        _nodeTouched = [self nodeAtPoint:location];
        
        // If the initial touch was on the mini map
        if ([_nodeTouched.name isEqualToString:@"Mini Map"])
        {
            _miniMapTouched = true;
        }
        
        //SpriteNode *displayShip = [self ];
        
        // If the touch is a ship
        if ([_nodeTouched.parent isEqual:_mainGameController.ships.shipsNode] && ![_shipFunctions containsObject:_nodeTouched])
        {
            _shipFunctions = [_mainGameController.visualBar displayShipDetails:_nodeTouched];
            _shipDisplay = _nodeTouched;
            
        }
        
        // Displaying the sidebar
        if ([_shipFunctions containsObject:_nodeTouched])
        {
            if ([_nodeTouched.name isEqual:@"Move"])
            {
                
                Coordinate* c = [_mainGameController.helper fromTextureToCoordinate:_shipDisplay.position];
                NSMutableArray* d = [_game getValidMovesFrom:c withRadarPositions:false];
                [_movementLocationsSprites removeAllChildren];
                for (Coordinate* e in d)
                {
                    
                    SKSpriteNode* f = [[SKSpriteNode alloc] initWithImageNamed:@"Move Range"];
                    f.xScale = _mainGameController.sizes.tileWidth/f.frame.size.width;
                    f.yScale = _mainGameController.sizes.tileHeight/f.frame.size.height;
                    f.position = CGPointMake(e.xCoord * _mainGameController.sizes.tileWidth + _mainGameController.sizes.tileWidth/2,
                                             e.yCoord * _mainGameController.sizes.tileHeight + _mainGameController.sizes.tileHeight/2);
                    [_movementLocationsSprites addChild:f];
                }
            }
            
        }
        
        if ([[_movementLocationsSprites children] containsObject:_nodeTouched])
        {
            Coordinate* c = [_mainGameController.helper fromTextureToCoordinate:_nodeTouched.position];
            _shipDisplay.position = CGPointMake((double)c.xCoord * _mainGameController.sizes.tileWidth + _mainGameController.sizes.tileWidth/2,
                                                (double)c.yCoord * _mainGameController.sizes.tileHeight - _shipDisplay.frame.size.height/2 + _mainGameController.sizes.tileHeight);
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
    if ([node.name isEqualToString:_mainGameController.names.miniMapNodeName])
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
        _miniMapTouched = [_mainGameController.miniMap setMiniMapLocation:location];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    // Scrolls the backgrounds according to current time
    [_mainGameController.background scrollBackgrounds];
}

// Handles the pinch
-(void) handlePinch:(UIPinchGestureRecognizer *) recognizer {
    // Makes the screen node larger
    SKNode* overallNode = _mainGameController.containers.overallNode;
    if (overallNode.xScale < 2 && overallNode.yScale < 2 && recognizer.scale > 1)
    {
        overallNode.xScale = overallNode.xScale + (0.01);
        overallNode.yScale = overallNode.yScale + (0.01);
    }
    
    // Makes the screen node smaller
    if (overallNode.xScale > 1 && overallNode.yScale > 1 && recognizer.scale < 1)
    {
        overallNode.xScale = overallNode.xScale - (0.01);
        overallNode.yScale = overallNode.yScale - (0.01);
        
        if (overallNode.xScale < 1 || overallNode.yScale < 1)
        {
            overallNode.xScale = 1;
            overallNode.yScale = 1;
        }
    }
}

// Adds the pinch recognizer to the scene
- (void)didMoveToView:(SKView *)view{
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action: @selector (handlePinch:)];
    [[self view] addGestureRecognizer:_pinchRecognizer];
}

@end
