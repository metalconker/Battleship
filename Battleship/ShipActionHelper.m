//
//  ShipActionHelper.m
//  Battleship
//
//  Created by Robert Schneidman on 2014-03-08.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "ShipActionHelper.h"

@implementation ShipActionHelper

static ShipActionHelper *sharedHelper = nil;
+ (ShipActionHelper *)sharedInstance {
    if(!sharedHelper){
        sharedHelper = [[ShipActionHelper alloc] init];
    }
    return sharedHelper;
}
@end
