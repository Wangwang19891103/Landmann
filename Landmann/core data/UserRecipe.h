//
//  UserRecipe.h
//  Landmann
//
//  Created by Wang on 10.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserNote, UserShoppingEntry;

@interface UserRecipe : NSManagedObject

@property (nonatomic) BOOL added;
@property (nonatomic) int16_t baseScale;
@property (nonatomic) int16_t number;
@property (nonatomic) int16_t scale;
@property (nonatomic) BOOL favorite;
@property (nonatomic, retain) UserNote *note;
@property (nonatomic, retain) NSSet *shoppingEntries;
@end

@interface UserRecipe (CoreDataGeneratedAccessors)

- (void)addShoppingEntriesObject:(UserShoppingEntry *)value;
- (void)removeShoppingEntriesObject:(UserShoppingEntry *)value;
- (void)addShoppingEntries:(NSSet *)values;
- (void)removeShoppingEntries:(NSSet *)values;

@end
