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

static GCHelper *sharedHelper = nil;
+ (GCHelper *) sharedInstance {
    if(!sharedHelper){
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

-(id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenerAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlyaerAuthenticationDidChangeNotificationName object:nil];
            
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
@end
