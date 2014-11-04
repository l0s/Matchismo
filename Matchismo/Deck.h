//
//  Deck.h
//  Matchismo
//
//  Created by Carlos Macasaet on 10/17/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject
{
    @protected
    NSMutableArray *_cards; // of Card
}

@property (readonly) NSInteger numCards;
- (Card *) drawRandomCard;

@end