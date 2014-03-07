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


@end
