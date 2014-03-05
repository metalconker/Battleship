//
//  SideBarDisplay.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-03.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface SideBarDisplay : NSObject

@property (strong, nonatomic) SKNode* parentNode;
@property (strong, nonatomic) SKSpriteNode* displayedShip;
@property (strong, nonatomic) SKLabelNode* shipName;
-(instancetype) initWithParentNode: (SKNode *) parent;

-(void) displayShipDetails: (SKNode *) shipSprite;
                             
@end
