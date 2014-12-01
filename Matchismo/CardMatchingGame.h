//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Carlos Macasaet on 20/10/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initialiser
- (instancetype) initWithPlayableCards: (NSUInteger)playableCards
                               andDeck: (Deck *) deck;
- (void) chooseCardAtIndex: (NSUInteger) index;
- (Card *) cardAtIndex: (NSUInteger) index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger cardsToMatch;

@end