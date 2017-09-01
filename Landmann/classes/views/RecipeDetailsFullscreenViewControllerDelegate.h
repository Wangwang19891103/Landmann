//
//  RecipeDetailFullscreenViewControllerDelegate.h
//  Landmann
//
//  Created by Wang on 24.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RecipeDetailsFullscreenViewController;


@protocol RecipeDetailsFullscreenViewControllerDelegate <NSObject>


- (void) recipeDetailsFullScreenViewControllerDidRequestClosing:(RecipeDetailsFullscreenViewController*) controller;

@end
