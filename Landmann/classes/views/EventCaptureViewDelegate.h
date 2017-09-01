//
//  EventCaptureViewDelegate.h
//  Landmann
//
//  Created by Wang on 29.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class EventCaptureView;



@protocol EventCaptureViewDelegate <NSObject>

- (void) eventCaptureViewWasTapped:(EventCaptureView*) captureView;

@end
