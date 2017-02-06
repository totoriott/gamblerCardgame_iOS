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

@class GameAction;

@protocol GameInstanceUpdateDelegate <NSObject>
@optional
- (void)gameInstanceWasUpdated;
@end

@interface GameInstance : NSObject

// TODO: serialize / deserialize

@property (nonatomic, strong) NSMutableArray<Player*>* players;
@property (nonatomic) int currentPlayerIndex;
@property (nonatomic) int fumbleMoneyTotal;

@property (nonatomic, strong) GameConfig* gameConfig;
@property (nonatomic, strong) GameLog* gameLog;
@property (nonatomic, strong) GameBoard* gameBoard;

@property (nonatomic, weak) id <GameInstanceUpdateDelegate> delegate;

@property (nonatomic) TurnState turnState;

- (void)initNewGameWithPlayers:(int)playerCount;
- (void)initGameFromSaveSlot:(int)saveSlot;
- (void)initGameFromSerialization:(NSString*)serial;

- (void)performAllAiActions;

- (void)processGameAction:(GameAction*)action;

- (BOOL)playerCanActDuringCurrentTurnState:(int)playerId;
- (BOOL)isGameOver;
- (int)luckPlayedByFirstPlayer;
- (int)totalLuckForTurn;
- (int)adjustForTurn;
- (NSString*)turnLuckString;
- (BOOL)haveAllPlayersPlayedLuck;
- (BOOL)hasFirstPlayerChosenAdjustAction;
- (BOOL)hasFirstPlayerChosenEndTurnAction;

- (void)processGambleForTurn:(TurnLog*)currentTurn;
- (void)processEndTurnForTurn:(TurnLog*)currentTurn;

- (NSString*)nameOfFirstPlayer;
@end
