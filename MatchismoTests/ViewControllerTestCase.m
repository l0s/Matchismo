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

@interface ViewController()

@property (strong, nonatomic) NSNotificationCenter* notificationCenter;
// TODO can we use an injected Notification Center to avoid revealing this method?
- (void) updateStatus: ( NSNotification * const )notification;
- (NSAttributedString *) createStatusText: (Move *)move;

@end

@interface ViewControllerTestCase : XCTestCase

// mocks
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

// actual implementations
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UISlider *historySlider;

@property (strong, nonatomic) ViewController *controller;

@end

@implementation ViewControllerTestCase

- (void)setUp
{
    [super setUp];

    self.game = OCMClassMock( [ CardMatchingGame class ] );
    self.notificationCenter = OCMClassMock( [ NSNotificationCenter class ] );

    self.scoreLabel = [ [ UILabel alloc ] init ];
    self.statusLabel = [ [ UILabel alloc ] init ];
    self.historySlider = [ [ UISlider alloc ] init ];

    self.controller = [ [ ViewController alloc ] init ];
    self.controller.notificationCenter = self.notificationCenter;
    self.controller.scoreLabel = self.scoreLabel;
    self.controller.statusLabel = self.statusLabel;
    self.controller.game = self.game;
    self.controller.matchTypeSegmentedControl =
        OCMPartialMock( [ [ UISegmentedControl alloc ] init  ] );
    self.controller.historySlider = self.historySlider;

    [ self.controller viewDidLoad ];
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
        [ NSString stringWithFormat:@"Score: %ld", ( long )self.game.score ];

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

- (void)testUpdateStatus
{
    // given
    Move* const move = OCMClassMock( [ Move class ] );
    OCMStub( [ self.game lastMove ] ).andReturn( move );
    NSNotification* const notification =
        OCMClassMock( [ NSNotification class ] );
    OCMStub( [ notification object ] ).andReturn( self.game );

    [ self.controller startNewGame:nil forEvent:nil ];
    NSString* const initialStatus =
        self.controller.statusLabel.attributedText.string;

    // when
    [ self.controller updateStatus:notification ];

    // then
    // TODO define business logic for status
    XCTAssertNotEqualObjects( self.controller.statusLabel.attributedText.string,
                              initialStatus );
}

- (void)testShowHistoricalStatusRewindsToBeginning
{
    // given
    Move* const firstMove = OCMClassMock( [ Move class ] );
    OCMStub( [ firstMove matchFound ] ).andReturn( YES );
    OCMStub( [ firstMove moveScore ] ).andReturn( 17 );
    Move* const lastMove = OCMClassMock( [ Move class ] );
    OCMStub( [ lastMove matchFound ] ).andReturn( NO );
    OCMStub( [ lastMove moveScore ] ).andReturn( 13 );

    // this is overly verbose because the mocking framework does not support
    // multiple invocations that return different values. Ideally we would want
    // OCMStub( [ self.game lastMove ] ).andReturn( firstMove ).andReturn( lastMove )
    CardMatchingGame* const firstGameState = OCMClassMock( [ CardMatchingGame class ] );
    OCMStub( [ firstGameState lastMove ] ).andReturn( firstMove );
    CardMatchingGame* const lastGameState = OCMClassMock( [ CardMatchingGame class ] );
    OCMStub( [ lastGameState lastMove ] ).andReturn( lastMove );

    NSNotification* const firstNotification =
        [ NSNotification notificationWithName:@"notification" object:firstGameState ];
    NSNotification* const lastNotification =
        [ NSNotification notificationWithName:@"notification" object:lastGameState ];

    [ self.controller updateStatus:firstNotification ];
    [ self.controller updateStatus:lastNotification ];

    UISlider* const slider = OCMClassMock( [ UISlider class ] );
    OCMStub( [ slider value ] ).andReturn( 0.0 );

    // when
    [ self.controller showHistoricalStatus:slider ];

    // then
    XCTAssertEqualObjects( self.controller.statusLabel.attributedText.string,
                           @"Good luck!" ); // FIXME constant!
}

- (void)testShowHistoricalStatusRewindsToFirstThird
{
    // given
    Move* const firstMove = OCMClassMock( [ Move class ] );
    OCMStub( [ firstMove matchFound ] ).andReturn( YES );
    OCMStub( [ firstMove moveScore ] ).andReturn( 17 );
    Move* const secondMove = OCMClassMock( [ Move class ] );
    OCMStub( [ secondMove matchFound ] ).andReturn( NO );
    OCMStub( [ secondMove moveScore ] ).andReturn( 11 );
    Move* const lastMove = OCMClassMock( [ Move class ] );
    OCMStub( [ lastMove matchFound ] ).andReturn( YES );
    OCMStub( [ lastMove moveScore ] ).andReturn( 13 );

    CardMatchingGame* const firstGameState = OCMClassMock( [ CardMatchingGame class ] );
    OCMStub( [ firstGameState lastMove ] ).andReturn( firstMove );
    CardMatchingGame* const secondGameState = OCMClassMock( [ CardMatchingGame class ] );
    OCMStub( [ secondGameState lastMove ] ).andReturn( secondMove );
    CardMatchingGame* const lastGameState = OCMClassMock( [ CardMatchingGame class ] );
    OCMStub( [ lastGameState lastMove ] ).andReturn( lastMove );

    NSNotification* const firstNotification =
        [ NSNotification notificationWithName:@"notification" object:firstGameState ];
    NSNotification* const secondNotification =
        [ NSNotification notificationWithName:@"notification" object:secondGameState ];
    NSNotification* const lastNotification =
        [ NSNotification notificationWithName:@"notification" object:lastGameState ];
    
    [ self.controller updateStatus:firstNotification ];
    [ self.controller updateStatus:secondNotification ];
    [ self.controller updateStatus:lastNotification ];

    UISlider* const slider = OCMClassMock( [ UISlider class ] );
    OCMStub( [ slider value ] ).andReturn( 1.0f / 3 );

    // when
    [ self.controller showHistoricalStatus:slider ];

    // then
    XCTAssertEqualObjects( self.controller.statusLabel.attributedText,
                          [ self.controller createStatusText:firstMove ] );
}

- (void)testNewGameResetsSlider
{
    // given
    self.controller.historySlider.value = 0.25;

    // when
    [ self.controller startNewGame:nil forEvent:nil ];

    // then
    XCTAssertEqual( self.controller.historySlider.value, 1.0 );
}

- (void)testTapCardResetsSlider
{
    // given
    Move* const firstMove = OCMClassMock( [ Move class ] );
    OCMStub( [ firstMove matchFound ] ).andReturn( YES );
    OCMStub( [ firstMove moveScore ] ).andReturn( 17 );
    Move* const lastMove = OCMClassMock( [ Move class ] );
    OCMStub( [ lastMove matchFound ] ).andReturn( NO );
    OCMStub( [ lastMove moveScore ] ).andReturn( 13 );

    CardMatchingGame* const firstGameState = OCMClassMock( [ CardMatchingGame class ] );
    OCMStub( [ firstGameState lastMove ] ).andReturn( firstMove );
    CardMatchingGame* const lastGameState = OCMClassMock( [ CardMatchingGame class ] );
    OCMStub( [ lastGameState lastMove ] ).andReturn( lastMove );

    NSNotification* const firstNotification =
        [ NSNotification notificationWithName:@"notification" object:firstGameState ];
    NSNotification* const lastNotification =
        [ NSNotification notificationWithName:@"notification" object:lastGameState ];
    
    [ self.controller updateStatus:firstNotification ];
    [ self.controller updateStatus:lastNotification ];

    self.controller.historySlider.value = 0.5;
    self.controller.statusLabel.attributedText =
        [ [ NSAttributedString alloc ] initWithString:@"historical status" ];
    self.controller.statusLabel.enabled = NO;

    // when
    [ self.controller tapCard:nil forEvent:nil ];

    // then
    XCTAssertTrue( self.controller.statusLabel.enabled );
    XCTAssertEqual( self.controller.historySlider.value, 1.0 );
}

@end