//
//  GameConfig.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameConfig : NSObject

@property (nonatomic) NSArray<NSNumber*>* moneyStart;
@property (nonatomic) int costOfAdjust;
@property (nonatomic) int moneyGoal;
@property (nonatomic, strong) NSArray* cardConfigs;

@end
