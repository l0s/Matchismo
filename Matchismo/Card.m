//
//  Card.m
//  Matchismo
//
//  Created by Carlos Macasaet on 10/17/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (int) match:(NSArray *)cards
{
    int retval = 0;
    for( Card *card in cards )
    {
        if( [ card.value isEqualToString:self.value ] )
        {
            retval = 1;
        }
    }
    return retval;
}

@end