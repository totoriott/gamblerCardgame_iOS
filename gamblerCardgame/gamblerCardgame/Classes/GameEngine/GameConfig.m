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
        
        _cardConfigs = nil; // TODO: oh boy
    }
    return self;
}

@end
