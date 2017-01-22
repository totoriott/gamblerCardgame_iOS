//
//  GameInstance.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "GameInstance.h"
#import "AiModel.h"

@implementation GameInstance

- (void)initGameFromSerialization:(NSString*)serial {
    _gameLog = [[GameLog alloc] initFromSerialization:serial];
    
    int playerCount = (int)[[[_gameLog getMostRecentTurn] luckPlay] count];
    [self initGameCommonSetup:playerCount];
    
    // TODO: this handles deserialization turn catchup
    for (TurnLog* turn in _gameLog.turns) {
        // TODO is this good
        // TODO: gotta refactor all of these to take turn IG
        
        // these will fail if not appropriate
        [self processGambleForTurn:turn];
        [self processEndTurnForTurn:turn];
    }
}

- (void)initNewGameWithPlayers:(int)playerCount {
    _gameLog = [[GameLog alloc] initWithPlayerCount:playerCount];
    
    [self initGameCommonSetup:playerCount];

    [self beginNewTurn];
}

- (void)initGameCommonSetup:(int)playerCount {
    _gameConfig = [[GameConfig alloc] init];

    _gameBoard = [[GameBoard alloc] initWithCardConfigs:_gameConfig.cardConfigs];
    
    _players = [NSMutableArray array];
    
    // TODO: refactor some of this into common
    for (int i = 0; i < playerCount; i++) {
        AiModel* aiModel = [[AiModel alloc] init];
        if (i == 0) {
            //aiModel = nil; // TODO: IT'S HARDCODE HUMAN PLAYER
        }
        
        Player* newPlayer = [[Player alloc] initWithId:i defaultLuckCards:self.gameConfig.defaultLuckCards aiModel:aiModel];
        
        int startMoney = [_gameConfig.moneyStart[i] intValue];
        [newPlayer gainMoney:startMoney];
        
        [_players addObject:newPlayer];
    }
    
    _currentPlayerIndex = 0;
    _fumbleMoneyTotal = 0;
    
    // TODO: start game stuff is here for now
    // select initial cards
    // TODO: for simplicity sake, we are just giving everyone random cards for now
    for (Player* player in _players) {
        int value1, value2;
        int randomIndex = 0; // TODO: force everyone to 1/2 for now (arc4random() % 3);
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
}

- (void)beginNewTurn {
    NSLog(@"---");
    [self printGameStatus];
    [_gameLog startNewTurn];
    _turnState = TURN_STATE_SELECT_LEAD_LUCK;
}

- (BOOL)playerCanActDuringCurrentTurnState:(int)playerId {
    TurnLog* currentTurn = [_gameLog getMostRecentTurn];
    
    switch (_turnState) {
        case TURN_STATE_SELECT_LEAD_LUCK:
            return playerId == _currentPlayerIndex && ![self hasFirstPlayerPlayedLuck];
            break;
            
        case TURN_STATE_SELECT_LUCK:
            return [currentTurn getLuckPlayForPlayer:playerId] == TURNLOG_ACTION_NOT_CHOSEN;
            break;
            
        case TURN_STATE_SELECT_ADJUST_ACTION:
            return playerId == _currentPlayerIndex && ![self hasFirstPlayerChosenAdjustAction];
            break;
            
        case TURN_STATE_SELECT_POST_GAMBLE_ACTION:
            return playerId == _currentPlayerIndex && ![self hasFirstPlayerChosenEndTurnAction];
            
        default:
            break;
    }
    
    return NO;
}

- (void)processGameActionForPlayer:(int)playerId turnState:(TurnState)turnState withChoice1:(int)choice1 {
    [self processGameActionForPlayer:playerId turnState:turnState withChoice1:choice1 choice2:0];
}

- (void)processGameActionForPlayer:(int)playerId turnState:(TurnState)turnState withChoice1:(int)choice1 choice2:(int)choice2  {
    
    if (turnState != _turnState) {
        return; // TODO: game action appears to be invalid, can we bounce this more cleverly?
    }
    
    if (![self playerCanActDuringCurrentTurnState:playerId]) {
        return;
    }
    
    TurnLog* currentTurn = [_gameLog getMostRecentTurn];
    
    // TODO: check validity of inputs and return
    
    switch (turnState) {
        case TURN_STATE_SELECT_LEAD_LUCK:
            NSLog(@"P%d leads with a %d", playerId, choice1);
            [currentTurn logLuckPlay:choice1 forPlayer:playerId];
            break;
            
        case TURN_STATE_SELECT_LUCK:
            [currentTurn logLuckPlay:choice1 forPlayer:playerId];
            break;
            
        case TURN_STATE_SELECT_ADJUST_ACTION:
            [currentTurn logLuckAdjust:choice1];
            break;
            
        case TURN_STATE_SELECT_POST_GAMBLE_ACTION:
            [currentTurn logEndTurnAction:(EndTurnAction)choice1 cardSelected:choice2];
            break;
            
        default:
            break;
    }
    
    // Update game state
    if ([self hasFirstPlayerPlayedLuck] && _turnState == TURN_STATE_SELECT_LEAD_LUCK) {
        _turnState = TURN_STATE_SELECT_LUCK;
    } else if ([self haveAllPlayersPlayedLuck] && _turnState == TURN_STATE_SELECT_LUCK) { 
        _turnState = TURN_STATE_SELECT_ADJUST_ACTION;
    } else if ([self shouldProcessGamble]) {
        [self processGambleForTurn:[_gameLog getMostRecentTurn]];
    } else if ([self shouldProcessEndTurn]) {
        [self processEndTurnForTurn:[_gameLog getMostRecentTurn]];
        [self beginNewTurn];
    }
    
    // TODO: testing serialization here
    NSLog(@"%@", [_gameLog serialize]);
    
    if (![self isGameOver]) {
        [self performAllAiActions];
    }
}

- (void)performAllAiActions {
    // TODO: only process AI actions if you're the "server" of course
    for (Player* player in _players) {
        [player performAiActions:self];
    }
}

- (BOOL)shouldProcessGamble {
    return [self haveAllPlayersPlayedLuck] && [self hasFirstPlayerChosenAdjustAction] && _turnState == TURN_STATE_SELECT_ADJUST_ACTION;
}

- (BOOL)shouldProcessEndTurn {
    return [self hasFirstPlayerChosenEndTurnAction] && _turnState == TURN_STATE_SELECT_POST_GAMBLE_ACTION;
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
    return [currentTurn getEndTurnAction] != ENDTURN_NOT_SELECTED;
}

- (void)processGambleForTurn:(TurnLog*)currentTurn {
    Player* curPlayer = [self getCurPlayer];
    
    if ([currentTurn getLuckAdjust] == TURNLOG_ACTION_NOT_CHOSEN) {
        return;
    }

    // process adjusting
    if ([currentTurn getLuckAdjust] != 0) {
        [curPlayer gainMoney:-1 * _gameConfig.costOfAdjust];
    }
    
    // pay off all winners
    int totalLuck = [currentTurn getTotalLuck];
    NSLog(@"Today's luck: %@ = %d", [currentTurn turnLuckString], totalLuck);
    
    BOOL someoneWon = NO;
    for (Player* player in _players) {
        int amountWon = [player payoffAllCardsWithValue:totalLuck];
        
        if (amountWon > 0) {
            NSLog(@"P%d earns $%d", player.playerId, amountWon);
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
                NSLog(@"P%d fumbles $%d", player.playerId, fumbleAmount);
                [player gainMoney:-1 * fumbleAmount];
                [_gameBoard fumbleMoneyAdd:fumbleAmount];
            }
        }
        
        // redistribute fumble
        while (_gameBoard.fumbleMoneyTotal >= (int)[_players count]) {
            [_gameBoard fumbleMoneyRemove:(int)[_players count]];
            NSLog(@"All players take $1 from fumble stock");
            for (Player* player in _players) {
                [player gainMoney:1];
            }
        }
    }
    
    _turnState = TURN_STATE_SELECT_POST_GAMBLE_ACTION;
}

