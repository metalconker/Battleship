//
//  Background.h
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

@interface Background : NSObject

// The Background container
@property (strong, nonatomic) SKNode *backgroundNode;
@property (strong, nonatomic) Sizes *sizes;
@property (strong, nonatomic) Names *names;
@property (strong, nonatomic) BattleshipGame *game;

- (instancetype) initBackgroundWithNode:(SKNode*) backgroundNode
                               andSizes:(Sizes*) sizes
                               andNames:(Names*) names
                                andGame:(BattleshipGame*) game;

- (void) scrollBackgrounds;

@end
