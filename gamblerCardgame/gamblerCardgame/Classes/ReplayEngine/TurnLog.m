//
//  TurnLog.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "TurnLog.h"

@implementation TurnLog

- (instancetype)initWithPlayerCount:(int)playerCount {
    if (self = [super init]) {
        _luckPlay = [NSMutableArray array];
        for (int i = 0; i < playerCount; i++) {
            [_luckPlay addObject:[NSNumber numberWithInt:TURNLOG_ACTION_NOT_CHOSEN]];
        }
        
        _luckAdjust = TURNLOG_ACTION_NOT_CHOSEN;
        _endTurnAction = TURNLOG_ACTION_NOT_CHOSEN;
        _endTurnCardSelected = TURNLOG_ACTION_NOT_CHOSEN;
    }
    return self;
}

- (NSString *)turnLogStatus {
    NSString* statusString = @"";
    for (NSNumber* play in _luckPlay) {
        if ([play intValue] == TURNLOG_ACTION_NOT_CHOSEN) {
            statusString = [NSString stringWithFormat:@"%@?", statusString];
        } else {
            statusString = [NSString stringWithFormat:@"%@%d", statusString, [play intValue]];
        }
    }
    
    // TODO - luck adjust, end turn action, card selected, etc
    
    return statusString; // TODO
}

- (void)logLuckPlay:(int)luckValue forPlayer:(int)playerId {
    _luckPlay[playerId] = [NSNumber numberWithInt:luckValue];
}

- (void)logLuckAdjust:(int)adjust {
    _luckAdjust = adjust;
}

- (void)logEndTurnAction:(int)action cardSelected:(int)cardNumber {
    _endTurnAction = action;
    _endTurnCardSelected = cardNumber;
}

- (int)getLuckPlayForPlayer:(int)playerId {
    return [_luckPlay[playerId] intValue]; // TODO bounds check
}

- (int)getLuckAdjust {
    return _luckAdjust;
}

- (int)getEndTurnAction {
    return _endTurnAction;
}

- (int)getEndTurnCardSelected {
    return _endTurnCardSelected;
}

@end
