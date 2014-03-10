//
//  Player.h
//  Battleship
//
//  Created by Micah Elbaz on 3/5/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fleet.h"

@interface Player : NSObject

#define GRID_SIZE 30

@property (strong, nonatomic) NSMutableArray* radarGrid;
@property(strong, nonatomic) Fleet* playerFleet;
@property NSString* playerID;
-initWith: (NSString*) playerID;
@end
