//
//  RecipeMenuViewControllerDelegate.m
//  Landmann
//
//  Created by Wang on 24.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//


@class RecipeImageViewController;


@protocol RecipeImageViewControllerDelegate <NSObject>

- (void) recipeImageViewController:(RecipeImageViewController*) controller didPickRecipeImage:(UIImage*) image;

@end
