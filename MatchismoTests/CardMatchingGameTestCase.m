//
//  CardMatchingGameTestCase.m
//  Matchismo
//
//  Created by Carlos Macasaet on 3/11/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (retain) NSArray *cards; // of Card

@end

@interface CardMatchingGameTestCase : XCTestCase

@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation CardMatchingGameTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    self.game = nil;

    [super tearDown];
}

- (void)testCorrectCardCount
{
    // given
    NSUInteger slotCount = 1;
    Card *card = OCMClassMock( [ Card class ] );
    Deck *deck = OCMClassMock( [ Deck class ] );
    OCMStub( [ deck numCards ] ).andReturn( 1 );
    OCMStub( [ deck drawRandomCard ] ).andReturn( card );
    self.game =
        [ [ CardMatchingGame alloc ] initWithPlayableCards:slotCount
                                                   andDeck:deck ];

    // when
    NSInteger result = self.game.score;

    // then
    XCTAssertEqual( result, 0 );
}

/*
 "In 3-card-match mode, choosing only 2 cards is never a match."
 */
- (void)testChooseTwoMatchingCardsInThreeCardMatchMode
{
    // given all cards in the game match
    Card *x = OCMPartialMock( [ [ Card alloc ] init ] );
    Card *y = OCMPartialMock( [ [ Card alloc ] init ] );
    Card *z = OCMPartialMock( [ [ Card alloc ] init ] );
    Deck *deck = OCMClassMock( [ Deck class ] );
    OCMStub( [ deck numCards ] ).andReturn( 3 );
    // note, it is not possible to mock three successive invocations of
    // [ deck drawRandomCard ]
    OCMStub( [ x match:[ OCMArg any ] ] ).andReturn( 1 );
    OCMStub( [ y match:[ OCMArg any ] ] ).andReturn( 1 );
    OCMStub( [ z match:[ OCMArg any ] ] ).andReturn( 1 );

    self.game =
        OCMPartialMock( [ [ CardMatchingGame alloc ] initWithPlayableCards:3
                                                                   andDeck:deck ] );
    self.game.cards = @[ x, y, z ];
    self.game.cardsToMatch = 3;

    // when only two cards are chosen
    [ self.game chooseCardAtIndex:0 ];
    [ self.game chooseCardAtIndex:1 ];

    // then the score should reflect two flips and no points for matching
    XCTAssertEqual( self.game.score, -2 );
    XCTAssertTrue( x.isChosen );
    XCTAssertTrue( y.isChosen );
    XCTAssertFalse( z.isChosen );
    XCTAssertFalse( x.isMatched );
    XCTAssertFalse( y.isMatched );
    XCTAssertFalse( z.isMatched );
}

- (void)testChooseThreeMatchingCardsInThreeCardMatchMode
{
    // given all cards in the game match
    Card *x = OCMPartialMock( [ [ Card alloc ] init ] );
    Card *y = OCMPartialMock( [ [ Card alloc ] init ] );
    Card *z = OCMPartialMock( [ [ Card alloc ] init ] );
    Deck *deck = OCMClassMock( [ Deck class ] );
    OCMStub( [ deck numCards ] ).andReturn( 3 );
    OCMStub( [ x match:[ OCMArg any ] ] ).andReturn( 2 );
    OCMStub( [ y match:[ OCMArg any ] ] ).andReturn( 2 );
    OCMStub( [ z match:[ OCMArg any ] ] ).andReturn( 2 );
    
    self.game =
        OCMPartialMock( [ [ CardMatchingGame alloc ] initWithPlayableCards:3
                                                                   andDeck:deck ] );
    self.game.cards = @[ x, y, z ];
    self.game.cardsToMatch = 3;

    // when all three cards are chosen
    [ self.game chooseCardAtIndex:0 ];
    [ self.game chooseCardAtIndex:1 ];
    [ self.game chooseCardAtIndex:2 ];

    // then the score should reflect three flips and 3*bonus points for matching
    XCTAssertEqual( self.game.score, 2 * 4 - 3 );
    XCTAssertTrue( x.isChosen );
    XCTAssertTrue( y.isChosen );
    XCTAssertTrue( z.isChosen );
    XCTAssertTrue( x.isMatched );
    XCTAssertTrue( y.isMatched );
    XCTAssertTrue( z.isMatched );
}

