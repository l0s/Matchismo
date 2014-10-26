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
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int draws;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

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
    if( sender.currentTitle.length )
    {
        // switch to back
        [ sender setBackgroundImage:[ UIImage imageNamed:@"back" ]
                           forState:UIControlStateNormal ];
        sender.opaque = NO;
        sender.backgroundColor = [ UIColor clearColor ];
        [ sender setTitle:nil forState:UIControlStateNormal ];
        self.flipCount++;
    }
    else
    {
        Card *card = [ self.deck drawRandomCard ];
        if( card )
        {
            // switch to front
            [ sender setBackgroundImage:nil
                               forState:UIControlStateNormal ];
            sender.opaque = YES;
            sender.backgroundColor = [ UIColor whiteColor ];
            [ sender setTitleColor:[ card color ] == Black
                                   ? [ UIColor blackColor ]
                                   : [ UIColor redColor ]
                          forState:UIControlStateNormal ];
            [ sender setTitle:card.value
                     forState:UIControlStateNormal ];
            self.draws++;
            self.flipCount++;
        }
    }
}

- (IBAction)shuffle:(id)sender {
    self.deck = [ [ PlayingCardDeck alloc ] init ];
    self.draws = 0;
}

- (Deck *) deck
{
    if( !_deck )
    {
        _deck = [ [ PlayingCardDeck alloc ] init ];
    }
    return _deck;
}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text =
        [ NSString stringWithFormat:@"Flips: %d", flipCount ];
}

@end
