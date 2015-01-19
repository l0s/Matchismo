//
//  CardTestCase.m
//  Matchismo
//
//  Created by Carlos Macasaet on 26/10/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "Card.h"

@interface Card()

@property (readwrite) NSString *value;

- (void)setValue:(NSString *)value;

@end

@interface CardTestCase : XCTestCase

@property (nonatomic, strong) Card *card;

@end

@implementation CardTestCase

- (void) setUp {
    [super setUp];

    self.card = OCMPartialMock( [ [ Card alloc ] init ] );
}

- (void) tearDown {
    self.card = nil;

    [ super tearDown ];
}

- (void) testNoMatchAgainstEmptyArray
{
    // given
    OCMStub( [ self.card value ] ).andReturn( @"x" );
    NSArray *others = @[];

    // when
    int result = [ self.card match:others ];

    // then
    XCTAssertEqual( result, 0 );
}

- (void) testNoMatchAgainstSingleton
{
    // given
    OCMStub( [ self.card value ] ).andReturn( @"x" );
    Card *other = OCMPartialMock( [ [ Card alloc ] init ] );
    OCMStub( [ other value ] ).andReturn( @"y" );
    NSArray *others = @[ other ];

    // when
    int result = [ self.card match:others ];
    
    // then
    XCTAssertEqual( result, 0 );
}

- (void) testMatchAgainstSingleton
{
    // given
    OCMStub( [ self.card value ] ).andReturn( @"x" );
    Card *other = OCMPartialMock( [ [ Card alloc ] init ] );
    OCMStub( [ other value ] ).andReturn( @"x" );
    NSArray *others = @[ other ];
    
    // when
    int result = [ self.card match:others ];
    
    // then
    XCTAssertEqual( result, 1 );
}

- (void) testNoMatchAgainstMultiple
{
    // given
    OCMStub( [ self.card value ] ).andReturn( @"value" );
    Card *x = OCMPartialMock( [ [ Card alloc ] init ] );
    OCMStub( [ x value ] ).andReturn( @"x" );
    Card *y = OCMPartialMock( [ [ Card alloc ] init ] );
    OCMStub( [ y value ] ).andReturn( @"y" );
    NSArray *others = @[ x, y ];

    // when
    int result = [ self.card match:others ];
    
    // then
    XCTAssertEqual( result, 0 );
}

- (void) testMatchAgainstAny
{
    // given
    OCMStub( [ self.card value ] ).andReturn( @"value" );
    Card *x = OCMPartialMock( [ [ Card alloc ] init ] );
    OCMStub( [ x value ] ).andReturn( @"x" );
    Card *y = OCMPartialMock( [ [ Card alloc ] init ] );
    OCMStub( [ y value ] ).andReturn( @"value" );
    NSArray *others = @[ x, y ];
    
    // when
    int result = [ self.card match:others ];
    
    // then
    XCTAssertEqual( result, 1 );
}

- (void) testMatchAgainstAll
{
    // given
    OCMStub( [ self.card value ] ).andReturn( @"value" );
    Card *x = OCMPartialMock( [ [ Card alloc ] init ] );
    OCMStub( [ x value ] ).andReturn( @"x" );
    Card *y = OCMPartialMock( [ [ Card alloc ] init ] );
    OCMStub( [ y value ] ).andReturn( @"value" );
    NSArray *others = @[ x, y ];
    
    // when
    int result = [ self.card match:others ];
    
    // then
    XCTAssertEqual( result, 1 );
}

@end