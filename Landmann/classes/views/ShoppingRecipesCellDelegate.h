//
//  ShoppingRecipesCellDelegate.h
//  Landmann
//
//  Created by Wang on 07.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ShoppingRecipesCellRecipe;


@protocol ShoppingRecipesCellDelegate <NSObject>

- (void) shoppingRecipesCellRequestsDeletion:(ShoppingRecipesCellRecipe*) cell;

@end
