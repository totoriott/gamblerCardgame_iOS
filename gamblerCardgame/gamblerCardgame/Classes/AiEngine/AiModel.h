//
//  AiModel.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CardGambler.h"
#import "GameUtils.h"

@class GameInstance, Player, GameAction;

@interface AiModel : NSObject

@property (nonatomic, strong) Player* player;

- (instancetype)initWithPlayer:(Player*)myPlayer;
- (GameAction*)getSelectedAiAction:(GameInstance*)game;

@end
