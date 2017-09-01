//
//  KeyboardWatcherDelegate.h
//  Landmann
//
//  Created by Wang on 30.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyboardWatcherDelegate <NSObject>

- (void) keyboardWillShow;

- (void) keyboardDidShow;

- (void) keyboardWillHide;

- (void) keyboardDidHide;

@end
