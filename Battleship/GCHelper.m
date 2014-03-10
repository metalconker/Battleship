//
//  GCHelper.m
//  Battleship
//
//  Created by Robert Schneidman on 3/7/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper

@synthesize gameCenterAvailable;
@synthesize presentingViewController;
@synthesize match;
@synthesize delegate;

#pragma mark Initialization

static GCHelper *sharedHelper = nil;
+ (GCHelper *)sharedInstance:(UIViewController*) rootView {
    if(!sharedHelper){
        sharedHelper = [[GCHelper alloc] initWith:rootView];
    }
    return sharedHelper;
}

- (BOOL) isGameCenterAvailable{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    return (gcClass && osVersionSupported);
}

-(id)initWith: (UIViewController*) rootView {
    if ((self = [super init])) {
        _rootViewController = rootView;
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
            
        }
    }
    return self;
}


-(void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authetication changed: player authenticated");
        userAuthenticated = TRUE;
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
}

#pragma mark User Functions

- (void) authenticateLocalUser
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil)
        {
            [_rootViewController presentViewController:viewController animated:YES completion:nil];
            
            //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
            //[self showAuthenticationDialogWhenReasonable: viewController];
        }
        else if (localPlayer.isAuthenticated)
        {
            //authenticatedPlayer: is an example method name. Create your own method that is called after the loacal player is authenticated.
            //[self authenticatedPlayer: localPlayer];
        }
        else
        {
            //[self disableGameCenter];
        }
    } ;
}

-(void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate{
    
    if(!gameCenterAvailable) return;
    
    matchStarted = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;
    [presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc]initWithMatchRequest:request];

    mmvc.matchmakerDelegate = self;
    [presentingViewController presentViewController:mmvc animated:YES completion:nil];
    
}

- (IBAction)joinBattleshipMatch: (id) sender
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    [_rootViewController presentViewController:mmvc animated:YES completion:nil];
}

-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [_rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    //[_rootViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [_rootViewController dismissViewControllerAnimated:YES completion:nil];
    //self.match = theMatch;
    match.delegate = self;
    
    for (NSString* s in theMatch.playerIDs) {
        NSLog(@"%@", s);
    }
    
}

#pragma mark GKMatchDelegate

-(void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    if (match != theMatch) return;
    [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
}

-(void)match: (GKMatch *) theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    switch (state) {
        case GKPlayerStateConnected:
            NSLog(@"Player connected");
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
            }
            break;
        case GKPlayerStateDisconnected:
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            [delegate matchEnded];
            break;
    }
}

-(void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    if (match != theMatch) return;
    NSLog(@"MAtch failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}
@end
