//
//  AiModel.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "AiModel.h"

#import "GameAction.h"
#import "GameInstance.h"

@interface AiModel ()
@end

@implementation AiModel

- (instancetype)initWithPlayer:(Player*)myPlayer {
    if (self = [super init]) {
        _player = myPlayer;
    }
    return self;
}

- (GameAction*)getSelectedAiAction:(GameInstance *)game {
    if (![game playerCanActDuringCurrentTurnState:self.player.playerId]) {
        return nil;
    }
    
    NSArray<GameAction*>* actions = [self.player currentPossibleActions:game];
    if (actions.count == 0) {
        NSLog(@"No actions available when you should be able to act!"); 
    } else {
        int randomIndex = (arc4random() % [actions count]);
        GameAction* action = actions[randomIndex];
        return action;
    }
    
    return nil;
}

@end
