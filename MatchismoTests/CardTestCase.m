//
//  CardTestCase.m
//  Matchismo
//
//  Created by Carlos Macasaet on 26/10/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Card.h"

@interface TestCard : Card

@property (strong, readwrite, nonatomic) NSString *value;

- (void) setValue:(NSString *)value;

@end

@implementation TestCard

@synthesize value = _value;

@end

@interface CardTestCase : XCTestCase

@property (nonatomic, strong) TestCard *card;

@end

@implementation CardTestCase

- (void) setUp {
    [super setUp];

    self.card = [ [ TestCard alloc ] init ];
}

- (void) tearDown {
    [ super tearDown ];
}

- (void) testNoMatchAgainstEmptyArray
{
    // given
    self.card.value = @"x";
    NSArray *others = @[];

    // when
    int result = [ self.card match:others ];

    // then
    XCTAssertEqual( result, 0 );
}

- (void) testNoMatchAgainstSingleton
{
    // given
    self.card.value = @"x";
    TestCard *other = [ [ TestCard alloc ] init ];
    other.value = @"y";
    NSArray *others = @[ other ];

    // when
    int result = [ self.card match:others ];
    
    // then
    XCTAssertEqual( result, 0 );
}

- (void) testMatchAgainstSingleton
{
    // given
    self.card.value = @"x";
    TestCard *other = [ [ TestCard alloc ] init ];
    other.value = @"x";
    NSArray *others = @[ other ];
    
    // when
    int result = [ self.card match:others ];
    
    // then
    XCTAssertEqual( result, 1 );
}

- (void) testNoMatchAgainstMultiple
{
    // given
    self.card.value = @"value";
    TestCard *x = [ [ TestCard alloc ] init ];
    x.value = @"x";
    TestCard *y = [ [ TestCard alloc ] init ];
    y.value = @"y";
    NSArray *others = @[ x, y ];

    // when
    int result = [ self.card match:others ];
    
    // then
    XCTAssertEqual( result, 0 );
}

- (void) testMatchAgainstAny
{
    // given
    self.card.value = @"value";
    TestCard *x = [ [ TestCard alloc ] init ];
    x.value = @"x";
    TestCard *y = [ [ TestCard alloc ] init ];
    y.value = @"value";
    NSArray *others = @[ x, y ];
    
    // when
    int result = [ self.card match:others ];
    
    // then
    XCTAssertEqual( result, 1 );
}

- (void) testMatchAgainstAll
{
    // given
    self.card.value = @"value";
    TestCard *x = [ [ TestCard alloc ] init ];
    x.value = @"value";
    TestCard *y = [ [ TestCard alloc ] init ];
    y.value = @"value";
    NSArray *others = @[ x, y ];
    
    // when
    int result = [ self.card match:others ];
    
    // then
    XCTAssertEqual( result, 1 );
}

@end
