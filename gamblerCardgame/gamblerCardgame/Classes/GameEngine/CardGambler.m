//
//  CardGambler.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "CardGambler.h"

typedef NS_ENUM(NSUInteger, GamblerConfig) {
    GAMBLER_CONFIG_WINNING_NUMBER = 1,
    GAMBLER_CONFIG_SUPER_WINNING_NUMBER,
    GAMBLER_CONFIG_COST,
    GAMBLER_CONFIG_CARD_VALUE_GRANTED,
    GAMBLER_CONFIG_SUPER_CARD_VALUE_GRANTED,
    GAMBLER_CONFIG_PAYOUT_VALUE,
    GAMBLER_CONFIG_SUPER_PAYOUT_VALUE,
};

@implementation CardGambler

- (instancetype)initWithCardConfig:(NSArray*)config {
    if (self = [super init]) {
        _isSuper = NO;
        
        _winningNumber = [config[GAMBLER_CONFIG_WINNING_NUMBER] intValue];
        _superWinningNumber = [config[GAMBLER_CONFIG_SUPER_WINNING_NUMBER] intValue];
        _cost = [config[GAMBLER_CONFIG_COST] intValue];
        _cardValueGranted = [config[GAMBLER_CONFIG_CARD_VALUE_GRANTED] intValue];
        _superCardValueGranted = [config[GAMBLER_CONFIG_SUPER_CARD_VALUE_GRANTED] intValue];
        _payoutValue = [config[GAMBLER_CONFIG_PAYOUT_VALUE] intValue];
        _superPayoutValue = [config[GAMBLER_CONFIG_SUPER_PAYOUT_VALUE] intValue];
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
