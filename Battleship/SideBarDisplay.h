//
//  SideBarDisplay.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-03.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "BattleshipGame.h"
#import "Helpers.h"


@interface SideBarDisplay : NSObject

@property (strong, nonatomic) SKNode* parentNode;
@property (strong, nonatomic) SKNode* visualBarNode;
@property (strong, nonatomic) SKSpriteNode* displayedShip;
@property (strong, nonatomic) SKLabelNode* shipName;
@property (strong, nonatomic) BattleshipGame* game;
@property (strong, nonatomic) Helpers* helper;
@property (strong, nonatomic) NSMutableArray* functions;
-(instancetype) initWithParentNode:(SKNode *)parent andVisualBarNode:(SKNode*) visualBar usingGame: (BattleshipGame*) game andHelperInstance: (Helpers*) helper;

-(NSMutableArray*) displayShipDetails: (SKNode *) shipSprite;
                             
@end
