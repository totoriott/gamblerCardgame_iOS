//
//  GameBoard.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "GameBoard.h"

@implementation GameBoard

- (CardGambler*)buyCardWithNumber:(int)winningNumber {
    return nil; // TODO
}

- (void)fumbleMoneyAdd:(int)amount {
    _fumbleMoneyTotal += amount;
}

- (GameActionStatus)fumbleMoneyRemove:(int)amount {
    if (_fumbleMoneyTotal < amount) {
        return ACTION_FAIL;
    }
    
    _fumbleMoneyTotal -= amount;
    return ACTION_SUCCEED;
}

@end
