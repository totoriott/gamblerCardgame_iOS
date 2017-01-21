//
//  ViewController.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/18/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "ViewController.h"

#import "GameInstance.h"

@interface ViewController ()

@property (nonatomic, strong) GameInstance* game;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self pressedReset:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedReset:(id)sender {
    // Testing point for text-based app
    self.game = [[GameInstance alloc] init];
    [self.game initNewGameWithPlayers:4];
    [self.game performAllAiActions]; // TODO: move later?
}

- (IBAction)pressedLuck:(UIButton *)sender {
    // TODO: human is hardcoded rn
    if (self.game.turnState != TURN_STATE_SELECT_LUCK && self.game.turnState != TURN_STATE_SELECT_LEAD_LUCK) {
        return;
    }
    
    int luckValue = 0;
    if ([[sender currentTitle] containsString:@"1"]) {
        luckValue = 1;
    } else if ([[sender currentTitle] containsString:@"2"]) {
        luckValue = 2;
    }else if ([[sender currentTitle] containsString:@"3"]) {
        luckValue = 3;
    }
    
    // TODO: make sure it is a valid action
    [self.game processGameActionForPlayer:0 turnState:self.game.turnState withChoice1:luckValue];
}

- (IBAction)pressedAdjust:(UIButton *)sender {
    // TODO: confirm valid
    
    int adjustValue = 0;
    if ([[sender currentTitle] containsString:@"-"]) {
        adjustValue = -1;
    } else if ([[sender currentTitle] containsString:@"+"]) {
        adjustValue = 1;
    }
    
    [self.game processGameActionForPlayer:0 turnState:TURN_STATE_SELECT_ADJUST_ACTION withChoice1:adjustValue];
}

- (IBAction)pressedEndAction:(UIButton *)sender {
    // TODO: confirm valid
    
    [self.game processGameActionForPlayer:0 turnState:TURN_STATE_SELECT_POST_GAMBLE_ACTION withChoice1:ENDTURN_SUPER choice2:1];
}

@end
