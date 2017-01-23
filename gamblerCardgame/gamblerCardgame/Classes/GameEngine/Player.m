//
//  Player.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "Player.h"

#import "AiModel.h"
#import "GameAction.h"
#import "GameInstance.h"

@implementation Player

- (instancetype)initWithId:(int)playerId defaultLuckCards:(NSArray<NSNumber*>*)defaultLuckCards aiModel:(AiModel*)aiModel {
    if (self = [super init]) {
        _playerId = playerId;
        _money = 0;
        _cardGamblers = [NSMutableArray array];
        
        _cardNumbers = [defaultLuckCards mutableCopy];
        
        _aiModel = [aiModel initWithPlayer:self]; // TODO: switch out AiModels
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

- (void)performAiActions:(GameInstance *)game {
    /*
    NSArray* possibleActions = [self currentPossibleActions:game];
    for (GameAction* action in possibleActions) {
        NSLog(@"%@", action.readableName);
    }
    NSLog(@"...");
    // TODO: remove for testing */
    
    [self.aiModel performAiActions:game];
}

// what this player can currently do
- (NSArray<GameAction*>*)currentPossibleActions:(GameInstance *)game {
    NSMutableArray<GameAction*>* actions = [NSMutableArray array];
    
    if (![game playerCanActDuringCurrentTurnState:self.playerId]) {
        return actions;
    }
    
    BOOL isCurPlayer = self.playerId == game.currentPlayerIndex;
    
    if (game.turnState == TURN_STATE_SELECT_LEAD_LUCK || game.turnState == TURN_STATE_SELECT_LUCK) {
        for (NSNumber* luck in [self availableLuckCards]) {
            GameAction* action = [[GameAction alloc] init];
            action.playerId = self.playerId;
            action.turnState = game.turnState;
            action.choice1 = [luck intValue];
            action.readableName = [NSString stringWithFormat:@"Luck %d", [luck intValue]];
            [actions addObject:action];
        }
    } else if (game.turnState == TURN_STATE_SELECT_ADJUST_ACTION && isCurPlayer) {
        // TODO: don't hardcode adjust +/- 1
        for (int i = -1; i <= 1; i += 1) {
            GameAction* action = [[GameAction alloc] init];
            action.playerId = self.playerId;
            action.turnState = game.turnState;
            action.choice1 = i;
            action.readableName = [NSString stringWithFormat:@"Adjust %d", i];
            if (i == 0 || game.gameConfig.costOfAdjust <= self.money) {
                [actions addObject:action];
            }
        }
    } else if (game.turnState == TURN_STATE_SELECT_POST_GAMBLE_ACTION && isCurPlayer) {
        // cards you can buy
        NSArray<NSNumber*>* cardsCanBuy = [game.gameBoard cardNumbersPurchasableWithMoneyAmount:self.money];
        for (NSNumber* card in cardsCanBuy) {
            GameAction* action = [[GameAction alloc] init];
            action.playerId = self.playerId;
            action.turnState = game.turnState;
            action.choice1 = ENDTURN_BUY;
            action.choice2 = [card intValue];
            action.readableName = [NSString stringWithFormat:@"Buy %d", [card intValue]];
            [actions addObject:action];
        }
        
        // cards you can super
        // TODO: deduplicate, don't let you super already-supered cards when you implement "no action" action
        for (CardGambler* card in self.cardGamblers) {
            GameAction* action = [[GameAction alloc] init];
            action.playerId = self.playerId;
            action.turnState = game.turnState;
            action.choice1 = ENDTURN_SUPER;
            action.choice2 = [card cardWinningNumber];
            action.readableName = [NSString stringWithFormat:@"Super %d", [card cardWinningNumber]];
            [actions addObject:action];
        }
    }
    
    return actions;
}

@end
