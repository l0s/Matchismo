//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Carlos Macasaet on 10/17/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (NSMutableArray *) cards
{
    if( !_cards )
    {
        NSArray *validSuits = [ PlayingCard validSuits ];
        unsigned long maxRank = [ PlayingCard maxRank ];
        unsigned long numSuits = validSuits.count;
        _cards = [ [ NSMutableArray alloc ] initWithCapacity:maxRank * numSuits ];
        for( NSString *suit in validSuits )
        {
            for( int rank = 1;
                 rank <= maxRank;
                 [ _cards addObject:[ [ PlayingCard alloc ] initWithRank:rank++
                                                                 andSuit:suit ] ] );
        }
    }
    return _cards;
}

@end