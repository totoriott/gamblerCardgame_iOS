//
//  GameLog.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "GameLog.h"

@implementation GameLog

- (TurnLog*)getMostRecentTurn {
    return [_turns lastObject];
}

- (void)startNewTurn {
    return; // TODO
}

@end
