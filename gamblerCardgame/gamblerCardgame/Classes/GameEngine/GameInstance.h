//
//  GameInstance.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameBoard.h"
#import "GameConfig.h"
#import "GameLog.h"
#import "Player.h"

@interface GameInstance : NSObject

// TODO: serialize / deserialize

@property (nonatomic, strong) NSMutableArray<Player*>* players;
@property (nonatomic) int currentPlayerIndex;
@property (nonatomic) int fumbleMoneyTotal;

@property (nonatomic, strong) GameConfig* gameConfig;
@property (nonatomic, strong) GameLog* gameLog;
@property (nonatomic, strong) GameBoard* gameBoard;

@property (nonatomic) TurnState turnState;

- (void)initNewGameWithPlayers:(int)playerCount;
- (void)performAllAiActions;

- (void)processGameActionForPlayer:(int)playerId turnState:(TurnState)turnState withChoice1:(int)choice1;
- (void)processGameActionForPlayer:(int)playerId turnState:(TurnState)turnState withChoice1:(int)choice1 choice2:(int)choice2;

- (BOOL)playerCanActDuringCurrentTurnState:(int)playerId;
- (BOOL)isGameOver;
- (BOOL)hasFirstPlayerPlayedLuck;
- (BOOL)haveAllPlayersPlayedLuck;
- (BOOL)hasFirstPlayerChosenAdjustAction;
- (BOOL)hasFirstPlayerChosenEndTurnAction;

- (void)processGamble;
- (void)processEndTurn;

@end
