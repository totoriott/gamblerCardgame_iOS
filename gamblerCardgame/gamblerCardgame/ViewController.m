//
//  ViewController.m
//  gamblerCardgame
//
//  Created by sayumeki on 1/18/17.
//  Copyright © 2017 sayumeki. All rights reserved.
//

#import "ViewController.h"

#import "GameAction.h"
#import "GameActionCollectionViewCell.h"
#import "GameInstance.h"
#import "Player.h"

@interface ViewController ()

@property (nonatomic, strong) GameInstance* game;

@property (strong, nonatomic) NSArray<GameAction*> *playerGameActions;

@property (weak, nonatomic) IBOutlet UILabel *gameStatusLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *playerInfoLabels;
@property (weak, nonatomic) IBOutlet UICollectionView *actionCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.actionCollectionView.delegate = self;
    self.actionCollectionView.dataSource = self;
    [self.actionCollectionView registerNib:[UINib nibWithNibName:@"GameActionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GameActionCollectionViewCell"];
    
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
    //[self.game initGameFromSerialization:@"4;0101,1,11;0110,0,26;0100,-1,23;1101,1,21;1101,0,23;0011,-1,22;0211,0,27;0121,-1,26;1101,-1,29;3220,0,23;0202,0,23;0012,1,25;3000,0,25;0021,1,29;3201,0,23;2000,1,27;2101,0,24;1020,0,12;2102,0,13;2002,0,11;????,?,0?"];
    
    [self.game performAllAiActions]; // TODO: move later?
    
    [self gameInstanceStateUpdate];
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
    GameAction* action = [[GameAction alloc] init];
    action.playerId = 0;
    action.turnState = self.game.turnState;
    action.choice1 = luckValue;
    [self.game processGameAction:action];
    
    [self gameInstanceStateUpdate];
}

- (IBAction)pressedAdjust:(UIButton *)sender {
    // TODO: confirm valid
    
    int adjustValue = 0;
    if ([[sender currentTitle] containsString:@"-"]) {
        adjustValue = -1;
    } else if ([[sender currentTitle] containsString:@"+"]) {
        adjustValue = 1;
    }
    
    GameAction* action = [[GameAction alloc] init];
    action.playerId = 0;
    action.turnState = TURN_STATE_SELECT_ADJUST_ACTION;
    action.choice1 = adjustValue;
    [self.game processGameAction:action];
    
    [self gameInstanceStateUpdate];
}

- (IBAction)pressedEndAction:(UIButton *)sender {
    // TODO: confirm valid
    
    GameAction* action = [[GameAction alloc] init];
    action.playerId = 0;
    action.turnState = TURN_STATE_SELECT_POST_GAMBLE_ACTION;
    action.choice1 = ENDTURN_SUPER;
    action.choice2 = 1;
    [self.game processGameAction:action];
    
    [self gameInstanceStateUpdate];
}

- (void)gameInstanceStateUpdate {
    // set game status UI
    NSString* statusString = @"";
    switch (self.game.turnState) {
        case TURN_STATE_SELECT_LEAD_LUCK:
            statusString = [NSString stringWithFormat:@"Leader %@ to select luck first", [self.game nameOfFirstPlayer]];
            break;
            
        case TURN_STATE_SELECT_LUCK:
            statusString = [NSString stringWithFormat:@"%@ selected %d, others to select luck", [self.game nameOfFirstPlayer], [self.game luckPlayedByFirstPlayer]];
            break;
            
        case TURN_STATE_SELECT_ADJUST_ACTION:
            statusString = [NSString stringWithFormat:@"%@ to select adjust value", [self.game nameOfFirstPlayer]];
            break;
            
        case TURN_STATE_SELECT_POST_GAMBLE_ACTION:
            statusString = [NSString stringWithFormat:@"%@ = %d, %@ to post-gamble action", [self.game turnLuckString], [self.game totalLuckForTurn], [self.game nameOfFirstPlayer]];
            break;
            
        default:
            statusString = @"Unknown Turn State";
            break;
    }
    self.gameStatusLabel.text = statusString;
    
    // print each player's status
    for (UILabel* playerLabel in self.playerInfoLabels) {
        Player* player = self.game.players[playerLabel.tag];
        if (player) {
            playerLabel.hidden = NO;
            playerLabel.text = player.playerStatusString;
        } else {
            playerLabel.hidden = YES; // TODO: test this
        }
    }
    
    // update what actions you can do
    // TODO: yes, this is hardcoded rn
    NSArray<GameAction*>* actions = [self.game.players[0] currentPossibleActions:self.game];
    self.playerGameActions = actions;
    [self.actionCollectionView reloadData];
}

// delegate stuff
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.playerGameActions count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameActionCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"GameActionCollectionViewCell"
                                    forIndexPath:indexPath];
    
    [myCell setupWithGameAction:self.playerGameActions[indexPath.row]];
    
    return myCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: mycell.getgameaction seems to return nil, so i don't get cell directly
    [self.game processGameAction:self.playerGameActions[indexPath.row]];
    [self gameInstanceStateUpdate];
}

@end
