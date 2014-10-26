//
//  Deck.m
//  Matchismo
//
//  Created by Carlos Macasaet on 10/17/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (strong, readonly) NSMutableArray *cards;

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
        _cards = [ [ NSMutableArray alloc ] init ];
    }
    return _cards;
}

- (NSInteger) numCards
{
    return [ self.cards count ];
}

@end