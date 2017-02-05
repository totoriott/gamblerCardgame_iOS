//
//  GameActionCollectionViewCell.h
//  gamblerCardgame
//
//  Created by Eric Aleshire on 2/5/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameAction;

@interface GameActionCollectionViewCell : UICollectionViewCell

- (void)setupWithGameAction:(GameAction*)myAction;

@end
