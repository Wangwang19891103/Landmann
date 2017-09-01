//
//  TouchViewObserver.h
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TouchView;


@protocol TouchViewObserver <NSObject>

- (void) touchViewDidReceiveTouchOutside:(TouchView*) view;

@end
