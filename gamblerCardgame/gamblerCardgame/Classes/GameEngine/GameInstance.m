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
    
    // TODO: init game board
    
    _players = [NSMutableArray array];
    
    for (int i = 0; i < playerCount; i++) {
        Player* newPlayer = [[Player alloc] init];
        
        int startMoney = [_gameConfig.moneyStart[i] intValue];
        [newPlayer gainMoney:startMoney];
        
        [_players addObject:newPlayer];
    }

    _currentPlayerIndex = 0;
    _fumbleMoneyTotal = 0;
}

- (void)runGame {
    return; // TODO
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
    return; // TODO
}

- (void)processEndTurn {
    return; // TODO
}

@end
