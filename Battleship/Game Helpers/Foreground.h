//
//  Foreground.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Containers.h"
#import "Sizes.h"
#import "Names.h"
#import "BattleshipGame.h"
#import "Helpers.h"

@interface Foreground : NSObject

// The Foreground container
@property (strong, nonatomic) SKNode *foregroundNode;
@property (strong, nonatomic) Sizes *sizes;
@property (strong, nonatomic) Names *names;
@property (strong, nonatomic) BattleshipGame *game;
@property (strong, nonatomic) Helpers *helper;

@property (strong, nonatomic) SKNode *movementLocationsSprites;

- (instancetype) initForegroundWithNode:(SKNode*) foregroundNode
                               andSizes:(Sizes*) sizes
                               andNames:(Names*) names
                                andGame:(BattleshipGame*) game
                              andHelper:(Helpers*) helper;

- (void) displayMoveAreasForShip:(SKNode*)shipActuallyClicked;

@end
