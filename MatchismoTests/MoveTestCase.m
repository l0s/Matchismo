//
//  MoveTestCase.m
//  Matchismo
//
//  Created by Carlos Macasaet on 25/1/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "Move.h"
#import "Card.h"

@interface MoveTestCase : XCTestCase

@property (strong, nonatomic) Move* move;

@end

@implementation MoveTestCase

- (void)setUp {
    [ super setUp ];
}

- (void)tearDown {
    self.move = nil;

    [ super tearDown ];
}

- (void)testMatchFound {
    // given
    Card* const x = OCMClassMock( [ Card class ] );
    Card* const y = OCMClassMock( [ Card class ] );

    OCMStub( [ x match:@[ y ] ] ).andReturn( 13 );
    OCMStub( [ y match:@[ x ] ] ).andReturn( 13 );

    // when
    self.move = [ [ Move alloc ] initWithCards:@[ x, y ] ];

    // then
    XCTAssertTrue( self.move.matchFound );
}

- (void)testMatchNotFound {
    // given
    Card* const x = OCMClassMock( [ Card class ] );
    Card* const y = OCMClassMock( [ Card class ] );

    OCMStub( [ x match:@[ y ] ] ).andReturn( 0 );
    OCMStub( [ y match:@[ x ] ] ).andReturn( 0 );

    // when
    self.move = [ [ Move alloc ] initWithCards:@[ x, y ] ];

    // then
    XCTAssertFalse( self.move.matchFound );
}

- (void)testMatchScoreCalculated
{
    // given
    Card* const x = OCMClassMock( [ Card class ] );
    Card* const y = OCMClassMock( [ Card class ] );

    OCMStub( [ x match:@[ y ] ] ).andReturn( 13 );
    OCMStub( [ y match:@[ x ] ] ).andReturn( 13 );

    // when
    self.move = [ [ Move alloc ] initWithCards:@[ x, y ] ];

    // then
    XCTAssertTrue( self.move.moveScore > 0 );
}

- (void)testMisMatchScoreCalculated
{
    // given
    Card* const x = OCMClassMock( [ Card class ] );
    Card* const y = OCMClassMock( [ Card class ] );
    
    OCMStub( [ x match:@[ y ] ] ).andReturn( 0 );
    OCMStub( [ y match:@[ x ] ] ).andReturn( 0 );
    
    // when
    self.move = [ [ Move alloc ] initWithCards:@[ x, y ] ];
    
    // then
    XCTAssertTrue( self.move.moveScore <= 0 );
}

@end