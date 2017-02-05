//
//  GameActionCollectionViewCell.m
//  gamblerCardgame
//
//  Created by sayumeki on 2/5/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "GameAction.h"
#import "GameActionCollectionViewCell.h"

@interface GameActionCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *actionName;
@property (weak, nonatomic) GameAction* action;
@end

@implementation GameActionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupWithGameAction:(GameAction *)myAction {
    self.action = myAction;
    self.actionName.text = self.action.readableName;
}

- (GameAction*)getGameAction {
    return _action;
}

@end