- (void)processEndTurnForTurn:(TurnLog*)currentTurn {
    CardGambler* cardBought;
    Player* curPlayer = [self getCurPlayer];
    
    if ([currentTurn getEndTurnAction] == ENDTURN_NOT_SELECTED) {
        return;
    }
    
    switch ([currentTurn getEndTurnAction]) {
        case ENDTURN_BUY:
            cardBought = [_gameBoard buyCardWithNumber:[currentTurn getEndTurnCardSelected]];
            if (cardBought && curPlayer.money >= cardBought.cost) {
                [curPlayer gainMoney:-1 * cardBought.cost];
                [curPlayer addCardGambler:cardBought];
            }
            NSLog(@"P%d buys a %d", _currentPlayerIndex, [currentTurn getEndTurnCardSelected]);
            break;
            
        case ENDTURN_SUPER:
            [curPlayer setCardToSuperWithValue:[currentTurn getEndTurnCardSelected]];
            NSLog(@"P%d supers a %d", _currentPlayerIndex, [currentTurn getEndTurnCardSelected]);
            break;
            
        case ENDTURN_NOT_SELECTED:
            break;
    }

    _currentPlayerIndex += 1;
    if (_currentPlayerIndex >= [_players count]) {
        _currentPlayerIndex = 0;
    }
}

@end
