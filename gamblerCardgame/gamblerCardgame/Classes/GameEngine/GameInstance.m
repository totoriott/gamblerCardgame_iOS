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
    [self printGameStatus];
}

- (void)printGameStatus {
    NSLog(@"Turn %d", (int)[[_gameLog turns] count]);
    NSLog(@"%@", [_gameBoard boardStatusString]);
    
    for (int i = 0; i < [_players count]; i++) {
        NSLog(@"%@", [_players[i] playerStatusString]);
    }
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
