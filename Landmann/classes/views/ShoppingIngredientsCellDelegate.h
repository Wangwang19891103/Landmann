//
//  ShoppingIngredientsCellDelegate.h
//  Landmann
//
//  Created by Wang on 10.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ShoppingIngredientsCellEdit;


@protocol ShoppingIngredientsCellDelegate <NSObject>

- (void) shoppingIngredientsCellDidBeginEditing:(ShoppingIngredientsCellEdit*) cell;

- (void) shoppingIngredientsCellDidEndEditing:(ShoppingIngredientsCellEdit*) cell;

@end
