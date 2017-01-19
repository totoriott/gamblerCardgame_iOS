//
//  CardGambler.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameUtils.h"

@interface CardGambler : NSObject

@property (nonatomic) BOOL isSuper;

@property (nonatomic) int winningNumber;
@property (nonatomic) int payoutValue;
@property (nonatomic) int cardValueGranted;
@property (nonatomic) int cost;

@property (nonatomic) int superWinningNumber;
@property (nonatomic) int superPayoutValue;
@property (nonatomic) int superCardValueGranted;

- (instancetype)initWithCardConfig:(NSArray*)config;

- (GameActionStatus)resetToNormal;
- (GameActionStatus)setToSuper;

- (int)cardWinningNumber;
- (int)cardPayoutValue;
- (int)cardCardValueGranted;

@end
