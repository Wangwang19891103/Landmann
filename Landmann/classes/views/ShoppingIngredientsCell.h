//
//  ShoppingIngredientsCell.h
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingIngredientsCellDelegate.h"


@interface ShoppingIngredientsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton* checkbox;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@property (nonatomic, strong) NSMutableArray* shoppingEntries;

@property (nonatomic, strong) IBOutlet UIView* contentView2;


+ (id) cell;

- (IBAction) actionCheck:(UIButton*) sender;



@end



@interface ShoppingIngredientsCellEdit : ShoppingIngredientsCell <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView* textView;

@property (nonatomic, assign) id<ShoppingIngredientsCellDelegate> delegate;


+ (id) cell;

- (IBAction) actionCheck:(UIButton*) sender;

- (void) resign;


@end
