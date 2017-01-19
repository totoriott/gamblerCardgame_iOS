//
//  Player.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CardGambler.h"

@interface Player : NSObject

@property (nonatomic, weak) NSMutableArray<CardGambler*>* cardGamblers;
@property (nonatomic) int money;

- (NSArray<NSNumber*>*)availableLuckCards;

@end
