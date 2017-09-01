//
//  EventCaptureView.h
//  Landmann
//
//  Created by Wang on 29.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventCaptureViewDelegate.h"


@interface EventCaptureView : UIView

@property (nonatomic, assign) IBOutlet id<EventCaptureViewDelegate> delegate;

@end
