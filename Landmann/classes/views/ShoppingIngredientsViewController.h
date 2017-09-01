//
//  ShoppingIngredientsViewController.h
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardWatcher.h"
#import "KeyboardWatcherDelegate.h"
#import "ShoppingIngredientsCellDelegate.h"


typedef enum {
    ShoppingIngredientsModeAll,
    ShoppingIngredientsModeCustom,
    ShoppingIngredientsModeRecipe
} ShoppingIngredientsMode;


@interface ShoppingIngredientsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, KeyboardWatcherDelegate, ShoppingIngredientsCellDelegate> {
    
    ShoppingIngredientsMode _mode;
    
    NSArray* _data;
    NSArray* _sectionTitles;
    // array
    //     dict
    //         "category": NSString*
    //         "ingredients": NSArray*
    
    BOOL _editing;
    
    UIImageView* _overlayView;

    KeyboardWatcher* _keyboardWatcher;
    
    ShoppingIngredientsCellEdit* _activeCell;
}


@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@property (nonatomic, assign) Recipe* recipe;

@property (nonatomic, strong) IBOutlet UITableViewCell* personsCell;

@property (nonatomic, strong) IBOutlet UILabel* personsLabel;

@property (nonatomic, strong) IBOutlet UIButton* button;

@property (nonatomic, strong) IBOutlet UIButton* button2;




- (id) initWithMode:(ShoppingIngredientsMode) mode;

- (IBAction) actionIncreaseScale;

- (IBAction) actiondecreaseScale;

- (IBAction) actionToggleEdit:(UIButton*) sender;

- (IBAction) actionAddRow;

@end
