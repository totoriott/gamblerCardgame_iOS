//
//  TurnLog.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TurnLog : NSObject

- (void)logLuckPlay:(int)luckValue forPlayer:(int)playerId;
- (void)logLuckAdjust:(int)adjust;
- (void)logEndTurnAction:(int)action cardSelected:(int)cardNumber;

@end
