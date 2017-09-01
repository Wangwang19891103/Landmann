//
//  RecipeDetailsTipViewControllerDelegate.h
//  Landmann
//
//  Created by Wang on 10.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RecipeDetailsTipViewController;


@protocol RecipeDetailsTipViewControllerDelegate <NSObject>


- (UIImage*) tipViewControllerRequestsBackgroundImage:(RecipeDetailsTipViewController*) controller;

- (void) tipViewControllerRequestsClosing:(RecipeDetailsTipViewController*) controller;


@end
