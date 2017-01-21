//
//  CardGambler.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "CardGambler.h"

@implementation CardGambler

- (instancetype)initWithCardConfig:(NSArray*)config {
    if (self = [super init]) {
        _isSuper = NO;
        
        // TODO: don't hardcode?
        _winningNumber = [config[1] intValue];
        _superWinningNumber = [config[2] intValue];
        _cost = [config[3] intValue];
        _cardValueGranted = [config[4] intValue];
        _superCardValueGranted = [config[5] intValue];
        _payoutValue = [config[6] intValue];
        _superPayoutValue = [config[7] intValue];
    }
    return self;
}

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
    return _isSuper ? _superCardValueGranted : _cardValueGranted;
}

@end
