//
//  ViewController.m
//  Matchismo
//
//  Created by Carlos Macasaet on 10/16/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "Constants.h"

@interface ViewController ()

@property (strong, nonatomic) NSNotificationCenter* notificationCenter;
@property (strong, nonatomic) NSMutableArray* moveHistory; // of Move

@end

@implementation ViewController

@synthesize game = _game;
@synthesize notificationCenter = _notificationCenter;

- (NSNotificationCenter *)notificationCenter
{
    if( !_notificationCenter )
    {
        _notificationCenter = [ NSNotificationCenter defaultCenter ];
    }
    return _notificationCenter;
}

- (void)viewDidLoad
{
    self.statusLabel.adjustsFontSizeToFitWidth = YES;

    // TODO abstract these
    self.historySlider.value = 1.0;
    self.statusLabel.attributedText =
        [ [ NSAttributedString alloc ] initWithString:InitialStatusMessage ];
    self.moveHistory = [ [ NSMutableArray alloc ] init ];
    [ self.moveHistory addObject:[ NSNull null ] ];
    self.historySlider.enabled = NO;
}

- (void)dealloc
{
    [ self.notificationCenter removeObserver:self ];
}

- (NSUInteger) cardsToMatch
{
    return self.matchTypeSegmentedControl.selectedSegmentIndex + 2;
}

- (CardMatchingGame *) game
{
    if( !_game )
    {
        [ self setGame:[ self createGame ] ];
    }
    return _game;
}

- (void) setGame:(CardMatchingGame *)game
{
    if( _game )
    {
        [ self.notificationCenter removeObserver:self
                                            name:MoveMadeNotification
                                          object:_game ];
    }
    if( game )
    {
        [ self.notificationCenter addObserver:self
                                     selector:@selector(updateStatus:)
                                         name:MoveMadeNotification
                                       object:game ];
    }
    _game = game;
}

- (CardMatchingGame *) createGame
{
    return [ [ CardMatchingGame alloc ] initWithNotificationCenter:self.notificationCenter
                                                  andPlayableCards:self.cardButtons.count
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
    self.game.cardsToMatch = self.cardsToMatch;

    self.historySlider.value = 1.0f;
    [ self showHistoricalStatus:self.historySlider ];

    [ self updateUi ];
}

- (IBAction)startNewGame:(UIButton *)sender forEvent:(UIEvent *)event
{
    NSLog( @"Starting new game." );
    
    self.game = [ self createGame ];

    self.matchTypeSegmentedControl.enabled = YES;
    self.statusLabel.attributedText =
        [ [ NSAttributedString alloc ] initWithString:InitialStatusMessage ];
    self.historySlider.value = 1.0;
    self.moveHistory = [ [ NSMutableArray alloc ] init ];
    [ self.moveHistory addObject:[ NSNull null ] ];
    self.historySlider.enabled = NO;

    [ self updateUi ];
}

- (IBAction)showHistoricalStatus:(UISlider *)slider
{
    NSLog( @"Seeking to %f%% of the way through", slider.value * 100 );
    NSUInteger const lastMoveIndex = self.moveHistory.count - 1;
    NSUInteger const index = lroundf( slider.value * lastMoveIndex );
    NSLog( @"Seeking to state %lu", ( unsigned long )index );
    self.statusLabel.enabled = index == lastMoveIndex;
    if( index > 0 )
    {
        [ self updateStatusForMove:self.moveHistory[ index ] ];
    }
    else
    {
        self.statusLabel.attributedText =
            [ [ NSAttributedString alloc ] initWithString:InitialStatusMessage ];
    }
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
        [ NSString stringWithFormat:@"Score: %ld", ( long )self.game.score ];
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

- (void) updateStatus: ( NSNotification * const )notification
{
    Move* const lastMove =
        ( ( CardMatchingGame * )notification.object ).lastMove;
    NSAssert( lastMove, @"lastMove is nil" );
    [ self.moveHistory addObject:lastMove ];
    self.historySlider.enabled = YES;
    [ self updateStatusForMove:lastMove ];
}

- (void)updateStatusForMove:(Move *)move
{
    self.statusLabel.attributedText = [ self createStatusText:move ];
}

- (NSAttributedString *) createStatusText: (Move *)move
{
    NSString* const template =
        move.matchFound
        ? @"Match between %@ for %d points."
        : @"No match between %@; %d point penalty.";
    NSString* const statusText =
        [ NSString stringWithFormat:template,
                                    [ [ move.cards valueForKey:@"value" ] componentsJoinedByString:@" and " ],
                                    move.moveScore ];

    NSMutableAttributedString* const retval =
        [ [ NSMutableAttributedString alloc ] initWithString:statusText ];
    [ retval beginEditing ];
    for( unsigned int i = 0; i < statusText.length; i++ )
    {
        const unichar character = [ statusText characterAtIndex:i ];
        if( character == 0x2665 || character == 0x2666 )
        {
            [ retval addAttribute:NSForegroundColorAttributeName
                            value:[ UIColor redColor ]
                            range:NSMakeRange( i, 1 ) ];
        }
    }
    [ retval endEditing ];
    return retval;
}

@end