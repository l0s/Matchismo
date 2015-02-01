//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Carlos Macasaet on 20/10/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Constants.h"

@interface CardMatchingGame()

@property (nonatomic, readonly) NSUInteger playableCards;
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSArray *cards; // of Card
@property (nonatomic, readonly) Deck *deck;
@property (nonatomic, readonly) NSNotificationCenter *notificationCenter;
@property (nonatomic, strong, readonly) dispatch_queue_t cardSettingQueue;
@property (strong, nonatomic, readwrite) Move* lastMove;

@end

@implementation CardMatchingGame

static NSPredicate *chosenCardIdentifier;

+(void)initialize
{
    static BOOL initialised = NO;
    if( !initialised )
    {
        chosenCardIdentifier =
            [ NSPredicate predicateWithBlock:^BOOL(Card *otherCard, NSDictionary *bindings) {
            return otherCard.isChosen && !otherCard.isMatched;
        }];
        initialised = YES;
    }
}

- (instancetype) init
{
    return nil;
}

- (instancetype) initWithPlayableCards: (NSUInteger) playableCards
                               andDeck: (Deck *)deck
{
    return [ self initWithNotificationCenter:[ NSNotificationCenter defaultCenter ] andPlayableCards:playableCards andDeck:deck ];
}

- (instancetype) initWithNotificationCenter:(NSNotificationCenter *)notificationCenter
                           andPlayableCards:(NSUInteger)playableCards
                                    andDeck:(Deck *)deck
{
    self = [ super init ];
    if( self )
    {
        NSAssert( notificationCenter != nil, @"notificationCenter cannot be nil" );
        NSAssert( deck != nil, @"deck cannot be nil" );
        NSAssert( playableCards <= deck.numCards,
                 @"Deck %@ has fewer than %ld cards.", deck,
                 ( unsigned long )playableCards );
        _notificationCenter = notificationCenter;
        _deck = deck;
        _playableCards = playableCards;
        _cardSettingQueue =
            dispatch_queue_create( "com.macasaet.matchismo.model.CardMatchingGame.cardSettingQueue",
                                   DISPATCH_QUEUE_SERIAL );
    }
    return self;
}

- (NSArray *) cards
{
    dispatch_sync( _cardSettingQueue, ^{
        if( !_cards )
        {
            NSMutableArray* const temp =
                [ [ NSMutableArray alloc ] initWithCapacity:self.playableCards ];
            for( NSInteger i = self.playableCards; --i >= 0; )
            {
                Card *card = [ self.deck drawRandomCard ];
                NSAssert( card, @"Deck does not have enough cards." );
                [ temp addObject: card ];
            }
            _cards = [ temp copy ];
        }
    } );

    return _cards;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
    return self.cards && index < [ self.cards count ]
           ? self.cards[ index ]
           : nil;
}

- (void) chooseCardAtIndex:(NSUInteger)index
{
    Card *const card = [ self cardAtIndex:index ];
    NSLog( @"Choosing card: %@ at index %lu", card, ( unsigned long )index );
    if( !card.isMatched )
    {
        if( card.isChosen )
        {
            card.chosen = NO;
        }
        else
        {
            NSArray *const otherChosenCards =
                [ self.cards filteredArrayUsingPredicate:chosenCardIdentifier ];
            // if the player has chosen enough cards, then calculate match score
            if( otherChosenCards.count >= self.cardsToMatch - 1 )
            {
                const int matchScore = [ card match:otherChosenCards ];
                if( matchScore )
                {
                    NSLog( @"Found matches for: %@", card );
                    const int points = matchScore * MatchBonus;
                    self.score += points;
                    for( Card *other in otherChosenCards )
                    {
                        other.matched = YES;
                    }
                    card.matched = YES;
                }
                else
                {
                    NSLog( @"No matches found for: %@", card );
                    self.score -= MismatchPenalty;
                    for( Card *other in otherChosenCards )
                    {
                        other.chosen = NO;
                    }
                }
                self.lastMove =
                    [ [ Move alloc ] initWithCards:[ otherChosenCards arrayByAddingObject:card ] ];
                [ self.notificationCenter postNotificationName:MoveMadeNotification
                                                        object:self ];
            }
            card.chosen = YES;
            self.score -= FlipCost;
        }
    }
}

- (NSString *)description
{
    return [ NSString stringWithFormat:@"( CardMatchingGame: %li, %li )",
             ( long )self.playableCards,
             ( long )self.score ];
}

@end