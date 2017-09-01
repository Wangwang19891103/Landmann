//
//  IngredientsView.h
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IngredientsViewDelegate.h"
#import "TouchView.h"
#import "TouchViewObserver.h"


@interface IngredientsView : UIView <UITextFieldDelegate, TouchViewObserver> {
    
    BOOL _isOut;
    NSArray* _ingredients;
    uint _scale;
    uint _baseScale;
}

@property (nonatomic, assign) IBOutlet id<IngredientsViewDelegate> delegate;

//@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) IBOutlet UITextField* textField;

@property (nonatomic, strong) IBOutlet UIView* contentView;

@property (nonatomic, strong) IBOutlet UIButton* addButton;

@property (nonatomic, strong) IBOutlet UIButton* toggleButton;

@property (nonatomic, strong) IBOutlet UIImageView* background;

- (void) setIngredients:(NSArray *)array withBaseScale:(uint) scale;

- (IBAction) actionShopping:(UIButton*) sender;

//- (void) setAdded;

- (IBAction) handleTap;

- (void) resign;

@end
