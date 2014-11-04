//
//  DeckTestCase.m
//  Matchismo
//
//  Created by Carlos Macasaet on 28/10/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Deck.h"
#import "Card.h"

@interface TestDeck : Deck

@property (strong, readwrite, nonatomic) NSMutableArray *cards; // of Card

@end

@implementation TestDeck

@synthesize cards;

//- (NSMutableArray *) cards
//{
//    return self->_cards;
//}
//
//- (void) setCards:(NSMutableArray *)cards
//{
//    self->_cards = cards;
//}

@end

@interface DeckTestCase : XCTestCase

@property (nonatomic) TestDeck *deck;

@end

@implementation DeckTestCase

- (void)setUp {
    [super setUp];

    self.deck = [ [ TestDeck alloc ] init ];
}

- (void)tearDown {
    self.deck = nil;

    [super tearDown];
}

- (void)testDrawSingleCard
{
    // given
    Card *expected = [ [ Card alloc ] init ];

    self.deck.cards = [ [ NSMutableArray alloc ] initWithArray:@[ expected ] ];

    XCTAssertEqual( self.deck.numCards, 1 );

    // when
    Card *result = [ self.deck drawRandomCard ];

    // then
    XCTAssertEqual( self.deck.numCards, 0 );
    XCTAssertEqual( result, expected );
}

- (void)testDrawMultipleCards
{
    // given
    Card *x = [ [ Card alloc ] init ];
    Card *y = [ [ Card alloc ] init ];
    Card *z = [ [ Card alloc ] init ];

    self.deck.cards = [ [ NSMutableArray alloc ] initWithArray:@[ x, y, z ] ];

    XCTAssertEqual( self.deck.numCards, 3 );

    // when
    Card *first = [ self.deck drawRandomCard ];
    Card *second = [ self.deck drawRandomCard ];
    Card *third = [ self.deck drawRandomCard ];
    Card *fourth = [ self.deck drawRandomCard ];

    // then
    XCTAssertEqual( self.deck.numCards, 0 );
    XCTAssertNotNil( first );
    XCTAssertNotNil( second );
    XCTAssertNotNil( third );
    XCTAssertNil( fourth );
}

@end