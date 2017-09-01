//
//  TouchView.h
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchViewObserver.h"


@interface TouchView : UIView

@property (nonatomic, assign) UIView* forwardView;

@property (nonatomic, strong) IBOutletCollection(id) NSArray* observers;

@end
