//
//  GameInstance.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "GameInstance.h"

@implementation GameInstance

- (void)initNewGameWithPlayers:(int)playerCount {
    _gameConfig = [[GameConfig alloc] init];
    _gameLog = [[GameLog alloc] initWithPlayerCount:playerCount];
    
    _gameBoard = [[GameBoard alloc] initWithCardConfigs:_gameConfig.cardConfigs];
    
    _players = [NSMutableArray array];
    
    for (int i = 0; i < playerCount; i++) {
        Player* newPlayer = [[Player alloc] initWithId:i];
        
        int startMoney = [_gameConfig.moneyStart[i] intValue];
        [newPlayer gainMoney:startMoney];
        
        [_players addObject:newPlayer];
    }

    _currentPlayerIndex = 0;
    _fumbleMoneyTotal = 0;
}

- (void)runGame {
    // select initial cards
    // TODO: for simplicity sake, we are just giving everyone random cards for now
    for (Player* player in _players) {
        int value1, value2;
        int randomIndex = (arc4random() % 3);
        switch (randomIndex) {
            case 0:
                value1 = 1;
                value2 = 2;
                break;
                
            case 1:
                value1 = 1;
                value2 = 3;
                break;
                
            case 2: default:
                value1 = 2;
                value2 = 3;
                break;
        }
        
        CardGambler* card1 = [_gameBoard buyCardWithNumber:value1];
        CardGambler* card2 = [_gameBoard buyCardWithNumber:value2];
        
        [player addCardGambler:card1];
        [player addCardGambler:card2];
    }
    
    [_gameLog startNewTurn];
    
    while (![self isGameOver]) {
        // TODO: people select luck
        TurnLog* currentTurn = [_gameLog getMostRecentTurn];
        for (Player* player in _players) {
            NSArray* luckCards = [player availableLuckCards];
            
            int randomIndex = (arc4random() % [luckCards count]);
            
            [currentTurn logLuckPlay:[luckCards[randomIndex] intValue] forPlayer:player.playerId];
        }

        // TODO: P selects luck adjust
        Player* curPlayer = [self getCurPlayer];
        if (curPlayer.money >= _gameConfig.costOfAdjust) {
            int randomChance = (arc4random() % 8);
            switch (randomChance) {
                case 0:
                    [currentTurn logLuckAdjust:1];
                    break;
                    
                case 1:
                    [currentTurn logLuckAdjust:-1];
                    break;
                    
                default:
                    [currentTurn logLuckAdjust:0];
                    break;
            }
        }
        
        [self processGamble];
        
        // TODO: P selects end-turn action
        
        [self processEndTurn];
        [self printGameStatus];
    }
}

- (Player*)getCurPlayer {
    return _players[_currentPlayerIndex];
}

- (BOOL)isGameOver {
    for (Player* player in _players) {
        if (player.money >= _gameConfig.moneyGoal) {
            return YES;
        }
    }
    
    return NO;
}

- (void)printGameStatus {
    NSLog(@"Turn %d - Active P%d", (int)[[_gameLog turns] count], _currentPlayerIndex);
    NSLog(@"%@", [_gameBoard boardStatusString]);
    
    for (int i = 0; i < [_players count]; i++) {
        NSLog(@"%@", [_players[i] playerStatusString]);
    }
    
    NSLog(@"");
}

- (BOOL)hasFirstPlayerPlayedLuck {
    TurnLog* currentTurn = [_gameLog getMostRecentTurn];
    return [currentTurn getLuckPlayForPlayer:_currentPlayerIndex] != TURNLOG_ACTION_NOT_CHOSEN;
}

- (BOOL)haveAllPlayersPlayedLuck {
    TurnLog* currentTurn = [_gameLog getMostRecentTurn];
    for (int i = 0; i < [_players count]; i++) {
        if ([currentTurn getLuckPlayForPlayer:i] == TURNLOG_ACTION_NOT_CHOSEN) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)hasFirstPlayerChosenAdjustAction {
    TurnLog* currentTurn = [_gameLog getMostRecentTurn];
    return [currentTurn getLuckAdjust] != TURNLOG_ACTION_NOT_CHOSEN;
}

- (BOOL)hasFirstPlayerChosenEndTurnAction {
    TurnLog* currentTurn = [_gameLog getMostRecentTurn];
    return [currentTurn getEndTurnAction] != TURNLOG_ACTION_NOT_CHOSEN;
}

- (void)processGamble {
    Player* curPlayer = [self getCurPlayer];
    TurnLog* currentTurn = [_gameLog getMostRecentTurn];
    NSLog(@"%@", [currentTurn turnLogStatus]);
    
    // process adjusting
    if ([currentTurn getLuckAdjust] != 0) {
        [curPlayer gainMoney:-1 * _gameConfig.costOfAdjust];
    }
    
    // pay off all winners
    int totalLuck = [currentTurn getTotalLuck];
    BOOL someoneWon = NO;
    for (Player* player in _players) {
        int amountWon = [player payoffAllCardsWithValue:totalLuck];
        
        if (amountWon > 0) {
            someoneWon = YES;
        }
    }
    
    // fumble
    if (!someoneWon) {
        // see who will fumble
        int highestMoney = 0;
        for (Player* player in _players) {
            if (player.money > highestMoney) {
                highestMoney = player.money;
            }
        }
        
        // do fumble
        int fumbleAmount = highestMoney / 2;
        for (Player* player in _players) {
            if (player.money == highestMoney) {
                [player gainMoney:-1 * fumbleAmount];
                [_gameBoard fumbleMoneyAdd:fumbleAmount];
            }
        }
        
        // redistribute fumble
        while (_gameBoard.fumbleMoneyTotal >= (int)[_players count]) {
            [_gameBoard fumbleMoneyRemove:(int)[_players count]];
            for (Player* player in _players) {
                [player gainMoney:1];
            }
        }
        
    }
}

- (void)processEndTurn {
    // TODO: end turn action stuff
    
    [_gameLog startNewTurn];
}

@end
