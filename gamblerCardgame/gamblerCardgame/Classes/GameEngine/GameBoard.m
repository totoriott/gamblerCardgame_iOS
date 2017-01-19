//
//  GameBoard.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "GameBoard.h"

@implementation GameBoard

- (instancetype)initWithCardConfigs:(NSArray*)configs {
    if (self = [super init]) {
        _fumbleMoneyTotal = 0;
        
        // TODO: consider refactoring how this is stored
        _cardsForSale = [NSMutableArray array];
        for (NSArray* config in configs) {
            int count = [config[0] intValue];
            for (int i = 0; i < count; i++) {
                CardGambler* newCard = [[CardGambler alloc] initWithCardConfig:config];
                [_cardsForSale addObject:newCard];
            }
        }
    }
    return self;
}

- (NSString *)boardStatusString {
    NSString* statusString = @"";
    for (CardGambler* card in _cardsForSale) {
        statusString = [NSString stringWithFormat:@"%@[%d]", statusString, [card cardWinningNumber]];
    }
    
    statusString = [NSString stringWithFormat:@"%@ - fumble $%d", statusString, _fumbleMoneyTotal];
    
    return statusString;
}

- (CardGambler*)buyCardWithNumber:(int)winningNumber {
    for (CardGambler* card in _cardsForSale) {
        if ([card cardWinningNumber] == winningNumber) {
            CardGambler* cardToReturn = card;
            [_cardsForSale removeObject:card];
            
            return cardToReturn;
        }
    }
    
    return nil; // card not found
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
