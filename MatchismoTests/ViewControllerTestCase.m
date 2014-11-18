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

- (void)setUp {
    [super setUp];

    self.game = OCMClassMock( [ CardMatchingGame class ] );

    self.scoreLabel = [ [ UILabel alloc ] init ];

    self.controller = [ [ ViewController alloc ] init ];
    self.controller.scoreLabel = self.scoreLabel;
    self.controller.game = self.game;
}

- (void)tearDown {
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

- (void)testNewGameClearsScore {
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


@end
