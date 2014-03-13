//
//  Ships.h
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
#import "VisualBar.h"

@interface Ships : NSObject

// The Ships container
@property (strong, nonatomic) SKNode *shipsNode;
@property (strong, nonatomic) Sizes *sizes;
@property (strong, nonatomic) Names *names;
@property (strong, nonatomic) BattleshipGame *game;
@property (strong, nonatomic) Helpers *helper;
@property (strong, nonatomic) VisualBar *visualBar;
@property (strong, nonatomic) Foreground *foreground;
@property (strong, nonatomic) NSMutableArray *movingShip;
@property (strong, nonatomic) NSMutableArray *movingShipOldLocation;
@property (strong, nonatomic) NSMutableArray *movingShipNewLocation;


- (instancetype) initShipsWithNode:(SKNode*) shipsNode
                          andSizes:(Sizes*) sizes
                          andNames:(Names*) names
                           andGame:(BattleshipGame*) game
                         andHelper:(Helpers*) helper
                      andVisualBar:(VisualBar*) visualBar
                     andForeground:(Foreground*) foreground;

- (void) updateShipLocation:(SKNode*) newShipLocation;
- (void) animateShips:(NSInteger)intervals;
@end
