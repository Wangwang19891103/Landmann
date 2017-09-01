//
//  UserNote.h
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserRecipe;

@interface UserNote : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) UserRecipe *recipe;

@end
