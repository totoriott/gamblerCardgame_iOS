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

- (void)performAiActions:(GameInstance *)game {
    if (![game playerCanActDuringCurrentTurnState:self.player.playerId]) {
        return;
    }
    
    NSArray<GameAction*>* actions = [self.player currentPossibleActions:game];
    if (actions.count == 0) {
        NSLog(@"No actions available when you should be able to act!"); // TODO: more detail
    } else {
        int randomIndex = (arc4random() % [actions count]);
        GameAction* action = actions[randomIndex];
        [game processGameAction:action]; // TODO: refactor to pass this back later?
    }
}

@end
