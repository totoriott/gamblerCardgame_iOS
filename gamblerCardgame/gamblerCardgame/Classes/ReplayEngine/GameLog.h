//
//  GameLog.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TurnLog.h"

@interface GameLog : NSObject

@property (nonatomic) int playerCount;
@property (nonatomic, weak) NSMutableArray<TurnLog*>* turns;

- (TurnLog*)mostRecentTurn;

- (void)startNewTurn;

@end
