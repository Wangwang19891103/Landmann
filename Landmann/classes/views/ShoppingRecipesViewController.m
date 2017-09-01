//
//  ShoppingRecipesViewController.m
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "ShoppingRecipesViewController.h"
#import "ContentDataManager.h"
#import "ShoppingIngredientsViewController.h"
#import "ShoppingIngredientsViewControllerIpad.h"
#import "CALayer+Extensions.h"


@implementation ShoppingRecipesViewController


@synthesize tableView;
@synthesize button;


- (id) init {
    
    if (self = [super initWithNibName:@"ShoppingRecipesViewController" bundle:[NSBundle mainBundle]]) {
        
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:@"ShoppingRecipesCell" owner:nil options:nil];
        _cellAll = [cells objectAtIndex:1];
        
        _cellAll.layer.mask = [CALayer maskLayerWithSize:CGSizeMake(290, 73) roundedCornersTop:true bottom:NO left:NO right:NO radius:4.0];
        _cellAll.layer.mask.frame = CGRectMake(0, 0, 290, 73);
        _cellAll.layer.masksToBounds = true;

        _cellCustom = [cells objectAtIndex:2];
        
        [self.navigationItem setTitle:@"Einkaufskorb"];
        
        
        // custom view right buttons
        
        UIView* rightButtonView = [[UIView alloc] init];
        rightButtonView.backgroundColor = [UIColor clearColor];
        
        UIButton* editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setImage:resource(@"Images.NavigationBar.EditButton") forState:UIControlStateNormal];
        [editButton setImage:resource(@"Images.NavigationBar.CheckButton") forState:UIControlStateSelected];
        [editButton setFrameSize:CGSizeMake(40, 40)];
        [editButton addTarget:self action:@selector(actionToggleEdit:) forControlEvents:UIControlEventTouchUpInside];
        [editButton setFrameOrigin:CGPointMake(0, 0)];
        [rightButtonView addSubview:editButton];
        [rightButtonView setFrameSize:CGSizeMake(40, 40)];
        
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        
        
        // IDIOM
        
        if (!is_ipad)
            [self.navigationItem setRightBarButtonItem:item animated:true];
        
        
        
        [self loadData];
//        [self createCells];
    }
    
    return self;
}



#pragma mark View

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,60)];
    self.tableView.tableHeaderView.alpha = 0.0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
    self.tableView.tableFooterView.alpha = 0.0;
    self.tableView.clipsToBounds = false;
    
    UIImage* overlay = [resource(@"Images.RecipeMenu.TableView.Overlay") resizableImageWithCapInsets:UIEdgeInsetsMake(60, 0, 30, 0) resizingMode:UIImageResizingModeStretch];
    _overlayView = [[UIImageView alloc] initWithImage:overlay];
    [_overlayView setFrameSize:CGSizeMake(320, self.tableView.contentSize.height)];
    [_overlayView setFrameOrigin:CGPointMake(-16, 0)];
    _overlayView.opaque = false;
    
    
    [self.tableView addSubview:_overlayView];
    self.tableView.autoresizesSubviews = true;

    // IDIOM
    
    if (is_ipad) {
        [button setFrame:CGRectMake(245, 20, 40, 40)];
        [self.tableView addSubview:button];
    }
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _didDisappear = true;
}


- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    // IDIOM
    
    if (is_ipad) {
        ShoppingIngredientsViewControllerIpad* controller = [[ShoppingIngredientsViewControllerIpad alloc] initWithMode:ShoppingIngredientsModeAll];
        _selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.rightNavigationController pushViewController:controller animated:false];
        
    }

    _didDisappear = false;
    
    [self loadData];
    [self.tableView reloadData];
    [_overlayView setFrameSize:CGSizeMake(320, self.tableView.contentSize.height)];
    
    // IDIOM
    
    if (is_ipad) {
        
        [tableView selectRowAtIndexPath:_selectedIndexPath animated:true scrollPosition:UITableViewScrollPositionNone];
    }
}


#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _data.count + 2;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 73;
}


- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= 2) return true;
    else return false;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    return [_cells objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        
        return _cellAll;
    }
    else if (indexPath.row == 1) {
        
        return _cellCustom;
    }
    else {
    
        ShoppingRecipesCellRecipe* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ShoppingRecipesCellRecipe"];
        
        if (!cell) {
            
            cell = [ShoppingRecipesCellRecipe cell];
//            cell.editingAccessoryType = UITableViewCellEditingStyleNone;
            
            BOOL bottom = (indexPath.row == [self.tableView numberOfRowsInSection:0]);
            
            cell.layer.mask = [CALayer maskLayerWithSize:CGSizeMake(290, 73) roundedCornersTop:NO bottom:bottom left:NO right:NO radius:4.0];
            cell.layer.mask.frame = CGRectMake(0, 0, 290, 73);
            cell.layer.masksToBounds = true;

        }
        
        Recipe* recipe = [_data objectAtIndex:indexPath.row - 2];
        cell.recipeNumber = recipe.number;
        
        NSLog(@"cellForRow (title: %@)", recipe.title);
        
        cell.titleLabel.text = recipe.title;
        cell.delegate = self;
        
        NSLog(@"imageName: %@", recipe.imageThumb);
        
        NSString* fileName = [NSString stringWithFormat:@"_%@_thumb.jpg", [recipe.imageFull stringByReplacingOccurrencesOfString:@" " withString:@""]];
        NSString* imagePath = [RECIPE_IMAGES_THUMB_IPHONE stringByAppendingPathComponent:fileName];
        NSString* fullPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
        UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
        
        cell.image.image = image;
        
        NSLog(@"image: %@", image);
        
        
    
        // editing
        
//        [cell setEditing:true animated:false];      // doesnt work!
        
//        [cell setEditingMode:_editing animated:false];
        
        return cell;
    }
    
}



#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell* cell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelected:true];
    
    // IDIOM
    
    if (is_ipad) {
        
        _selectedIndexPath = indexPath;
        
        ShoppingIngredientsViewControllerIpad* controller = nil;
        
        if (indexPath.row == 0) {
            
            controller = [[ShoppingIngredientsViewControllerIpad alloc] initWithMode:ShoppingIngredientsModeAll];
        }
        else if (indexPath.row == 1) {
            
            controller = [[ShoppingIngredientsViewControllerIpad alloc] initWithMode:ShoppingIngredientsModeCustom];
        }
        else if (indexPath.row >= 2) {
            
            controller = [[ShoppingIngredientsViewControllerIpad alloc] initWithMode:ShoppingIngredientsModeRecipe];
            Recipe* recipe = [_data objectAtIndex:indexPath.row - 2];
            
            controller.recipe = recipe;
        }
        
        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.rightNavigationController popViewControllerAnimated:false];
        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.rightNavigationController pushViewController:controller animated:false];
    }
    else {
    
        ShoppingIngredientsViewController* controller = nil;
        
        if (indexPath.row == 0) {
            
            controller = [[ShoppingIngredientsViewController alloc] initWithMode:ShoppingIngredientsModeAll];
        }
        else if (indexPath.row == 1) {
            
            controller = [[ShoppingIngredientsViewController alloc] initWithMode:ShoppingIngredientsModeCustom];
        }
        else if (indexPath.row >= 2) {
            
            controller = [[ShoppingIngredientsViewController alloc] initWithMode:ShoppingIngredientsModeRecipe];
            Recipe* recipe = [_data objectAtIndex:indexPath.row - 2];
            
            controller.recipe = recipe;
        }

        UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:backButtonImage forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        controller.navigationItem.leftBarButtonItem = backButtonItem;
        
        [self.tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:TABLEVIEW_CELL_DESELECTION_DELAY];
        
        [self.navigationController pushViewController:controller animated:true];
    }
}


//- (void) deselectCell:(UITableViewCell*) cell {
//    
//    [cell setSelected:false];
//}


- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ShoppingRecipesCellRecipe* cell = (ShoppingRecipesCellRecipe*)[tableView cellForRowAtIndexPath:indexPath];
        [[ContentDataManager instance] deleteRecipeFromShoppingListWithNumber:cell.recipeNumber];
        
        [self loadData];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        // overlay resize animation
        
        float newContentHeight = tableView.contentSize.height - [self tableView:tableView heightForRowAtIndexPath:indexPath];
        
        [UIView animateWithDuration:0.3 animations:^(void) {
            [_overlayView setFrameHeight:newContentHeight];
        }];
    }
}


- (NSString*) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"löschen";
}


//- (void) tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    for (UITableViewCell* cell in self.tableView.visibleCells) {
//
//        if ([cell isKindOfClass:[ShoppingRecipesCellRecipe class]]) {
//
//            [(ShoppingRecipesCellRecipe*)cell setEditingMode:true animated:true];
//        }
//    }
//}
//
//
//- (void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    for (UITableViewCell* cell in self.tableView.visibleCells) {
//        
//        if ([cell isKindOfClass:[ShoppingRecipesCellRecipe class]]) {
//            
//            [(ShoppingRecipesCellRecipe*)cell setEditingMode:false animated:true];
//        }
//    }
//}


