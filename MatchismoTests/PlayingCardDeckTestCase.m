//
//  PlayingCardDeckTestCase.m
//  Matchismo
//
//  Created by Carlos Macasaet on 3/11/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "PlayingCardDeck.h"

@interface PlayingCardDeck()

// expose "cards" for testing purposes
@property (strong, readonly, nonatomic) NSMutableArray *cards; // of Card

@end

@interface PlayingCardDeckTestCase : XCTestCase

@property (strong, nonatomic) PlayingCardDeck *deck;

@end

@implementation PlayingCardDeckTestCase

- (void)setUp {
    [super setUp];

    self.deck = OCMPartialMock( [ [ PlayingCardDeck alloc ] init ] );
}

- (void)tearDown {
    self.deck = nil;

    [super tearDown];
}

- (void)testCardsLazilyInstantiated {
    // given
    // when
    NSMutableArray *result = self.deck.cards;

    // then
    XCTAssertNotNil(result);
}

- (void)testDeckSize
{
    // given
    // when
    NSMutableArray *result = self.deck.cards;

    // then
    XCTAssertEqual( result.count, 52 );
}

@end