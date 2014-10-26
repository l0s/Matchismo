//
//  PlayingCard.h
//  Matchismo
//
//  Created by Carlos Macasaet on 10/17/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (readonly, strong, nonatomic) NSString *suit;
@property (readonly, nonatomic) NSString *rankString;

- (id) initWithRank:(NSUInteger) rank
            andSuit:(NSString *) suit;

+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;

@end