#pragma mark Private Methods


//- (void) deselectCell {
//    
//    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
//    [cell setSelected:false];
//    [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//    _selectedIndexPath = nil;
//    
//}


//- (void) createCells {
//    
//    NSMutableArray* cells = [NSMutableArray array];
//    
//    for (uint i = 0; i < _data.count + 2; ++i) {
//
//        if (i == 0) {
//            
//             [cells addObject: _cellAll];
//        }
//        else if (i == 1) {
//            
//            [cells addObject: _cellCustom];
//        }
//        else {
//            
//            ShoppingRecipesCellRecipe* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ShoppingRecipesCellRecipe"];
//            
//            if (!cell) {
//                
//                cell = [ShoppingRecipesCellRecipe cell];
//                cell.delegate = self;
//                
//                BOOL bottom = (i == [self.tableView numberOfRowsInSection:0]);
//                
//                cell.layer.mask = [CALayer maskLayerWithSize:CGSizeMake(290, 73) roundedCornersTop:NO bottom:bottom left:NO right:NO radius:4.0];
//                cell.layer.mask.frame = CGRectMake(16, 0, 290, 73);
//                cell.layer.masksToBounds = true;
//                
//            }
//            
//            Recipe* recipe = [_data objectAtIndex:i - 2];
//            
//            cell.recipeNumber = recipe.number;
//            cell.indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//            
//            NSLog(@"cellForRow (title: %@)", recipe.title);
//            
//            cell.titleLabel.text = recipe.title;
//            
//            NSLog(@"imageName: %@", recipe.imageThumb);
//            
//            NSString* fileName = [NSString stringWithFormat:@"_%@_thumb.jpg", [recipe.imageFull stringByReplacingOccurrencesOfString:@" " withString:@""]];
//            NSString* imagePath = [RECIPE_IMAGES_THUMB stringByAppendingPathComponent:fileName];
//            NSString* fullPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
//            UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
//            
//            cell.image.image = image;
//            
//            NSLog(@"image: %@", image);
//            
//            [cells addObject:cell];
//        }
//
//    }
//
//    _cells = cells;
//}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}


- (IBAction) actionToggleEdit:(UIButton *)sender {
    
    NSLog(@"toggle edit");
    
    _editing = !_editing;

    sender.selected = _editing;
    
//    for (uint i = 2; i < _cells.count;  ++i) {
//        
//        [[_cells objectAtIndex:i] setEditingMode:_editing];
//    }

//    for (UITableViewCell* cell in self.tableView.visibleCells) {
//        
////        [cell setEditing:_editing animated:true];
//        if ([cell isKindOfClass:[ShoppingRecipesCellRecipe class]]) {
//            
//            [(ShoppingRecipesCellRecipe*)cell setEditingMode:_editing animated:true];
//        }
//    }

    
    [self.tableView setEditing:_editing animated:true];
    
//    uint rows = [self.tableView numberOfRowsInSection:0];
//    
//    for (uint i = 2; i < rows; ++i) {
//        
//        ShoppingRecipesCellRecipe* cell = (ShoppingRecipesCellRecipe*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//        
//        [cell setEditingMode:_editing animated:true];
//    }
}


- (void) loadData {
 
    _data = [[ContentDataManager instance] recipesOnShoppingList];
}


- (void) refresh {      // IDIOM

    [self loadData];
    [self.tableView reloadData];
    [_overlayView setFrameSize:CGSizeMake(320, self.tableView.contentSize.height)];

    if ([self.tableView numberOfSections] < _selectedIndexPath.section + 1 ||
        [self.tableView numberOfRowsInSection:_selectedIndexPath.section] < _selectedIndexPath.row + 1) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    

    [tableView selectRowAtIndexPath:_selectedIndexPath animated:true scrollPosition:UITableViewScrollPositionNone];
}



#pragma mark Delegate Methods

- (void) shoppingRecipesCellRequestsDeletion:(ShoppingRecipesCellRecipe *)cell {
    
    NSLog(@"cell requests deletion with number: %d", cell.recipeNumber);
    
    [[ContentDataManager instance] deleteRecipeFromShoppingListWithNumber:cell.recipeNumber];
    
    [self loadData];
    
    
//    [self createCells];
//    [self.tableView reloadData];
    
    NSIndexPath* path = nil;
    
    for (uint i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        if (cell == [self.tableView cellForRowAtIndexPath:indexPath]) {
            
            path = indexPath;
            break;
        }
    }
    
    if (!path) {
//        alert(@"IndexPath not found");
    }
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