- (void)testChooseThreeNonMatchingCardsInThreeCardMatchMode
{
    // given none of cards in the game match
    Card *x = OCMPartialMock( [ [ Card alloc ] init ] );
    Card *y = OCMPartialMock( [ [ Card alloc ] init ] );
    Card *z = OCMPartialMock( [ [ Card alloc ] init ] );
    Deck *deck = OCMClassMock( [ Deck class ] );
    OCMStub( [ deck numCards ] ).andReturn( 3 );
    OCMStub( [ x match:[ OCMArg any ] ] ).andReturn( 0 );
    OCMStub( [ y match:[ OCMArg any ] ] ).andReturn( 0 );
    OCMStub( [ z match:[ OCMArg any ] ] ).andReturn( 0 );
    
    self.game =
    OCMPartialMock( [ [ CardMatchingGame alloc ] initWithPlayableCards:3
                                                               andDeck:deck ] );
    self.game.cards = @[ x, y, z ];
    self.game.cardsToMatch = 3;
    
    // when all three cards are chosen
    [ self.game chooseCardAtIndex:0 ];
    [ self.game chooseCardAtIndex:1 ];
    [ self.game chooseCardAtIndex:2 ];
    
    // then the score should reflect three flips and a mismatch penalty
    XCTAssertEqual( self.game.score, -2 - 3 );
    XCTAssertFalse( x.isChosen );
    XCTAssertFalse( y.isChosen );
    XCTAssertTrue( z.isChosen );
    XCTAssertFalse( x.isMatched );
    XCTAssertFalse( y.isMatched );
    XCTAssertFalse( z.isMatched );
}

/*
 "In 3-card-match mode, it should be possible to get some (although a
 significantly lesser amount of) points for picking 3 cards of which only 2
 match in some way. In that case, all 3 cards should be taken out of the game
 (even though only 2 match)."
 */
- (void)testChooseTwoOutOfThreeMatchingCardsInThreeCardMatchMode
{
    // given none of cards in the game match
    Card *x = OCMPartialMock( [ [ Card alloc ] init ] );
    Card *y = OCMPartialMock( [ [ Card alloc ] init ] );
    Card *z = OCMPartialMock( [ [ Card alloc ] init ] );
    Deck *deck = OCMClassMock( [ Deck class ] );
    OCMStub( [ deck numCards ] ).andReturn( 3 );
    OCMStub( [ x match:[ OCMArg any ] ] ).andReturn( 0 );
    OCMStub( [ y match:[ OCMArg any ] ] ).andReturn( 0 );
    OCMStub( [ z match:[ OCMArg any ] ] ).andReturn( 1 );
    
    self.game =
    OCMPartialMock( [ [ CardMatchingGame alloc ] initWithPlayableCards:3
                                                               andDeck:deck ] );
    self.game.cards = @[ x, y, z ];
    self.game.cardsToMatch = 3;
    
    // when all three cards are chosen
    [ self.game chooseCardAtIndex:0 ];
    [ self.game chooseCardAtIndex:1 ];
    [ self.game chooseCardAtIndex:2 ];
    
    // then the score should reflect three flips and a mismatch penalty
    XCTAssertEqual( self.game.score, 1 * 4 - 3 );
    XCTAssertTrue( x.isChosen );
    XCTAssertTrue( y.isChosen );
    XCTAssertTrue( z.isChosen );
    XCTAssertTrue( x.isMatched );
    XCTAssertTrue( y.isMatched );
    XCTAssertTrue( z.isMatched );
}

@end