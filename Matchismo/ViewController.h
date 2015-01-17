//
//  ViewController.h
//  Matchismo
//
//  Created by Carlos Macasaet on 10/16/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchTypeSegmentedControl;

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic, readonly) NSUInteger cardsToMatch;

- (IBAction)tapCard:(UIButton *)sender forEvent:(UIEvent *)event;

- (IBAction)startNewGame:(UIButton *)sender forEvent:(UIEvent *)event;

@end