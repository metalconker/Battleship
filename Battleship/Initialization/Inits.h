//
//  Inits.h
//  Battleship
//
//  Created by Rayyan Khoury on 2/28/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Helpers.h"
#import "BattleshipGame.h"

@interface Inits : NSObject

@property (strong, nonatomic) SKNode* overallNode;
@property (strong, nonatomic) BattleshipGame* game;
@property (strong, nonatomic) Helpers* helper;

- (void) initTerrainSprites;

@end
