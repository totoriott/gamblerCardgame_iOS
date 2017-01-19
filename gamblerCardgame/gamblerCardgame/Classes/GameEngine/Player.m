//
//  Player.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "Player.h"

@implementation Player

- (NSArray<NSNumber*>*)availableLuckCards {
    return @[@0, @1]; // TODO
}

- (void)gainMoney:(int)amount {
    // TODO
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
