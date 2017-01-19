//
//  CardGambler.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "CardGambler.h"

@implementation CardGambler

- (GameActionStatus)resetToNormal {
    _isSuper = NO;
    
    return ACTION_SUCCEED;
}

- (GameActionStatus)setToSuper {
    _isSuper = YES;
    
    return ACTION_SUCCEED;
}

- (int)cardWinningNumber {
    return _isSuper ? _superWinningNumber : _winningNumber;
}

- (int)cardPayoutValue {
    return _isSuper ? _superPayoutValue : _payoutValue;
}

- (int)cardCardValueGranted {
    return _isSuper ? _cardValueGranted : _superCardValueGranted;
}

@end
