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

- (instancetype)initFromSerialization:(NSString*)serial {
    if (self = [super init]) {
        _turns = [NSMutableArray array];
        
        NSArray<NSString*>* components = [serial componentsSeparatedByString:@";"];
        
        // TODO: erorr checking?
        _playerCount = [components[0] intValue];
        
        for (int i = 1; i < [components count]; i++) {
            TurnLog* turn = [[TurnLog alloc] initFromSerialization:components[i]];
            [_turns addObject:turn];
        }
        
        NSLog(@"%@", [self serialize]);
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
    
    // serialize number of players
    serialization = [NSString stringWithFormat:@"%@%d;", serialization, _playerCount];

    // serialize each turn
    for (TurnLog* turn in _turns) {
        serialization = [NSString stringWithFormat:@"%@%@;", serialization, [turn serialize]];
    }
    
    // chop off the last semicolon
    // TODO: is this weird if turnlog is empty
    return [serialization substringToIndex:[serialization length] - 1];
}

@end
