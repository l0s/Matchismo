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
#import "CardMatchingGame.h"

@interface ViewController ()

@property (strong, nonatomic) Deck *deck;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (nonatomic) int draws;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation ViewController

- (CardMatchingGame *) game
{
    if( !_game )
    {
        // FIXME instructions indicate to init the game w/ a separate deck
        // I don't understand
        _game =
            [ [ CardMatchingGame alloc ] initWithPlayableCards:self.cardButtons.count
                                                       andDeck:self.deck ];
    }
    return _game;
}

- (BOOL) shouldAutorotate
{
    return NO;
}

- (void) setDraws:(int)draws
{
    _draws = draws;
    self.counterLabel.text =
        [ NSString stringWithFormat:@"cards drawn: %d", draws ];
}

- (IBAction)tapCard:(UIButton *)sender forEvent:(UIEvent *)event {
    [ self.game chooseCardAtIndex:[ self.cardButtons indexOfObject:sender ] ];
    [ self updateUi ];
}

- (void) updateUi
{
    for( UIButton *button in self.cardButtons )
    {
        NSUInteger index = [ self.cardButtons indexOfObject:button ];
        Card *card = [ self.game cardAtIndex:index ];
        [ self updateButton:button ForCard:card ];
    }
    self.scoreLabel.text =
        [ NSString stringWithFormat:@"Score: %ld", self.game.score ];
}

- (void) updateButton: (UIButton *) button ForCard: (Card *) card
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
        [ button setTitle:nil forState:UIControlStateNormal ];
        [ button setTitleColor:nil
                      forState:UIControlStateNormal ];
    }
    button.enabled = !card.isMatched;
}

- (Deck *) deck
{
    if( !_deck )
    {
        _deck = [ [ PlayingCardDeck alloc ] init ];
    }
    return _deck;
}

@end
