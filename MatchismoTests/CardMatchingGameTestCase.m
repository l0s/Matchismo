//
//  CardMatchingGameTestCase.m
//  Matchismo
//
//  Created by Carlos Macasaet on 3/11/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CardMatchingGame.h"

@interface CardMatchingGameTestCasePartialMockDeck : Deck

- (instancetype) initWithCards: ( NSMutableArray * )cards;

@end

@implementation CardMatchingGameTestCasePartialMockDeck

- (instancetype) initWithCards:(NSMutableArray *)cards
{
    self = [ super init ];
    if( self )
    {
        _cards = cards;
    }
    return self;
}

@end

@interface CardMatchingGameTestCase : XCTestCase

@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation CardMatchingGameTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    self.game = nil;

    [super tearDown];
}

- (void)testCorrectCardCount {
    // given
    NSUInteger slotCount = 1;
    Card *card = [ [ Card alloc ] init ];
    Deck *deck =
        [ [ CardMatchingGameTestCasePartialMockDeck alloc ] initWithCards:[ [ NSMutableArray alloc ] initWithArray:@[ card ] ] ];
    self.game =
        [ [ CardMatchingGame alloc ] initWithPlayableCards:slotCount
                                                   andDeck:deck ];

    // when
    NSInteger result = self.game.score;

    // then
    XCTAssertEqual( result, 0 );
}

@end