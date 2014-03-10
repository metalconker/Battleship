//
//  MatchScreen.m
//  Battleship
//
//  Created by Robert Schneidman on 2014-03-08.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "MatchScreen.h"

@implementation MatchScreen

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _parentView = [[ViewController alloc] init];
        SKTexture *textureImage = [SKTexture textureWithImageNamed:@"menu background"];
        SKSpriteNode *backgroundSprite = [SKSpriteNode spriteNodeWithTexture:textureImage];
        backgroundSprite = [SKSpriteNode spriteNodeWithTexture:textureImage];
        backgroundSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        backgroundSprite.xScale = 0.6;
        backgroundSprite.yScale = 0.6;
        [self addChild:backgroundSprite];
        [[GCHelper sharedInstance:nil] joinBattleshipMatch:[GKLocalPlayer localPlayer]];
        //SKScene * scene = [MyScene sceneWithSize:self.scene.view.bounds.size];
        //[self.scene.view presentScene:scene];
    }
    
    return self;
}

         
@end
