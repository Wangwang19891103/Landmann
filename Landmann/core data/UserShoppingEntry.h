//
//  UserShoppingEntry.h
//  Landmann
//
//  Created by Wang on 30.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserRecipe;

@interface UserShoppingEntry : NSManagedObject

@property (nonatomic) float amount;
@property (nonatomic) float amountMax;
@property (nonatomic) BOOL checked;
@property (nonatomic) int16_t ingredientNumber;
@property (nonatomic) int16_t number;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) UserRecipe *recipe;

@end
