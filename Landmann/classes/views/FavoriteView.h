//
//  FavoriteView.h
//  Landmann
//
//  Created by Wang on 27.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteViewDelegate.h"


@interface FavoriteView : UIView {
    
    BOOL _isOut;
}

@property (nonatomic, assign) IBOutlet id<FavoriteViewDelegate> delegate;


- (void) setSelected:(BOOL) selected animated:(BOOL)animated;

@end
