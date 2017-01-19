//
//  CardGambler.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardGambler : NSObject

@property (nonatomic) BOOL isSuper;

@property (nonatomic) int winningNumber;
@property (nonatomic) int payoutValue;
@property (nonatomic) int cardValueGranted;
@property (nonatomic) int cost;

@property (nonatomic) int superWinningNumber;
@property (nonatomic) int superPayoutValue;
@property (nonatomic) int superCardValueGranted;

- (void)resetToNormal;
- (void)setToSuper;

- (int)cardWinningNumber;
- (int)cardPayoutValue;
- (int)cardCardValueGranted;

@end
