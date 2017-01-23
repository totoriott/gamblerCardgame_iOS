//
//  GameAction.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameUtils.h"

@interface GameAction : NSObject

@property (nonatomic) int playerId;
@property (nonatomic) TurnState turnState;
@property (nonatomic) int choice1;
@property (nonatomic) int choice2;

@property (nonatomic, strong) NSString* readableName;

@end
