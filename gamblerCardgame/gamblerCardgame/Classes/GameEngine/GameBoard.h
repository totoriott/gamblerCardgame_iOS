//
//  GameBoard.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CardGambler.h"

@interface GameBoard : NSObject

@property (nonatomic) int fumbleMoneyTotal;
@property (nonatomic, weak) NSMutableArray<CardGambler*>* cardsForSale; // TODO: consider refactoring how this is stored

- (CardGambler*)buyCardWithNumber:(int)winningNumber;

- (void)fumbleMoneyAdd:(int)amount;
- (void)fumbleMoneyRemove:(int)amount;

@end
