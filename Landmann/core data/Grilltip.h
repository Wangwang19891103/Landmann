//
//  Grilltip.h
//  Landmann
//
//  Created by Wang on 06.06.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Grilltip : NSManagedObject

@property (nonatomic, retain) NSString * menuTitle;
@property (nonatomic) int16_t number;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * images;

@end
