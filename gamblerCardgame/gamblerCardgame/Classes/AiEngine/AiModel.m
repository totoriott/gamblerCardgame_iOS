//
//  AiModel.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "AiModel.h"

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

    switch (game.turnState) {
        case TURN_STATE_SELECT_LEAD_LUCK:
            [game processGameActionForPlayer:self.player.playerId turnState:game.turnState withChoice1:[self getLeadLuckCard:game]];
            break;
            
        case TURN_STATE_SELECT_LUCK:
            [game processGameActionForPlayer:self.player.playerId turnState:game.turnState withChoice1:[self getLuckCard:game]];
            break;
            
        case TURN_STATE_SELECT_ADJUST_ACTION:
            if (isCurPlayer) {
                [game processGameActionForPlayer:self.player.playerId turnState:game.turnState withChoice1:[self getLuckAdjust:game]];
            }
            break;
            
        case TURN_STATE_SELECT_POST_GAMBLE_ACTION:
            if (isCurPlayer) {
                NSArray<NSNumber*>* playerChoice = [self getEndTurnAction:game];
                [game processGameActionForPlayer:self.player.playerId turnState:game.turnState withChoice1:[playerChoice[0] intValue] choice2:[playerChoice[1] intValue]];
            }
            break;
            
        default:
            break;
    }
}

@end