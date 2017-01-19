//
//  Player.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)initWithId:(int)playerId {
    if (self = [super init]) {
        _playerId = playerId;
        _money = 0;
        _cardGamblers = [NSMutableArray array];
    }
    return self;
}

- (NSString*)playerStatusString {
    return [NSString stringWithFormat:@"P%d - $%d", _playerId, _money]; // TODO
}

- (NSArray<NSNumber*>*)availableLuckCards {
    return @[@0, @1]; // TODO
}

- (GameActionStatus)gainMoney:(int)amount {
    // you can't go negative with money
    if (amount < 0 && _money + amount < 0) {
        amount = -1 * _money;
    }
    
    _money += amount;
    return ACTION_SUCCEED;
}

- (int)payoffAllCardsWithValue:(int)winningNumber {
    return 0; // TODO
}

- (GameActionStatus)setCardToSuperWithValue:(int)winningNumber {
    return ACTION_SUCCEED; // TODO
}

- (void)addCardGambler:(CardGambler*)cardGambler {
    // TODO
}


@end
