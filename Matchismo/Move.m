//
//  Move.m
//  Matchismo
//
//  Created by Carlos Macasaet on 25/1/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

#import "Move.h"
#import "Card.h"
#import "Constants.h"

@interface Move()

@property (readonly) int rawScore;

@end

@implementation Move

- (instancetype) init
{
    return nil;
}

- (instancetype) initWithCards:(NSArray *)cards
{
    self = [ super init ];
    if( self )
    {
        NSAssert( cards, @"cards must not be nil" );
        _cards = cards;
    }
    return self;
}

- (BOOL) matchFound
{
    // TODO memoise
    return self.rawScore > 0;
}

- (int) moveScore
{
    // TODO memoise
    int raw = self.rawScore;
    if( raw > 0 )
    {
        return raw * MatchBonus;
    }
    // FIXME should change sign
    return -MismatchPenalty;
}

- (int) rawScore
{
    // TODO memoise
    int maxScore = 0;
    for( NSUInteger i = 0; i < self.cards.count; i++ )
    {
        NSLog( @"Checking for matches against card %lu", ( unsigned long )i );
        Card* const card = self.cards[ i ];
        NSArray* const left =
            [ self.cards subarrayWithRange:NSMakeRange( 0, i ) ];
        NSArray* const right =
            [ self.cards subarrayWithRange:NSMakeRange( i + 1,
                                                        self.cards.count - i - 1 ) ];
        NSArray* const others = [ left arrayByAddingObjectsFromArray:right ];
        NSAssert( [ others indexOfObject:card ] == NSNotFound,
                  @"Oops, current card is in \"others\" array." );
        int candidateScore = [ card match:others ];
        if( candidateScore > maxScore )
        {
            maxScore = candidateScore;
        }
    }
    return maxScore;
}

@end