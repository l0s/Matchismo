//
//  Card.h
//  Matchismo
//
//  Created by Carlos Macasaet on 10/17/14.
//  Copyright (c) 2014 Carlos Macasaet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    Black,
    Red
} TextColor;

@interface Card : NSObject

@property (strong, readonly, nonatomic) NSString *value;
@property (readonly, nonatomic) TextColor color;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int) match: (NSArray *)cards;

@end