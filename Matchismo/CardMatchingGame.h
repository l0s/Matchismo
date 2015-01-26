//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Carlos Macasaet on 20/10/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Move.h"

@interface CardMatchingGame : NSObject

// designated initialisers
- (instancetype) initWithPlayableCards: (NSUInteger)playableCards
                               andDeck: (Deck *) deck;
- (instancetype) initWithNotificationCenter: (NSNotificationCenter *) notificationCenter
                           andPlayableCards: (NSUInteger)playableCards
                                    andDeck: (Deck *)deck;

- (void) chooseCardAtIndex: (NSUInteger) index;
- (Card *) cardAtIndex: (NSUInteger) index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger cardsToMatch;

// FIXME this should be a struct with cards, boolean, and points
@property (strong, nonatomic, readonly) NSString* lastStatus;
@property (strong, nonatomic, readonly) Move* lastMove;

@end