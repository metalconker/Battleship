//
//  MiniMap.h
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

@interface MiniMap : NSObject

// Mini map size
@property float miniMapLength;

// The Mini Map container
@property (strong, nonatomic) SKNode *miniMapNode;
@property (strong, nonatomic) Sizes *sizes;
@property (strong, nonatomic) Names *names;
@property (strong, nonatomic) BattleshipGame *game;
@property Boolean initiallyTouched;

// Mini Map positions
@property (strong, nonatomic) NSMutableArray* miniMapPositions;

- (instancetype) initMiniMapWithNode:(SKNode*) miniMapNode
                            andSizes:(Sizes*) sizes
                            andNames:(Names*) names
                             andGame:(BattleshipGame*) game;
- (void) setMiniMapLocation:(CGPoint)location;
- (void) updateMiniMapPositionWithTranslation:(CGPoint)translation;

@end
