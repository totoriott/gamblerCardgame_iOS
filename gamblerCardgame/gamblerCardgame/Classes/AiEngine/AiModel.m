//
//  AiModel.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "AiModel.h"

#import "GameAction.h"
#import "GameInstance.h"

@interface AiModel ()
- (int)getLeadLuckCard:(GameInstance *)game;
- (int)getLuckCard:(GameInstance *)game;
- (int)getLuckAdjust:(GameInstance *)game;
- (NSArray<NSNumber*>*)getEndTurnAction:(GameInstance *)game;
@end

@implementation AiModel

- (instancetype)initWithPlayer:(Player*)myPlayer {
    if (self = [super init]) {
        _player = myPlayer;
    }
    return self;
}

- (int)getLeadLuckCard:(GameInstance *)game {
    NSArray* luckCards = [self.player availableLuckCards];
    
    int randomIndex = (arc4random() % [luckCards count]);
    
    return [luckCards[randomIndex] intValue];
}

- (int)getLuckCard:(GameInstance *)game {
    return [self getLeadLuckCard:game];
}

- (int)getLuckAdjust:(GameInstance *)game {
    if (self.player.money >= game.gameConfig.costOfAdjust) {
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
    NSArray<NSNumber*>* cardsCanBuy = [game.gameBoard cardNumbersPurchasableWithMoneyAmount:self.player.money];
    if ([cardsCanBuy count] > 0) {
        int randomIndex = (arc4random() % [cardsCanBuy count]);
        return [NSArray arrayWithObjects:[NSNumber numberWithInt:ENDTURN_BUY], [NSNumber numberWithInt:[cardsCanBuy[randomIndex] intValue]], nil];
    } else {
        int randomIndex = (arc4random() % [self.player.cardGamblers count]);
        return [NSArray arrayWithObjects:[NSNumber numberWithInt:ENDTURN_SUPER], [NSNumber numberWithInt:[self.player.cardGamblers[randomIndex] cardWinningNumber]], nil];
    }
}

- (void)performAiActions:(GameInstance *)game {
    if (![game playerCanActDuringCurrentTurnState:self.player.playerId]) {
        return;
    }
    
    BOOL isCurPlayer = self.player.playerId == game.currentPlayerIndex;
    GameAction* action = [[GameAction alloc] init];
    action.playerId = self.player.playerId;
    
    switch (game.turnState) {
        case TURN_STATE_SELECT_LEAD_LUCK:
            action.turnState = game.turnState;
            action.choice1 = [self getLeadLuckCard:game];
            [game processGameAction:action];
            break;
            
        case TURN_STATE_SELECT_LUCK:
            action.turnState = game.turnState;
            action.choice1 = [self getLuckCard:game];
            [game processGameAction:action];
            break;
            
        case TURN_STATE_SELECT_ADJUST_ACTION:
            if (isCurPlayer) {
                action.turnState = game.turnState;
                action.choice1 = [self getLuckAdjust:game];
                [game processGameAction:action];
            }
            break;
            
        case TURN_STATE_SELECT_POST_GAMBLE_ACTION:
            if (isCurPlayer) {
                NSArray<NSNumber*>* playerChoice = [self getEndTurnAction:game];
                action.turnState = game.turnState;
                action.choice1 = [playerChoice[0] intValue];
                action.choice2 = [playerChoice[1] intValue]; // TODO: maybe refactor choice into an array?
                [game processGameAction:action];
            }
            break;
            
        default:
            break;
    }
}

@end
