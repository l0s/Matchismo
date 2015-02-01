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
{
    BOOL calculatedRawScore;
    dispatch_queue_t rawScoreQueue;
}

@synthesize rawScore = _rawScore;

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

        rawScoreQueue =
            dispatch_queue_create( "com.macasaet.ios.cs193p.Matchismo.Model.Move.rawScoreQueue",
                                   DISPATCH_QUEUE_SERIAL );
        calculatedRawScore = NO;
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
    return raw > 0 ? raw * MatchBonus : MismatchPenalty;
}

- (NSString *)description
{
    return [ NSString stringWithFormat:@"( move: %d, %d, %@ )",
                                       self.matchFound,
                                       self.moveScore,
                                       self.cards ];
}

- (int) rawScore
{
    dispatch_sync( rawScoreQueue, ^{
        if( !calculatedRawScore )
        {
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
            _rawScore = maxScore;
            calculatedRawScore = YES;
        }
    } );
    return _rawScore;
}

@end