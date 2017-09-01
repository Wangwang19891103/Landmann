//
//  FavoriteViewDelegate.h
//  Landmann
//
//  Created by Wang on 10.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FavoriteView;


@protocol FavoriteViewDelegate <NSObject>

- (void) favoriteViewDidGetSelected:(BOOL) selected;

@end
