//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Carlos Macasaet on 20/10/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import "CardMatchingGame.h"

#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
#define FLIP_COST 1

@interface CardMatchingGame()

@property (nonatomic, readonly) NSUInteger playableCards;
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSArray *cards; // of Card
@property (nonatomic, readonly) Deck *deck;

@end

@implementation CardMatchingGame

@synthesize lastStatus = _lastStatus;

static NSPredicate *chosenCardIdentifier;

+(void)initialize
{
    static BOOL initialised = NO;
    if( !initialised )
    {
        chosenCardIdentifier =
            [ NSPredicate predicateWithBlock:^BOOL(Card *otherCard, NSDictionary *bindings) {
            return otherCard.isChosen && !otherCard.isMatched;
        }];
        initialised = YES;
    }
}

- (instancetype) init
{
    return nil;
}

- (instancetype) initWithPlayableCards: (NSUInteger) playableCards
                               andDeck: (Deck *)deck
{
    self = [ super init ];
    if( self )
    {
        NSAssert( deck != nil, @"deck cannot be nil" );
        NSAssert( playableCards <= deck.numCards,
                  @"Deck %@ has fewer than %ld cards.", deck, playableCards );
        _deck = deck;
        _playableCards = playableCards;
    }
    return self;
}

- (NSArray *) cards
{
    if( !_cards )
    {
        // FIXME should synchronise instead of using temp variable
        Deck *const deck = self.deck;
        NSMutableArray *const temp =
            [ [ NSMutableArray alloc ] initWithCapacity:self.playableCards ];
        for( NSInteger i = self.playableCards; --i >= 0; )
        {
            Card *card = [ deck drawRandomCard ];
            if( card )
            {
                [ temp addObject:card ];
            }
            else
            {
                NSLog( @"Deck %@ has fewer than %ld cards remaining.",
                      deck,
                      self.playableCards );
                return nil;
            }
        }
        _cards = [ temp copy ];
    }
    return _cards;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
    return self.cards && index < [ self.cards count ]
           ? self.cards[ index ]
           : nil;
}

- (void) chooseCardAtIndex:(NSUInteger)index
{
    Card *const card = [ self cardAtIndex:index ];
    NSLog( @"Choosing card: %@ at index %lu", card, index );
    if( !card.isMatched )
    {
        if( card.isChosen )
        {
            card.chosen = NO;
        }
        else
        {
            NSArray *const otherChosenCards =
                [ self.cards filteredArrayUsingPredicate:chosenCardIdentifier ];
            // if the player has chosen enough cards, then calculate match score
            if( otherChosenCards.count >= self.cardsToMatch - 1 )
            {
                const int matchScore = [ card match:otherChosenCards ];
                if( matchScore )
                {
                    NSLog( @"Found matches for: %@", card );
                    const int points = matchScore * MATCH_BONUS;
                    self.score += points;
                    for( Card *other in otherChosenCards )
                    {
                        other.matched = YES;
                    }
                    card.matched = YES;
                    _lastStatus =
                        [ NSString stringWithFormat:@"Matched %@ with %@ for %d points.",
                                                    card.value,
                                                    [ self displayValues:otherChosenCards ],
                                                    points ];
                }
                else
                {
                    NSLog( @"No matches found for: %@", card );
                    self.score -= MISMATCH_PENALTY;
                    for( Card *other in otherChosenCards )
                    {
                        other.chosen = NO;
                    }
                    _lastStatus =
                        [ NSString stringWithFormat:@"No match between %@ and %@; %d point penalty.",
                                                    card.value,
                                                    [ self displayValues:otherChosenCards ],
                                                    MISMATCH_PENALTY ];
                }
                [ [ NSNotificationCenter defaultCenter ] postNotificationName:@"statusUpdated" object:self ];
            }
            card.chosen = YES;
            self.score -= FLIP_COST;
        }
    }
}

- (NSString *)displayValues: ( NSArray * )cards // of Card
{
    return [ [ cards valueForKey:@"value" ] componentsJoinedByString:@" and " ];
}

- (NSString *)description
{
    return [ NSString stringWithFormat:@"( CardMatchingGame: %li, %li )",
             self.playableCards,
             self.score ];
}

@end