//
//  Gestures.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-09.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Containers.h"
#import "Sizes.h"
#import "Names.h"
#import "Helpers.h"
#import "BattleshipGame.h"

@interface Gestures : NSObject

#define MAX_X_SCALE 2
#define MAX_Y_SCALE 2
#define MIN_X_SCALE 1
#define MIN_Y_SCALE 1
#define SCALE_CHANGE 0.01
#define SCALE 1
#define MIN_X_POSITION 0
#define MIN_Y_POSITION 0

// Max x and max y
@property CGFloat initialMaxX;
@property CGFloat initialMaxY;
@property CGFloat newMaxX;
@property CGFloat newMaxY;
// X and X difference
@property CGFloat differenceX;
@property CGFloat differenceY;

@property Boolean initiallyTouched;

// The Visual Bar container
@property (strong, nonatomic) SKNode *gesturesNode;
@property (strong, nonatomic) Sizes *sizes;
@property (strong, nonatomic) Names *names;
@property (strong, nonatomic) BattleshipGame *game;
@property (strong, nonatomic) Helpers *helper;

- (instancetype) initGesturesWithNode:(SKNode*) gesturesNode
                             andSizes:(Sizes*) sizes
                             andNames:(Names*) names
                              andGame:(BattleshipGame*) game
                            andHelper:(Helpers*) helper;

- (void) updateGesturesPositionWithTranslation:(CGPoint)translation;
- (void) handlePinchWithRecognizerScale:(CGFloat) scale;

@end
