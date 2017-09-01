//
//  ShoppingIngredientsViewController~ipad.h
//  Landmann
//
//  Created by Wang on 23.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardWatcher.h"
#import "KeyboardWatcherDelegate.h"
#import "ShoppingIngredientsCellDelegate.h"
#import "ShoppingIngredientsViewController.h"

//typedef enum {
//    ShoppingIngredientsModeAll,
//    ShoppingIngredientsModeCustom,
//    ShoppingIngredientsModeRecipe
//} ShoppingIngredientsMode;


@interface ShoppingIngredientsViewControllerIpad : UIViewController <UITableViewDataSource, UITableViewDelegate, KeyboardWatcherDelegate, ShoppingIngredientsCellDelegate> {
    
    ShoppingIngredientsMode _mode;
    
    NSArray* _leftData;
    NSArray* _leftSectionTitles;
    NSArray* _rightData;
    NSArray* _rightSectionTitles;
    // array
    //     dict
    //         "category": NSString*
    //         "ingredients": NSArray*
    
    BOOL _editing;
    
    UIImageView* _overlayView;
    
    KeyboardWatcher* _keyboardWatcher;
    
    ShoppingIngredientsCellEdit* _activeCell;
    
    UITableView* _leftTableView;
    UITableView* _rightTableView;
    
    UIImageView* _separator;
}


@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) IBOutlet UIView* contentView; 

@property (nonatomic, assign) Recipe* recipe;

@property (nonatomic, strong) IBOutlet UIView* personsView;

@property (nonatomic, strong) IBOutlet UILabel* personsLabel;




- (id) initWithMode:(ShoppingIngredientsMode) mode;

- (IBAction) actionIncreaseScale;

- (IBAction) actiondecreaseScale;

- (IBAction) actionToggleEdit:(UIButton*) sender;

- (IBAction) actionAddRow;

@end
