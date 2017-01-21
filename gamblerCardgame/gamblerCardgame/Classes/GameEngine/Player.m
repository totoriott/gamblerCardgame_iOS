//
//  Player.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "Player.h"

#import "AiModel.h"
#import "GameInstance.h"

@interface Player ()
- (int)getLeadLuckCard:(GameInstance *)game;
- (int)getLuckCard:(GameInstance *)game;
- (int)getLuckAdjust:(GameInstance *)game;
- (NSArray<NSNumber*>*)getEndTurnAction:(GameInstance *)game;
@end

@implementation Player

- (instancetype)initWithId:(int)playerId defaultLuckCards:(NSArray<NSNumber*>*)defaultLuckCards {
    if (self = [super init]) {
        _playerId = playerId;
        _money = 0;
        _cardGamblers = [NSMutableArray array];
        
        _cardNumbers = [defaultLuckCards mutableCopy];
        
        _aiModel = [[AiModel alloc] initWithPlayer:self]; // TODO: switch out AiModels
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
- (int)getLeadLuckCard:(GameInstance *)game {
    NSArray* luckCards = [self availableLuckCards];
    
    int randomIndex = (arc4random() % [luckCards count]);
    
    return [luckCards[randomIndex] intValue];
}

- (int)getLuckCard:(GameInstance *)game {
    return [self getLeadLuckCard:game];
}

- (int)getLuckAdjust:(GameInstance *)game {
    if (self.money >= game.gameConfig.costOfAdjust) {
        int randomChance = (arc4random() % 8);
        switch (randomChance) {
            case 0:
                return 1;
                break;
                
            case 1:
                return -1;
                break;
                
            default:
                return 0;
                break;
        }
    }
    return 0;
}

- (NSArray<NSNumber*>*)getEndTurnAction:(GameInstance *)game {
    // TODO
    NSArray<NSNumber*>* cardsCanBuy = [game.gameBoard cardNumbersPurchasableWithMoneyAmount:self.money];
    if ([cardsCanBuy count] > 0) {
        int randomIndex = (arc4random() % [cardsCanBuy count]);
        return [NSArray arrayWithObjects:[NSNumber numberWithInt:ENDTURN_BUY], [NSNumber numberWithInt:[cardsCanBuy[randomIndex] intValue]], nil];
    } else {
        int randomIndex = (arc4random() % [self.cardGamblers count]);
        return [NSArray arrayWithObjects:[NSNumber numberWithInt:ENDTURN_SUPER], [NSNumber numberWithInt:[self.cardGamblers[randomIndex] cardWinningNumber]], nil];
    }
}

- (void)performAiActions:(GameInstance *)game {
    [self.aiModel performAiActions:game];
}

@end
