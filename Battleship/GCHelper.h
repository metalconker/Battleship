//
//  GCHelper.h
//  Battleship
//
//  Created by Robert Schneidman on 3/7/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCHelperDelegate
//-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
    UIViewController *rootViewController;
    GKMatch *match;
    id <GCHelperDelegate> delegate;
}

@property (strong, nonatomic) UIViewController* rootViewController;
@property (retain) GKMatch *match;
@property (strong, nonatomic) GKLocalPlayer* localPlayer;

+ (GCHelper *)sharedInstance:(UIViewController*) rootView;
- (void)authenticateLocalUser;
- (IBAction)joinBattleshipMatch: (id) sender;

@end
