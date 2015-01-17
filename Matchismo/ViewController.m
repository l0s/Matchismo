//
//  ViewController.m
//  Matchismo
//
//  Created by Carlos Macasaet on 10/16/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"


@interface ViewController ()

@end

@implementation ViewController

- (NSUInteger) cardsToMatch
{
    return self.matchTypeSegmentedControl.selectedSegmentIndex + 2;
}

- (CardMatchingGame *) game
{
    if( !_game )
    {
        _game = [ self createGame ];
        
    }
    return _game;
}

- (CardMatchingGame *) createGame
{
    return [ [ CardMatchingGame alloc ] initWithPlayableCards:self.cardButtons.count
                                                      andDeck:[ [ PlayingCardDeck alloc ] init ] ];
}

- (BOOL) shouldAutorotate
{
    return NO;
}

- (IBAction)tapCard:(UIButton *)sender forEvent:(UIEvent *)event
{
    NSLog( @"Tapping card button: %@", sender );
    [ self.game chooseCardAtIndex:[ self.cardButtons indexOfObject:sender ] ];
    self.matchTypeSegmentedControl.enabled = NO; // technically only need to do this the first time

    [ self updateUi ];
}

- (IBAction)startNewGame:(UIButton *)sender forEvent:(UIEvent *)event
{
    NSLog( @"Starting new game." );
    self.game = [ self createGame ];
    self.matchTypeSegmentedControl.enabled = YES;
    self.game.cardsToMatch = self.cardsToMatch;
    self.statusLabel.text = @"Good luck!";

    [ self updateUi ];
}

- (void) updateUi
{
    for( UIButton *button in self.cardButtons )
    {
        NSUInteger index = [ self.cardButtons indexOfObject:button ];
        Card *card = [ self.game cardAtIndex:index ];
        [ self updateButton:button forCard:card ];
    }
    self.scoreLabel.text =
        [ NSString stringWithFormat:@"Score: %ld", self.game.score ];
}

- (void) updateButton: (UIButton *) button forCard: (Card *) card
{
    if( card.isChosen )
    {
        // switch to front
        button.opaque = YES;
        button.backgroundColor = [ UIColor whiteColor ];
        [ button setBackgroundImage:nil forState:UIControlStateNormal ];
        [ button setTitle:card.value forState:UIControlStateNormal ];
        [ button setTitleColor:card.color == Black
                               ? [ UIColor blackColor ]
                               : [ UIColor redColor ]
                      forState:UIControlStateNormal ];

    }
    else
    {
        // switch to back
        button.opaque = NO;
        button.backgroundColor = [ UIColor clearColor ];
        [ button setBackgroundImage:[ UIImage imageNamed:@"back" ]
                           forState:UIControlStateNormal ];
        [ button setTitle:@"" forState:UIControlStateNormal ];
        [ button setTitleColor:nil
                      forState:UIControlStateNormal ];
    }
    button.enabled = !card.isMatched;
}

@end