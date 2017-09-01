//
//  ShoppingRecipesViewController.h
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingRecipesCell.h"
#import "ShoppingRecipesCellDelegate.h"


@interface ShoppingRecipesViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, ShoppingRecipesCellDelegate> {
    
    NSArray* _data;
    
    ShoppingRecipesCell* _cellAll;
    ShoppingRecipesCell* _cellCustom;
    
    BOOL _editing;
    
//    NSArray* _cells;

    UIImageView* _overlayView;
    
    BOOL _didDisappear;
    
    NSIndexPath* _selectedIndexPath;
}


@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) IBOutlet UIButton* button;


- (IBAction) actionToggleEdit:(UIButton*) sender;

- (void) refresh; // IDIOM

@end
