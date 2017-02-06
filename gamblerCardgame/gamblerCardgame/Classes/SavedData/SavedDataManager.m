//
//  SavedDataManager.h
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "SavedDataManager.h"
#import "GameLog.h"

@implementation SavedDataManager

- (GameLog *)loadGameFromSlot:(int)saveSlot {
    NSString *key = [NSString stringWithFormat:@"SaveGame%d", saveSlot];
    NSString *saveData = [[NSUserDefaults standardUserDefaults]
                          stringForKey:key];
    if (saveData) {
        return [[GameLog alloc] initFromSerialization:saveData];
    }
    
    return nil;
}

- (void)saveGame:(GameLog *)game toSlot:(int)saveSlot {
    NSString *saveData = [game serialize];
    NSString *key = [NSString stringWithFormat:@"SaveGame%d", saveSlot];
    [[NSUserDefaults standardUserDefaults] setObject:saveData forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
