//
//  VisualBar.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Containers.h"
#import "Sizes.h"
#import "Names.h"
#import "Helpers.h"
#import "BattleshipGame.h"

@interface VisualBar : NSObject

// The Visual Bar container
@property (strong, nonatomic) SKNode *visualBarNode;
@property (strong, nonatomic) Sizes *sizes;
@property (strong, nonatomic) Names *names;
@property (strong, nonatomic) BattleshipGame *game;
@property (strong, nonatomic) SKNode *activeShipsNode;
@property (strong, nonatomic) Helpers *helper;

@property (strong, nonatomic) SKNode *shipFunctions;
@property (strong, nonatomic) SKNode *shipClicked;

- (instancetype) initVisualBarWithNode:(SKNode*) visualBarNode
                               andSizes:(Sizes*) sizes
                               andNames:(Names*) names
                               andGame:(BattleshipGame*) game
                    andActiveShipsNode:(SKNode*) activeShipsNode
                             andHelper:(Helpers*) helper;

-(NSMutableArray*) displayShipDetails: (SKNode*) shipSprite;

@end
