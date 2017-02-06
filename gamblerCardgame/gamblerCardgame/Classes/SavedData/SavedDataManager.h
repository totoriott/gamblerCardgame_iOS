//
//  SavedDataManager.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameLog;

@interface SavedDataManager : NSObject

- (void)saveGame:(GameLog*)game toSlot:(int)saveSlot;
- (GameLog*)loadGameFromSlot:(int)saveSlot;

@end
