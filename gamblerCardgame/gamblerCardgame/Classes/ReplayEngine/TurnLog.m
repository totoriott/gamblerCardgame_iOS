//
//  TurnLog.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/15/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "TurnLog.h"

@implementation TurnLog

- (instancetype)initWithPlayerCount:(int)playerCount {
    if (self = [super init]) {
        _luckPlay = [NSMutableArray array];
        for (int i = 0; i < playerCount; i++) {
            [_luckPlay addObject:[NSNumber numberWithInt:TURNLOG_ACTION_NOT_CHOSEN]];
        }
        
        _luckAdjust = TURNLOG_ACTION_NOT_CHOSEN;
        _endTurnAction = ENDTURN_NOT_SELECTED;
        _endTurnCardSelected = TURNLOG_ACTION_NOT_CHOSEN;
    }
    return self;
}

- (instancetype)initFromSerialization:(NSString*)serial {
    if (self = [super init]) {
        NSArray<NSString*>* components = [serial componentsSeparatedByString:@","];
        
        _luckPlay = [NSMutableArray array];
        for (int i = 0; i < components[0].length; i++) {
            int luckPlayed = TURNLOG_ACTION_NOT_CHOSEN;
            if ([components[0] characterAtIndex:i] != '?') {
                luckPlayed = [components[0] characterAtIndex:i] - 48;
            }
            
            [_luckPlay addObject:[NSNumber numberWithInt:luckPlayed]];
        }
        
        // TODO: erorr checking?
        _luckAdjust = TURNLOG_ACTION_NOT_CHOSEN;
        if (![components[1] isEqualToString:@"?"]) {
            _luckAdjust = [components[1] intValue];
        }

        // TODO: i convert these real lazily
        _endTurnAction = ([components[2] characterAtIndex:0] - 48);
        
        _endTurnCardSelected = TURNLOG_ACTION_NOT_CHOSEN;
        if ([components[2] characterAtIndex:1] != '?') {
            _endTurnCardSelected = ([components[2] characterAtIndex:1] - 48);
        }
        
    }
    return self;
}

- (NSString *)turnLogStatus {
    return [self serialize]; // TODO
}

- (NSString *)turnLuckString {
    NSString* statusString = @"";
    for (NSNumber* play in _luckPlay) {
        if ([play intValue] == TURNLOG_ACTION_NOT_CHOSEN) {
            statusString = [NSString stringWithFormat:@"%@?", statusString];
        } else {
            statusString = [NSString stringWithFormat:@"%@%d", statusString, [play intValue]];
        }
    }
    
    if (_luckAdjust != TURNLOG_ACTION_NOT_CHOSEN) {
        statusString = [NSString stringWithFormat:@"%@ + %d", statusString, _luckAdjust];
    }
    
    return statusString;
}

- (void)logLuckPlay:(int)luckValue forPlayer:(int)playerId {
    _luckPlay[playerId] = [NSNumber numberWithInt:luckValue];
}

- (void)logLuckAdjust:(int)adjust {
    _luckAdjust = adjust;
}

- (void)logEndTurnAction:(EndTurnAction)action cardSelected:(int)cardNumber {
    _endTurnAction = action;
    _endTurnCardSelected = cardNumber;
}

- (int)getLuckPlayForPlayer:(int)playerId {
    return [_luckPlay[playerId] intValue]; // TODO bounds check
}

- (int)getLuckAdjust {
    return _luckAdjust;
}

- (EndTurnAction)getEndTurnAction {
    return _endTurnAction;
}

- (int)getEndTurnCardSelected {
    return _endTurnCardSelected;
}

- (int)getTotalLuck {
    int totalLuck = 0;
    
    for (NSNumber* play in _luckPlay) {
        if ([play intValue] != TURNLOG_ACTION_NOT_CHOSEN) {
            totalLuck += [play intValue];
        }
    }
    
    if (_luckAdjust != TURNLOG_ACTION_NOT_CHOSEN) {
        totalLuck += _luckAdjust;
    }
    
    return totalLuck;
}

- (NSString *)serialize {
    NSString* statusString = @"";
    for (NSNumber* play in _luckPlay) {
        if ([play intValue] == TURNLOG_ACTION_NOT_CHOSEN) {
            statusString = [NSString stringWithFormat:@"%@?", statusString];
        } else {
            statusString = [NSString stringWithFormat:@"%@%d", statusString, [play intValue]];
        }
    }
    
    statusString = [NSString stringWithFormat:@"%@,", statusString];
    
    if (_luckAdjust != TURNLOG_ACTION_NOT_CHOSEN) {
        statusString = [NSString stringWithFormat:@"%@%d", statusString, _luckAdjust];
    } else {
        statusString = [NSString stringWithFormat:@"%@?", statusString];
    }
    
    
    statusString = [NSString stringWithFormat:@"%@,%d", statusString, (int)_endTurnAction];
    
    if (_endTurnCardSelected != TURNLOG_ACTION_NOT_CHOSEN) {
        statusString = [NSString stringWithFormat:@"%@%d", statusString, _endTurnCardSelected];
    } else {
        statusString = [NSString stringWithFormat:@"%@?", statusString];
    }
    
    return statusString;
}

@end
