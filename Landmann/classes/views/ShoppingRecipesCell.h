//
//  ShoppingRecipesCell.h
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingRecipesCellDelegate.h"


@interface ShoppingRecipesCell : UITableViewCell {
    
    UIImage* _background;
    UIImage* _backgorundSelected;
}

@property (nonatomic, strong) IBOutlet UIImageView* background;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@property (nonatomic, strong) IBOutlet UIView* contentView2;

@end



@interface ShoppingRecipesCellRecipe : ShoppingRecipesCell {
    
    BOOL _editing;
    UITableViewCellStateMask _fromState, _toState;
    
    BOOL _transitioning;
    
    float _x;
}

@property (nonatomic, strong) IBOutlet UIImageView* image;

@property (nonatomic, strong) IBOutlet UIView* editView;

@property (nonatomic, assign) id<ShoppingRecipesCellDelegate> delegate;

@property (nonatomic, assign) uint recipeNumber;

@property (nonatomic, copy) NSIndexPath* indexPath;


+ (id) cell;

- (void) setEditingMode:(BOOL) editing animated:(BOOL) animated;

- (IBAction) actionDelete;

@end
