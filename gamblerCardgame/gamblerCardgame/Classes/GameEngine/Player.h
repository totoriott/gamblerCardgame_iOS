//
//  Player.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CardGambler.h"
#import "GameUtils.h"

@class GameInstance, AiModel, GameAction;

@interface Player : NSObject

@property (nonatomic) int playerId;
@property (nonatomic, strong) NSMutableArray<CardGambler*>* cardGamblers;
@property (nonatomic, strong) NSMutableArray<NSNumber*>* cardNumbers;
@property (nonatomic) int money;
@property (nonatomic, strong) AiModel* aiModel;

- (instancetype)initWithId:(int)playerId defaultLuckCards:(NSArray<NSNumber*>*)defaultLuckCards aiModel:(AiModel*)aiModel;

- (NSString*)playerStatusString;

- (NSArray<NSNumber*>*)availableLuckCards;

- (GameActionStatus)gainMoney:(int)amount;
- (int)payoffAllCardsWithValue:(int)winningNumber;

- (GameActionStatus)setCardToSuperWithValue:(int)winningNumber;
- (void)addCardGambler:(CardGambler*)cardGambler;

// TODO: MOVE THESE INTO AI LATER AND GIVE INTELLIGENCE AND BOARD STATE
- (NSArray<GameAction*>*)currentPossibleActions:(GameInstance *)game;
- (void)performAiActions:(GameInstance*)game;
@end
