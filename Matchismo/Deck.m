//
//  Deck.m
//  Matchismo
//
//  Created by Carlos Macasaet on 10/17/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (strong, readwrite) NSMutableArray *cards; // of Card

@end

@implementation Deck

@synthesize cards = _cards;

- (Card *) drawRandomCard
{
    NSUInteger count = self.numCards;
    if( count )
    {
        NSMutableArray *cards = self.cards;
        unsigned index = arc4random() % count;
        Card *retval = cards[ index ];
        [ cards removeObjectAtIndex:index ];
        return retval;
        
    }
    return nil;
}

- (NSMutableArray *) cards
{
    if( !_cards )
    {
        [ self setCards:[ [ NSMutableArray alloc ] init ] ];
    }
    return _cards;
}

- (void)setCards:(NSMutableArray *)cards
{
    NSAssert( cards != nil, @"cards cannot be nil" );
    _cards = cards;
}

- (NSInteger) numCards
{
    return [ self.cards count ];
}

- (NSString *) description
{
    return [ NSString stringWithFormat:@"( Deck: %li )", (long)self.numCards ];
}

@end