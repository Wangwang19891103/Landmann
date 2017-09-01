//
//  Keyword.h
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface Keyword : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Recipe *recipe;

@end
