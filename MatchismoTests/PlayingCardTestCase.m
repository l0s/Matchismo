//
//  PlayingCardTestCase.m
//  Matchismo
//
//  Created by Carlos Macasaet on 25/10/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "PlayingCard.h"

@interface PlayingCardTestCase : XCTestCase

@property (nonatomic, strong) PlayingCard *card;

@end

@implementation PlayingCardTestCase

- (void)setUp {
    [super setUp];
    
    self.card = [ PlayingCard alloc ];
}

- (void)tearDown {
    self.card = nil;

    [super tearDown];
}

- (void) testNumValidSuits
{
    // given
    NSUInteger expected = 4;
    
    // when
    NSUInteger actual = [ PlayingCard validSuits ].count;

    // then
    XCTAssertEqual(actual, expected);
}

- (void) testNumValidRanks
{
    // given
    NSUInteger expected = 13;

    // when
    NSUInteger actual = [ PlayingCard maxRank ];

    // then
    XCTAssertEqual(actual, expected);
}

- (void) testInitSuit
{
    // given
    

    // when
    PlayingCard *result =
        [ self.card initWithRank:7 andSuit:@"♣︎" ];

    // then
    XCTAssertEqualObjects(result.suit, @"♣︎");
}

- (void) testInitRank
{
    // given
    
    
    // when
    PlayingCard *result =
        [ self.card initWithRank:11 andSuit:@"♣︎" ];
    
    // then
    XCTAssertEqualObjects(result.rankString, @"J");
}

@end