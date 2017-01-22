//
//  TurnLog.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameUtils.h"

@interface TurnLog : NSObject

#define TURNLOG_ACTION_NOT_CHOSEN -99

@property (nonatomic, strong) NSMutableArray<NSNumber*>* luckPlay;
@property (nonatomic) int luckAdjust;
@property (nonatomic) EndTurnAction endTurnAction;
@property (nonatomic) int endTurnCardSelected;

- (instancetype)initWithPlayerCount:(int)playerCount;

- (NSString*)turnLogStatus;
- (NSString*)turnLuckString;

- (void)logLuckPlay:(int)luckValue forPlayer:(int)playerId;
- (void)logLuckAdjust:(int)adjust;
- (void)logEndTurnAction:(EndTurnAction)action cardSelected:(int)cardNumber;

- (int)getLuckPlayForPlayer:(int)playerId;
- (int)getLuckAdjust;
- (EndTurnAction)getEndTurnAction;
- (int)getEndTurnCardSelected;

- (int)getTotalLuck;
- (NSString*)serialize;


@end
