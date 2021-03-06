//
//  NSArray+Extensions.h
//  Sprachenraetsel
//
//  Created by Wang on 16.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSArray (Extensions) 

+ (NSArray*) randomizedArrayFromArray:(NSArray*) array;

- (NSArray*) sortUsingNumberArray:(NSArray**) array ascending:(BOOL) ascending;

- (NSArray*) sortAscending:(BOOL) ascending usingNumberArrays:(NSMutableArray**) firstArray, ... ;

- (NSArray*) sort2DimensionalArrayUsingNumberAtIndex:(int) sortIndex ascending:(BOOL) ascending;

- (NSArray*) reversedArray;

- (NSArray*) copyArrayExcludingObjectsFromArray:(NSArray*) array;

- (NSArray*) sortByLengthOfStringsAscending:(BOOL) ascending;

- (BOOL) containsObject:(id) object inSubArrayAtIndex:(uint) subIndex;

- (id) firstElement;

- (NSArray*) sortUsingOrderInArray:(NSArray*) array;

- (NSArray*) sortUsingKeyInDictionary:(NSString*) key ascending:(BOOL) ascending;

- (NSString*) serializeToString;

@end


@interface NSMutableArray (Extensions)

- (void) removeFirstObjectMatchingString:(id) object;

+ (id) createArrayWithWeakReferences;
+ (id) createArrayWithWeakReferencesWithCapacity:(int) capacity;

@end
