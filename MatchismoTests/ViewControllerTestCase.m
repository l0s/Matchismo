//
//  ViewControllerTestCase.m
//  Matchismo
//
//  Created by Carlos Macasaet on 16/11/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ViewController.h"

@interface ViewControllerTestCase : XCTestCase

@property (strong, nonatomic) ViewController *controller;

@end

@implementation ViewControllerTestCase

- (void)setUp {
    [super setUp];

    self.controller = [ [ ViewController alloc ] init ];
}

- (void)tearDown {
    self.controller = nil;

    [super tearDown];
}

//- (void)testNewGameResets {
//    // given
//    // when
//    [ self.controller st
//    // then
//}


@end
