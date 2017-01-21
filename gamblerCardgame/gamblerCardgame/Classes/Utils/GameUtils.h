//
//  GameUtils.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GameActionStatus) {
    ACTION_FAIL,
    ACTION_SUCCEED
};

typedef NS_ENUM(NSUInteger, EndTurnAction) {
    ENDTURN_NOT_SELECTED,
    ENDTURN_SUPER,
    ENDTURN_BUY
};

typedef NS_ENUM(NSUInteger, TurnState) {
    TURN_STATE_SELECT_LEAD_LUCK,
    TURN_STATE_SELECT_LUCK,
    TURN_STATE_SELECT_ADJUST_ACTION,
    TURN_STATE_SELECT_POST_GAMBLE_ACTION,
    TURN_STATE_TURN_FINISHED
};

@interface GameUtils : NSObject

@end
