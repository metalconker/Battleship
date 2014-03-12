//
//  MyScene.m
//  Battleship
//
//  Created by Rayyan Khoury on 1/30/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

typedef enum messageType {
    MAP,
    SHIP_LOCATION
}MessageType;

typedef struct {
    MessageType type;
    __unsafe_unretained NSData* packet;
}Message;

-(id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        // Initializing the background - more time efficient as only loads the textures once
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        // Creates the battleship game
        _game = [[BattleshipGame alloc] init];
        _game.gameCenter.match.delegate = self;
        if(_game.localPlayer.isHost) {
            [self sendMap];
            [_game updateMap:_game.localPlayer.playerFleet];
            _mainGameController = [[MainGameController alloc] initMainGameControllerWithGame:_game andFrame:self.frame.size];
            [self addChild:_mainGameController.containers.overallNode];
        }
    }
    return self;
}

-(BOOL)sendMap {
    NSError* error;
    Message mapMessage;
    mapMessage.type = MAP;
    mapMessage.packet = [NSKeyedArchiver archivedDataWithRootObject:_game.gameMap.grid];
    NSData* structPacket = [NSData dataWithBytes:&mapMessage length:sizeof(mapMessage)];
    [_game.gameCenter.match sendDataToAllPlayers: structPacket withDataMode:GKMatchSendDataUnreliable error:&error];
    if (error != nil) {
        NSLog(@"error");
    }
    return false;
}

-(BOOL)sendFleetLocation {
    NSError* error;
    NSLog(@"send");
    Message fleetMessage;
    fleetMessage.type = SHIP_LOCATION;
    /*NSMutableArray* headLocation = [[NSMutableArray alloc] init];
    for (Ship* s in _game.localPlayer.playerFleet.shipArray) {
        [headLocation addObject:[NSKeyedArchiver archivedDataWithRootObject:s.location]];
    }
    */
    NSData *packet = [NSKeyedArchiver archivedDataWithRootObject:_game.localPlayer.playerFleet];
    fleetMessage.packet = packet;
    NSData* structPacket = [NSData dataWithBytes:&fleetMessage length:sizeof(fleetMessage)];
    BOOL success = [_game.gameCenter.match sendDataToAllPlayers: structPacket withDataMode:GKMatchSendDataUnreliable error:&error];
    NSLog(@"%d", success);
    if (error != nil) {
        NSLog(@"error");
    }
    return false;
}
-(void) match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"test");
    Message* receivedMessage = (Message*) [data bytes];
    if (receivedMessage->type == MAP) {
        NSMutableArray* grid = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:receivedMessage->packet];
        _game.gameMap.grid = grid;
        [_game updateMap:_game.localPlayer.playerFleet];
        _mainGameController = [[MainGameController alloc] initMainGameControllerWithGame:_game andFrame:self.frame.size];
        [self addChild:_mainGameController.containers.overallNode];
    }
    if (receivedMessage->type == SHIP_LOCATION) {
        Fleet* playerFleet = (Fleet*)[NSKeyedUnarchiver unarchiveObjectWithData:receivedMessage->packet];
        [_game updateMap:playerFleet];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        _nodeTouched = [self nodeAtPoint:location];
        
        // Mini map touched
        if ([_nodeTouched.name isEqualToString:_mainGameController.names.miniMapSpriteName])
        {
            _mainGameController.miniMap.initiallyTouched = true;
        }
        
        // Background touched
        if ([_nodeTouched.parent isEqual:_mainGameController.gestures.gesturesNode]
            || [_nodeTouched.parent.parent isEqual:_mainGameController.gestures.gesturesNode])
        {
            _mainGameController.gestures.initiallyTouched = true;
        }
        
        // Ship touched
        if ([_nodeTouched.parent isEqual:_mainGameController.ships.shipsNode])
        {
            [_mainGameController.visualBar displayShipDetails:_nodeTouched];
        }
        
        // Move button touched
        if ([_nodeTouched.parent isEqual:_mainGameController.visualBar.shipFunctions])
        {
            [_mainGameController.visualBar detectFunction:_nodeTouched];
        }
        
        // Move location touched
        if ([_nodeTouched.parent isEqual:_mainGameController.foreground.movementLocationsSprites])
        {
            [_mainGameController.ships updateShipLocation:_nodeTouched];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint previousPosition = [touch previousLocationInNode:self];
    CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    
    // Move mini map
    if (_mainGameController.miniMap.initiallyTouched)
    {
        [_mainGameController.miniMap updateMiniMapPositionWithTranslation:translation];
    }
    
    // Move map around
    if (_mainGameController.gestures.initiallyTouched && !_mainGameController.miniMap.initiallyTouched)
    {
        [_mainGameController.gestures updateGesturesPositionWithTranslation:translation];
    }
}

// Called when the finger is removed
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // Relocate mini map
    if(_mainGameController.miniMap.initiallyTouched)
    {
        [_mainGameController.miniMap setMiniMapLocation:location];
        _mainGameController.miniMap.initiallyTouched = false;
    }
    
    // Update background
    if(_mainGameController.gestures.initiallyTouched)
    {
        _mainGameController.gestures.initiallyTouched = false;
    }
    
}

NSInteger intervals = 100;
-(void)update:(CFTimeInterval)currentTime {
    // Scrolls the backgrounds according to current time
    [_mainGameController.background scrollBackgrounds];
    
    // Ships to move
    if ([_mainGameController.ships.movingShip count] > 0)
    {
        intervals--;
        [_mainGameController.ships animateShips:intervals];
        
        if (intervals == 0)
        {
            intervals = 100;
        }
    }
}

// Handles the pinch
-(void) handlePinch:(UIPinchGestureRecognizer *) recognizer {
    
    [_mainGameController.gestures handlePinchWithRecognizerScale:recognizer.scale];
}

// Adds the pinch recognizer to the scene
- (void)didMoveToView:(SKView *)view{
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action: @selector (handlePinch:)];
    [[self view] addGestureRecognizer:_pinchRecognizer];
}

@end
