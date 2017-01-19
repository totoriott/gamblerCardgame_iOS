//
//  GameConfig.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "GameConfig.h"

@implementation GameConfig

- (instancetype)init {
    if (self = [super init]) {
        // TODO: don't hardcode these later
        
        _moneyStart = @[@1, @1, @2, @2];
        _moneyGoal = 15;
        
       // count, win, superWin, cost, cardGet, cardGet2,  winValue, superWinValue
        _cardConfigs = @[
            @[@5, @1, @1, @1, @0, @0, @3, @5],
            @[@5, @2, @2, @1, @0, @0, @2, @4],
            @[@5, @3, @3, @1, @0, @0, @2, @4],
            @[@1, @4, @8, @1, @0, @2, @15, @15],
            @[@2, @5, @5, @1, @2, @0, @3, @6],
            @[@2, @6, @6, @1, @2, @0, @4, @7],
            @[@2, @7, @7, @1, @2, @0, @5, @8],
            @[@2, @9, @9, @1, @3, @0, @6, @10],
                         ];
    }
    return self;
}

@end
