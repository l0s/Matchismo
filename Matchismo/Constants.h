//
//  Constants.h
//  Matchismo
//
//  Created by Carlos Macasaet on 25/1/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

#ifndef Matchismo_Constants_h
#define Matchismo_Constants_h

/// The score penalty for choosing cards that do not match.
FOUNDATION_EXPORT int const MismatchPenalty;
/// The score multiplier used when a match is made.
FOUNDATION_EXPORT int const MatchBonus;
/// The points lost by choosing a card.
FOUNDATION_EXPORT int const FlipCost;
/// Notification sent when a valid group of cards are chosen.
FOUNDATION_EXPORT NSString* const MoveMadeNotification;

#endif