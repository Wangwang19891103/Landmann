//
//  UIWebView+Extension.m
//  Landmann
//
//  Created by Wang on 13.10.15.
//  Copyright © 2015 Wang. All rights reserved.
//

#import "UIWebView+Extension.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIWebView (Frame_Setters)


#pragma mark Setters

- (void) setFrameX:(float)theX {
    
    CGRect newFrame = self.frame;
    newFrame.origin.x = theX;
    self.frame = newFrame;
}

- (void) setFrameY:(float)theY {
    
    CGRect newFrame = self.frame;
    newFrame.origin.y = theY;
    self.frame = newFrame;
}

- (void) setFrameWidth:(float)theWidth {
    
    CGRect newFrame = self.frame;
    newFrame.size.width = theWidth;
    self.frame = newFrame;
}

- (void) setFrameHeight:(float)theHeight {
    
    CGRect newFrame = self.frame;
    newFrame.size.height = theHeight;
    self.frame = newFrame;
}

- (void) setFrameSize:(CGSize)theSize {
    
    CGRect newFrame = self.frame;
    newFrame.size = theSize;
    self.frame = newFrame;
}

- (void) setFrameOrigin:(CGPoint)theOrigin {
    
    CGRect newFrame = self.frame;
    newFrame.origin = theOrigin;
    self.frame = newFrame;
}


@end
