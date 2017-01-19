//
//  TurnLog.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "TurnLog.h"

@implementation TurnLog

// TODO: initialize properly

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
