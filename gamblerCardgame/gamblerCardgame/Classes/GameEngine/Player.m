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
        
        // TODO: maybe make it so you don't have 0/1 by default?
        _cardNumbers = [NSMutableArray array];
        [_cardNumbers addObject:@0];
        [_cardNumbers addObject:@1];
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
    return _cardNumbers;
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
            [self tryToEarnCardFromGambler:card];
            return ACTION_SUCCEED;
        }
    }

    return ACTION_FAIL;
}

- (void)addCardGambler:(CardGambler*)cardGambler {
    [_cardGamblers addObject:cardGambler];
    [self tryToEarnCardFromGambler:cardGambler];
}

- (void)tryToEarnCardFromGambler:(CardGambler*)card {
    BOOL newNumber = YES;
    
    for (NSNumber* number in _cardNumbers) {
        if ([card cardCardValueGranted] == [number intValue]) {
            newNumber = NO;
        }
    }
    
    if (newNumber) {
        [_cardNumbers addObject:[NSNumber numberWithInt:[card cardCardValueGranted]]];
    }
}

// TODO: MOVE THESE INTO AI LATER AND GIVE INTELLIGENCE AND BOARD STATE
- (int)getLeadLuckCard {
    NSArray* luckCards = [self availableLuckCards];
    
    int randomIndex = (arc4random() % [luckCards count]);
    
    return [luckCards[randomIndex] intValue];
}

- (int)getLuckCard {
    return [self getLeadLuckCard];
}

- (int)getLuckAdjust {
    // TODO
    /*if (curPlayer.money >= _gameConfig.costOfAdjust) {
        int randomChance = (arc4random() % 8);
        switch (randomChance) {
            case 0:
                [self processGameActionForPlayer:_currentPlayerIndex turnState:_turnState withChoice1:1];
                break;
                
            case 1:
                [self processGameActionForPlayer:_currentPlayerIndex turnState:_turnState withChoice1:-1];
                break;
                
            default:
                [self processGameActionForPlayer:_currentPlayerIndex turnState:_turnState withChoice1:0];
                break;
        }
    }*/
    return 0;
}

- (NSArray<NSNumber*>*)getEndTurnAction {
    // TODO
    /*NSArray<NSNumber*>* cardsCanBuy = [_gameBoard cardNumbersPurchasableWithMoneyAmount:curPlayer.money];
    if ([cardsCanBuy count] > 0) {
        int randomIndex = (arc4random() % [cardsCanBuy count]);
        [self processGameActionForPlayer:_currentPlayerIndex turnState:_turnState withChoice1:ENDTURN_BUY choice2:[cardsCanBuy[randomIndex] intValue]];
    } else {
        int randomIndex = (arc4random() % [curPlayer.cardGamblers count]);
        [self processGameActionForPlayer:_currentPlayerIndex turnState:_turnState withChoice1:ENDTURN_SUPER choice2:[curPlayer.cardGamblers[randomIndex] cardWinningNumber]];
    }*/
    int randomIndex = (arc4random() % [_cardGamblers count]);
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:ENDTURN_SUPER], [NSNumber numberWithInt:[_cardGamblers[randomIndex] cardWinningNumber]], nil];
}

@end
