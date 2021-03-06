//
//  Move.h
//  Matchismo
//
//  Created by Carlos Macasaet on 25/1/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Move : NSObject

// designated initialiser
- (instancetype) initWithCards: (NSArray*) cards;

/// The cards involved in this move
@property (strong, nonatomic, readonly) NSArray* cards; // of Card

/// The points generated by this move. It will be negative if there is no match.
@property (nonatomic, readonly) int moveScore;

/// true if and only if a match was found among the cards in this move.
@property (nonatomic, readonly) BOOL matchFound;

@end