//
//  ViewControllerTestCase.m
//  Matchismo
//
//  Created by Carlos Macasaet on 16/11/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "ViewController.h"
#import "CardMatchingGame.h"

@interface ViewControllerTestCase : XCTestCase

// mocks
@property (strong, nonatomic) CardMatchingGame *game;

// actual implementations
@property (strong, nonatomic) UILabel *scoreLabel;

@property (strong, nonatomic) ViewController *controller;

@end

@implementation ViewControllerTestCase

- (void)setUp
{
    [super setUp];

    self.game = OCMClassMock( [ CardMatchingGame class ] );

    self.scoreLabel = [ [ UILabel alloc ] init ];

    self.controller = [ [ ViewController alloc ] init ];
    self.controller.scoreLabel = self.scoreLabel;
    self.controller.game = self.game;
    self.controller.matchTypeSegmentedControl = OCMPartialMock( [ [ UISegmentedControl alloc ] init  ] );
}

- (void)tearDown
{
    self.controller = nil;

    [super tearDown];
}

- (void)testMatchTwo
{
    // given
    self.controller.matchTypeSegmentedControl =
        OCMClassMock( [ UISegmentedControl class ] );
    OCMStub( [ self.controller.matchTypeSegmentedControl selectedSegmentIndex ] ).andReturn( 0 );

    // when
    NSUInteger result = self.controller.cardsToMatch;

    // then
    XCTAssertEqual( result, 2 );
}

- (void)testMatchThree
{
    // given
    self.controller.matchTypeSegmentedControl =
        OCMClassMock( [ UISegmentedControl class ] );
    OCMStub( [ self.controller.matchTypeSegmentedControl selectedSegmentIndex ] ).andReturn( 1 );
    
    // when
    NSUInteger result = self.controller.cardsToMatch;
    
    // then
    XCTAssertEqual( result, 3 );
}

- (void)testNewGameClearsScore
{
    // given
    UIButton *button = OCMClassMock( [ UIButton class ] );
    UIEvent *event = OCMClassMock( [ UIEvent class ] );

    OCMStub( [ self.game score ] ).andReturn( 512 );
    self.controller.scoreLabel.text =
        [ NSString stringWithFormat:@"Score: %ld", self.game.score ];

    // when
    [ self.controller startNewGame:button forEvent:event ];

    // then
    XCTAssertEqualObjects( self.controller.scoreLabel.text, @"Score: 0" );
}

- (void)testNewGameFlipsCardsOver
{
    // given
    UIButton *buttonX = OCMClassMock( [ UIButton class ] );
    UIButton *buttonY = OCMClassMock( [ UIButton class ] );
    UIButton *newGameButton = OCMClassMock( [ UIButton class ] );
    UIEvent *event = OCMClassMock( [ UIEvent class ] );
    Card * card = OCMClassMock( [ Card class ] );

    OCMStub( [ self.game cardAtIndex:0 ]).andReturn( card ); // cannot match "any int"
    OCMStub( [ self.game cardAtIndex:1 ]).andReturn( card );

    self.controller.cardButtons = @[ buttonX, buttonY ];

    // when
    [ self.controller startNewGame:newGameButton forEvent:event ];

    // then
    OCMVerify( [ buttonX setTitle:@""
                         forState:UIControlStateNormal ] );
    OCMVerify( [ buttonY setTitle:@""
                         forState:UIControlStateNormal ] );
}

- (void)testTappingCardTurnsItFaceUp
{
    // given
    UIButton* const button = OCMPartialMock( [ [ UIButton alloc ] init ] );
    self.controller.cardButtons = @[ button ];

    Card* const card = OCMPartialMock( [ [ Card alloc ] init ] );
    OCMStub( [ self.game cardAtIndex:0 ] ).andReturn( card );
    OCMStub( [ self.game chooseCardAtIndex:0 ] ).andDo(
        ^( NSInvocation *invocation )
        {
            card.chosen = YES;
        }
    );

    // when
    [ self.controller tapCard:button forEvent:nil ];

    // then
    OCMVerify( [ self.game chooseCardAtIndex:0 ] );
    XCTAssertTrue( card.isChosen );
    XCTAssertTrue( button.opaque );
    XCTAssertNil( [ button backgroundImageForState:UIControlStateNormal ] );
    XCTAssertTrue( button.enabled );
}

- (void)testTappingCardTurnsItFaceDown
{
    // given
    UIButton* const button = OCMPartialMock( [ [ UIButton alloc ] init ] );
    button.opaque = YES;
    [ button setBackgroundImage:nil
                       forState:UIControlStateNormal ];
    self.controller.cardButtons = @[ button ];

    Card* const card = OCMPartialMock( [ [ Card alloc ] init ] );
    card.chosen = YES;
    OCMStub( [ self.game cardAtIndex:0 ] ).andReturn( card );
    OCMStub( [ self.game chooseCardAtIndex:0 ] ).andDo(
        ^( NSInvocation *invocation )
        {
           card.chosen = NO;
        }
    );

    // when
    [ self.controller tapCard:button forEvent:nil ];

    // then
    OCMVerify( [ self.game chooseCardAtIndex:0 ] );
    XCTAssertFalse( card.isChosen );
    XCTAssertFalse( button.opaque );
    XCTAssertNotNil( [ button backgroundImageForState:UIControlStateNormal ] );
    XCTAssertTrue( button.enabled );
}

/* Required Task 4:
   Disable the game play mode control (i.e. the UISwitch or UISegmentedControl
   from Required Task 3) when a game starts (i.e. when the first flip of a game
   happens) */
- (void)testCannotChangeModeOnceGameStarts
{
    // given
    UIButton* const firstCard = OCMPartialMock( [ [ UIButton alloc ] init ] );
    self.controller.cardButtons = @[ firstCard ];

    // when
    [ self.controller startNewGame:nil forEvent:nil ];
    [ self.controller tapCard:firstCard forEvent:nil ];

    // then
    XCTAssertFalse( self.controller.matchTypeSegmentedControl.enabled );
}

/* Required Task 4:
 Disable the game play mode control (i.e. the UISwitch or UISegmentedControl
 from Required Task 3) when a game starts (i.e. when the first flip of a game
 happens) and re-enable it when a re-deal happens (i.e. the Deal button is
 pressed). */
- (void)testCanChangeModeBeforeNewGameStarts
{
    // given
    self.controller.matchTypeSegmentedControl.enabled = NO;

    // when
    [ self.controller startNewGame:nil forEvent:nil ];

    // then
    XCTAssertTrue( self.controller.matchTypeSegmentedControl.enabled );
}

@end