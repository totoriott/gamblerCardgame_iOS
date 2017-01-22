//
//  GameLog.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "GameLog.h"

@implementation GameLog

- (instancetype)initWithPlayerCount:(int)playerCount {
    if (self = [super init]) {
        _playerCount = playerCount;
        _turns = [NSMutableArray array];
    }
    return self;
}

- (TurnLog*)getMostRecentTurn {
    return [_turns lastObject];
}

- (void)startNewTurn {
    TurnLog* newTurn = [[TurnLog alloc] initWithPlayerCount:_playerCount];
    [_turns addObject:newTurn];
}

- (NSString *)serialize {
    NSString* serialization = @"";
    for (TurnLog* turn in _turns) {
        serialization = [NSString stringWithFormat:@"%@%@;", serialization, [turn serialize]];
    }
    
    // chop off the last semicolon
    // TODO: is this weird if turnlog is empty
    return [serialization substringToIndex:[serialization length] - 2];
}

@end
