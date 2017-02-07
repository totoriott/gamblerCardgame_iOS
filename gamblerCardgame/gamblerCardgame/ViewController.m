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
#import "SavedDataManager.h"

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

- (IBAction)pressedSave:(id)sender {
    [[[SavedDataManager alloc] init] saveGame:self.game.gameLog toSlot:0];
}

- (IBAction)pressedLoad:(id)sender {
    self.game = [[GameInstance alloc] init];
    self.game.delegate = self;
    [self.game initGameFromSaveSlot:0];
}

- (IBAction)pressedReset:(id)sender {
    // Testing point for text-based app
    self.game = [[GameInstance alloc] init];
    self.game.delegate = self;
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
    GameAction* action = [[GameAction alloc] init];
    action.playerId = 0;
    action.turnState = self.game.turnState;
    action.choice1 = luckValue;
    [self.game processGameAction:action];
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
}

- (IBAction)pressedEndAction:(UIButton *)sender {
    // TODO: confirm valid
    
    GameAction* action = [[GameAction alloc] init];
    action.playerId = 0;
    action.turnState = TURN_STATE_SELECT_POST_GAMBLE_ACTION;
    action.choice1 = ENDTURN_SUPER;
    action.choice2 = 1;
    [self.game processGameAction:action];
}

- (void)gameInstanceWasUpdated {
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
}

@end
