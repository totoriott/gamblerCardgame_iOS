//
//  GameBoard.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CardGambler.h"
#import "GameUtils.h"

@interface GameBoard : NSObject

@property (nonatomic) int fumbleMoneyTotal;
@property (nonatomic, strong) NSMutableArray<CardGambler*>* cardsForSale;

- (instancetype)initWithCardConfigs:(NSArray*)configs;

- (NSString*)boardStatusString;

- (CardGambler*)buyCardWithNumber:(int)winningNumber;

- (void)fumbleMoneyAdd:(int)amount;
- (GameActionStatus)fumbleMoneyRemove:(int)amount;

@end
