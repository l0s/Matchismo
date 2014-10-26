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

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readonly) Deck *deck;

@end

@implementation CardMatchingGame

- (instancetype) initWithPlayableCards: (NSUInteger) playableCards
                               andDeck: (Deck *)deck
{
    self = [ super init ];
    if( self )
    {
        NSAssert(deck != nil, @"deck cannot be nil");
        _deck = deck;
    }
    return self;
}

- (NSMutableArray *) cards
{
    if( !_cards )
    {
        // FIXME should synchronise instead of use temp variable
        Deck *deck = self.deck;
        NSInteger numCards = deck.numCards;
        NSMutableArray *temp =
            [ [ NSMutableArray alloc ] initWithCapacity:numCards ];
        for( NSInteger i = numCards; --i >= 0; )
        {
            Card *card = [ deck drawRandomCard ];
            if( card )
            {
                [ temp addObject:card ];
            }
            else
            {
                NSLog( @"Deck %@ had fewer cards than it claimed to have (%ld).",
                      deck,
                      numCards );
                return nil;
            }
        }
        _cards = temp;
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
    Card *card = [ self cardAtIndex:index ];
    if( !card.isMatched )
    {
        if( card.isChosen )
        {
            card.chosen = NO;
        }
        else
        {
            // match against other chosen cards
            for( Card *other in self.cards )
            {
                if( other.isChosen && !other.isMatched )
                {
                    int matchScore = [ card match:@[ other ] ];
                    if( matchScore )
                    {
                        self.score += matchScore * MATCH_BONUS;
                        other.matched = YES;
                        card.matched = YES;
                    }
                    else
                    {
                        self.score -= MISMATCH_PENALTY;
                    }
                    break; // can only choose two cards for now
                }
            }
            card.chosen = YES;
        }
    }
}

@end