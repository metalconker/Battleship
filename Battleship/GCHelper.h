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
-(void)matchStarted;
-(void)matchEnded;
-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    UIViewController *presentingViewController;
    GKMatch *match;
    BOOL matchStarted;
    __unsafe_unretained id <GCHelperDelegate> delegate;
}
@property (strong, nonatomic) UIViewController* rootViewController;
@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id<GCHelperDelegate> delegate;
@property (assign, readonly) BOOL gameCenterAvailable;

-(void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                viewController:(UIViewController *) viewController
                      delegate:(id<GCHelperDelegate>)theDelegate;
+ (GCHelper *)sharedInstance:(UIViewController*) rootView;
- (void)authenticateLocalUser;
- (IBAction)joinBattleshipMatch: (id) sender;

@end
