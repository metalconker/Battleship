//
//  BattleshipGame.h
//  Battleship
//
//  Created by Robert Schneidman on 2/9/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "Fleet.h"
#import "Ship.h"

@interface BattleshipGame : NSObject

@property (strong, nonatomic) Map* hostView;
@property (strong, nonatomic) Map* joinView;

-(instancetype) init;
-(void)moveShipfrom: (Coordinate*) origin
                 to:(Coordinate*) destination;
-(NSMutableArray*) getValidMovesFrom:(Coordinate*)origin;
-(Coordinate*) getCoordOfShip: (NSString*) shipName;
@end
