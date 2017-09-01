//
//  UIWebView+Extension.h
//  Landmann
//
//  Created by Wang on 13.10.15.
//  Copyright © 2015 Wang. All rights reserved.
//

#ifndef UIWebView_Extension_h
#define UIWebView_Extension_h


#import <UIKit/UIKit.h>


@interface UIWebView (Frame_Setters)

// Setters

- (void) setFrameX:(float) theX;
- (void) setFrameY:(float) theY;
- (void) setFrameWidth:(float) theWidth;
- (void) setFrameHeight:(float) theHeight;

- (void) setFrameSize:(CGSize) theSize;
- (void) setFrameOrigin:(CGPoint) theOrigin;

@end

#endif /* UIWebView_Extension_h */
