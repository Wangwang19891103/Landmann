//
//  CGExtensions.h
//  Sprachenraetsel
//
//  Created by Wang on 09.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



CGSize CGSizeScaleToSize(CGSize oldSize, CGSize newSize, BOOL upscale);

CGPoint CGSizeCenterInSize(CGSize size, CGSize parentSize);

CGRect CGRectCenterXInRect(CGRect rect, CGRect parentRect);

CGRect CGRectCenterYInRect(CGRect rect, CGRect parentRect);

CGRect CGRectCopy(CGRect rect);

CGSize CGSizeScaleByFactor(CGSize size, float factor);

CGPoint CGPointScaleByFactor(CGPoint point, float factor);

CGRect CGRectScaleByFactor(CGRect rect, float factor);

CGRect CGSizeCenterInRect(CGSize size, CGRect rect);

CGRect CGSizeInset(CGSize size, UIEdgeInsets insets);

CGRect CGRectInset2(CGRect rect, UIEdgeInsets insets);
