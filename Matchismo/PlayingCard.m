//
//  PlayingCard.m
//  Matchismo
//
//  Created by Carlos Macasaet on 10/17/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import "PlayingCard.h"
#import "Card.h"

@interface PlayingCard()

@property (readonly, nonatomic) NSUInteger rank;

@end

@implementation PlayingCard

@synthesize rank = _rank;
@synthesize suit = _suit;


- (id) initWithRank:(NSUInteger) rank
            andSuit:(NSString *) suit
{
    self = [ super init ];
    if( self )
    {
        NSAssert1( [ [ PlayingCard validSuits ] containsObject:suit ],
                   @"Invalid suit: %@",
                  suit );
        NSAssert1( rank >= 1 && rank <= [ PlayingCard maxRank ],
                  @"Invalid rank: %lu",
                  (unsigned long)rank );

        _rank = rank;
        _suit = suit;
    }
    return self;
}

- (NSString *) value
{
    return [ NSString stringWithFormat:@"%@%@", self.rankString, self.suit ];
}

- (NSString *) rankString
{
    return [ PlayingCard rankStrings ][ self.rank - 1 ];
}

- (TextColor) color
{
    return [ @[ @"♠︎", @"♣︎" ] containsObject:self.suit ] ? Black : Red;
}

- (int) match:(NSArray *)cards
{
    int retval = 0;
    // TODO match multiple cards
    if( [ cards count ] == 1 )
    {
        PlayingCard *other = [ cards firstObject ];
        if( other.rank == self.rank )
        {
            retval = 4;
        }
        else if( [ other.suit isEqualToString: self.suit ] )
        {
            retval = 1;
        }
    }
    return retval;
}

+ (NSArray *) validSuits
{
    return @[ @"♠︎", @"♦︎", @"♣︎", @"♥︎" ];
}

+ (NSUInteger) maxRank
{
    return 13;
}

+ (NSArray *) rankStrings
{
    return @[ @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J",
              @"Q", @"K" ];
}

@end