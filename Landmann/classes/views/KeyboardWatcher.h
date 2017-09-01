//
//  KeyboardWatcher.h
//  Landmann
//
//  Created by Wang on 30.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardWatcherDelegate.h"


@interface KeyboardWatcher : NSObject

@property (nonatomic, assign) id<KeyboardWatcherDelegate> delegate;

@end
