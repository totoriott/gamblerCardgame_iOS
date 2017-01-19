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

@property (nonatomic, weak) NSMutableArray<Player*>* players;
@property (nonatomic) int currentPlayerIndex;
@property (nonatomic) int fumbleMoneyTotal;

@property (nonatomic, weak) GameConfig* gameConfig;
@property (nonatomic, weak) GameLog* gameLog;
@property (nonatomic, weak) GameBoard* gameBoard;

@end
