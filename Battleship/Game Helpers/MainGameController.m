//
//  MainGameController.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "MainGameController.h"

@implementation MainGameController

- (instancetype) initMainGameControllerWithGame:(BattleshipGame*)game
                                       andFrame:(CGSize)frame{
    self = [super init];
    if (self) {
        _game = game;
        _names = [[Names alloc] initNames];
        _containers = [[Containers alloc] initContainersWithNames:_names];
        _sizes = [[Sizes alloc] initSizesWithFrameSize:frame];
        _helper = [[Helpers alloc] initWithSizes:_sizes];
        _background = [[Background alloc] initBackgroundWithNode:_containers.backgroundNode
                                                        andSizes:_sizes
                                                        andNames:_names
                                                         andGame:_game];
        _ships = [[Ships alloc] initShipsWithNode:_containers.activeShipsNode
                                         andSizes:_sizes
                                         andNames:_names
                                          andGame:_game];
        _miniMap= [[MiniMap alloc] initMiniMapWithNode:_containers.miniMapNode
                                              andSizes:_sizes
                                              andNames:_names
                                               andGame:_game];
        _visualBar = [[VisualBar alloc] initVisualBarWithNode:_containers.visualBarNode
                                                   andSizes:_sizes
                                                   andNames:_names
                                                    andGame:_game
                                                andActiveShipsNode:_containers.activeShipsNode
                                                    andHelper:_helper];
        
    }
    return self;
}

@end