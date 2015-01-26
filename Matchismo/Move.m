//
//  Move.m
//  Matchismo
//
//  Created by Carlos Macasaet on 25/1/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

#import "Move.h"

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

@end