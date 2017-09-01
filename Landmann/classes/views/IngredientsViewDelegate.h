//
//  IngredientsViewDelegate.h
//  Landmann
//
//  Created by Wang on 27.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class IngredientsView;


@protocol IngredientsViewDelegate <NSObject>

- (void) ingredientsViewDidBeginEditing:(IngredientsView*) view;
- (void) ingredientsViewDidEndEditing:(IngredientsView*) view;
- (void) ingredientsView:(IngredientsView*) view willMoveToPosition:(CGPoint) point withDuration:(float) duration;
- (void) ingredientsView:(IngredientsView*) view addToShoppingListWithScale:(uint) scale;


@end
