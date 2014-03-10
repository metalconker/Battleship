//
//  Containers.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Containers.h"

@implementation Containers

- (instancetype) initContainersWithNames: (Names*) names{
    self = [super init];
    if (self) {
        _names = names;
        [self initContainers];
    }
    return self;
}


// Initializes the subcontainers of the overall screen node
- (void) initContainers{
    
    _overallNode = [[SKNode alloc] init];
    _gesturesNode = [[SKNode alloc] init];
    _backgroundNode = [[SKNode alloc] init];
    _visualBarNode = [[SKNode alloc] init];
    _foregroundNode = [[SKNode alloc] init];
    _activeShipsNode = [[SKNode alloc] init];
    _destroyedShipsNode = [[SKNode alloc] init];
    _miniMapNode = [[SKNode alloc] init];
    
    _overallNode.name = _names.overallNodeName;
    _gesturesNode.name = _names.gesturesNodeName;
    _backgroundNode.name = _names.backgroundNodeName;
    _visualBarNode.name = _names.visualBarNodeName;
    _foregroundNode.name = _names.foregroundNodeName;
    _activeShipsNode.name = _names.activeShipsNodeName;
    _destroyedShipsNode.name = _names.destroyedShipsNodeName;
    _miniMapNode.name = _names.miniMapNodeName;
    
    [_gesturesNode addChild:_backgroundNode];
    [_gesturesNode addChild:_activeShipsNode];
    [_gesturesNode addChild:_foregroundNode];
    [_overallNode addChild:_gesturesNode];
    [_overallNode addChild:_visualBarNode];
    [_overallNode addChild:_destroyedShipsNode];
    [_overallNode addChild:_miniMapNode];
    
}


@end
