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
    NSString* statusString = [NSString stringWithFormat:@"P%d - $%d {", _playerId, _money];
    
    for (NSNumber* luckCard in [self availableLuckCards]) {
        statusString = [NSString stringWithFormat:@"%@%d", statusString, [luckCard intValue]];
    }
    
    statusString = [NSString stringWithFormat:@"%@} ", statusString];
    
    for (CardGambler* card in _cardGamblers) {
        if (card.isSuper) {
            statusString = [NSString stringWithFormat:@"%@[%d*]", statusString, [card cardWinningNumber]];
        } else {
            statusString = [NSString stringWithFormat:@"%@[%d]", statusString, [card cardWinningNumber]];
        }
    }
    
    return statusString; // TODO
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
    int winnings = 0;
    
    for (CardGambler* card in _cardGamblers) {
        if ([card cardWinningNumber] == winningNumber) {
            // this card paid off!
            winnings += [card cardPayoutValue];
            
            // reset it to normal (if it was super)
            [card resetToNormal];
        }
    }
    
    [self gainMoney:winnings];
    
    return winnings; 
}

- (GameActionStatus)setCardToSuperWithValue:(int)winningNumber {
    for (CardGambler* card in _cardGamblers) {
        if ([card cardWinningNumber] == winningNumber && !card.isSuper) {
            [card setToSuper];
            return ACTION_SUCCEED;
        }
    }

    return ACTION_FAIL;
}

- (void)addCardGambler:(CardGambler*)cardGambler {
    [_cardGamblers addObject:cardGambler];
}


@end
