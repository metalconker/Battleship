//
//  MyScene.h
//  Battleship
//

//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BattleshipGame.h"
#import "Ship.h"
#import "Cruiser.h"
#import "Destroyer.h"
#import "TorpedoBoat.h"
#import "RadarBoat.h"
#import "MineLayer.h"
#import "Helpers.h"
@interface MyScene : SKScene

@property (strong, nonatomic) NSMutableArray* miniMapPositions;

@end
