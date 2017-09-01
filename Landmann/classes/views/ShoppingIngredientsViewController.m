//
//  ShoppingIngredientsViewController.m
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "ShoppingIngredientsViewController.h"
#import "ShoppingIngredientsCell.h"
#import "ShoppingIngredientsSectionHeader.h"
#import "CALayer+Extensions.h"
#import "FloatFormatter.h"
#import "EmptyCells.h"



#define PERSONS_LABEL_TEXT @"für %d Personen"

#define BOTTOM_MARGIN 0
#define KEYBOARD_HEIGHT 216
#define KEYBOARD_DURATION 0.3
#define NAVBAR_HEIGHT 44
#define TABBAR_HEIGHT 49


@implementation ShoppingIngredientsViewController


@synthesize tableView;
@synthesize titleLabel;
@synthesize recipe;
@synthesize personsCell;
@synthesize personsLabel;
@synthesize button;
@synthesize button2;



- (id) initWithMode:(ShoppingIngredientsMode) mode {
    
    if (self = [super initWithNibName:@"ShoppingIngredientsViewController" bundle:[NSBundle mainBundle]]) {
        
        _mode = mode;
        
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

        if (_mode == ShoppingIngredientsModeCustom) {

            UIButton* addButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [addButton setImage:resource(@"Images.NavigationBar.AddButton") forState:UIControlStateNormal];
            [addButton setFrameSize:CGSizeMake(40, 40)];
            [addButton addTarget:self action:@selector(actionAddRow) forControlEvents:UIControlEventTouchUpInside];
            [addButton setFrameOrigin:CGPointMake(0, 0)];
            [rightButtonView addSubview:addButton];
            [editButton setFrameX:40];
            [rightButtonView setFrameWidth:80];
        }
        
        
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        
        [self.navigationItem setRightBarButtonItem:item animated:true];
        
        _keyboardWatcher = [[KeyboardWatcher alloc] init];
        _keyboardWatcher.delegate = self;
    }
    
    return self;
}


#pragma mark View

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadData];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,60)];
    self.tableView.tableHeaderView.alpha = 0.0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
    self.tableView.tableFooterView.alpha = 0.0;
    self.tableView.clipsToBounds = false;
    
    UIImage* overlay = [resource(@"Images.RecipeMenu.TableView.Overlay") resizableImageWithCapInsets:UIEdgeInsetsMake(60, 0, 30, 0) resizingMode:UIImageResizingModeStretch];
    _overlayView = [[UIImageView alloc] initWithImage:overlay];
//    _overlayView.contentMode = UIViewContentModeTopLeft;
//    _overlayView.clipsToBounds = false;
    [_overlayView setFrameSize:CGSizeMake(320, self.tableView.contentSize.height)];
    [_overlayView setFrameOrigin:CGPointMake(-16, 0)];
    _overlayView.opaque = false;
//    _overlayView.alpha = 0.0;
    
    
    [self.tableView addSubview:_overlayView];
    self.tableView.autoresizesSubviews = true;
    
//    [button setFrame:CGRectMake(245, 7, 40, 40)];
//    [self.tableView addSubview:button];
//
//    [button2 setFrame:CGRectMake(205, 7, 40, 40)];
//    [self.tableView addSubview:button2];

    [titleLabel setFrameOrigin:CGPointMake(0, 20)]; // war 7
    [self.tableView addSubview:titleLabel];

    
    if (_mode == ShoppingIngredientsModeAll) {

        titleLabel.text = @"Alle Zutaten";
//        [self loadDataAll];
    }
    else if (_mode == ShoppingIngredientsModeCustom) {
        
        titleLabel.text = @"Selbst hinzugefügt";
    }
    else if (_mode == ShoppingIngredientsModeRecipe) {
        
        titleLabel.text = recipe.title;
//        [self loadData];
    }

    
    // persons cell layer mask
    
    personsCell.layer.mask = [CALayer maskLayerWithSize:CGSizeMake(290, 40) roundedCornersTop:YES bottom:NO left:NO right:NO radius:4.0];
    personsCell.layer.mask.frame = CGRectMake(0, 0, 290, 40);
    personsCell.layer.masksToBounds = true;


    [self updatePersonsLabelWithScale:[[ContentDataManager instance] userRecipeForRecipe:recipe].scale];
    
    
//    UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
//    [self.view addGestureRecognizer:recognizer]; // blockiert edit controls
    
}



#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_data.count == 0) return 1;

    if (_mode == ShoppingIngredientsModeRecipe)
        return _data.count + 1;
    else
        return _data.count;
        
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 && _data.count == 0) return 1;
    
    if (_mode == ShoppingIngredientsModeRecipe && section == 0)
        return 1;
    else
        
        if (_mode == ShoppingIngredientsModeRecipe) section--;
    
        return [(NSArray*)[_data objectAtIndex:section] count];
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (_data.count == 0 && section == 0) return 0;
    
    if (_mode == ShoppingIngredientsModeCustom && section == 0)
        return 0;
    else if (_mode == ShoppingIngredientsModeRecipe && section == 0)
        return 0;
    else
        return 38;
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0 && _data.count == 0) return nil;
    
    if (_mode == ShoppingIngredientsModeCustom && section == 0)
        return nil;
    
    else if (_mode == ShoppingIngredientsModeRecipe && section == 0)
        return nil;
    
    else {
     
        if (_mode == ShoppingIngredientsModeRecipe) section--;
        
        ShoppingIngredientsSectionHeader* header = [ShoppingIngredientsSectionHeader sectionHeader];
        header.titleLabel.text = [_sectionTitles objectAtIndex:section];
        
        BOOL top = (section == 1 && _mode != ShoppingIngredientsModeRecipe);
        
        header.layer.mask = [CALayer maskLayerWithSize:CGSizeMake(290, 38) roundedCornersTop:top bottom:NO left:NO right:NO radius:4.0];
        header.layer.mask.frame = CGRectMake(0, 0, 290, 38);
        header.layer.masksToBounds = true;
        
        return header;
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_mode == ShoppingIngredientsModeRecipe && indexPath.section == 0)
        return 40;
    else
        return 64;
}


- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_data.count == 0) return UITableViewCellEditingStyleNone;

    if (_mode == ShoppingIngredientsModeRecipe && indexPath.section == 0)
        return UITableViewCellEditingStyleNone;
    else
        return UITableViewCellEditingStyleDelete;
}


- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
    if (_data.count == 0) return false;
    
    if (_mode == ShoppingIngredientsModeRecipe && indexPath.section == 0)
        return false;
    else
        return true;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_data.count == 0) {
        
        EmptyIngredientsCell* cell = [EmptyIngredientsCell cell];
        
        return cell;
    }

    
    if (_mode == ShoppingIngredientsModeRecipe && indexPath.section == 0 && indexPath.row == 0)
        return personsCell;

    
    uint section = indexPath.section;
    
    if (_mode == ShoppingIngredientsModeRecipe) section--;
    
    NSDictionary* data = [[_data objectAtIndex:section] objectAtIndex:indexPath.row];

    NSString* source = [data objectForKey:@"source"];
    
    
    ShoppingIngredientsCell* cell = nil;
    
    
    if (_mode == ShoppingIngredientsModeCustom && [source isEqualToString:@"custom"]) {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"ShoppingIngredientsCellEdit"];
        
        if (!cell) {
            
            cell = [ShoppingIngredientsCellEdit cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        ((ShoppingIngredientsCellEdit*)cell).textView.text = [data objectForKey:@"text"];
        ((ShoppingIngredientsCellEdit*)cell).delegate = self;
    }
    else {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"ShoppingIngredientsCell"];
        
        if (!cell) {
            
            cell = [ShoppingIngredientsCell cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.titleLabel.text = [data objectForKey:@"text"];
    }
    
    
    cell.shoppingEntries = [data objectForKey:@"entries"];
    
    BOOL allChecked = true;
    for (UserShoppingEntry* shoppingEntry in cell.shoppingEntries) {
        if (!shoppingEntry.checked) {
            allChecked = false;
            break;
        }
    }
    
    cell.checkbox.selected = allChecked;


    // layer mask

    BOOL bottom = (indexPath.section == [self.tableView numberOfSections] - 1
                   && indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1);
    
    cell.layer.mask = [CALayer maskLayerWithSize:CGSizeMake(290, 64) roundedCornersTop:NO bottom:bottom left:NO right:NO radius:4.0];
    cell.layer.mask.frame = CGRectMake(0, 0, 290, 64);
    cell.layer.masksToBounds = true;

    
    
    return cell;
}


#pragma mark Private Methods


//- (void) deselectCell {
//
//    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
//    [cell setSelected:false];
//    [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//    _selectedIndexPath = nil;
//
//}


- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        uint numberOfSectionsBeforeDeletion = [self numberOfSectionsInTableView:tableView];
        uint numberOfRowsBeforeDeletion = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        
        
        ShoppingIngredientsCell* cell = (ShoppingIngredientsCell*)[tableView cellForRowAtIndexPath:indexPath];

        // delete all associated ShoppingEntries
        [[ContentDataManager instance] deleteShoppingEntries:cell.shoppingEntries];

        
        float heightDiff = 0;
        float heightForFirstSectionHeader = [self tableView:self.tableView heightForHeaderInSection:0];

        
        [self loadData];

        
        
        
        if (_mode != ShoppingIngredientsModeRecipe && _data.count == 0) {

            [self.tableView beginUpdates];

            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
            
            heightDiff -= heightForFirstSectionHeader;
        }
        
        else if (_mode == ShoppingIngredientsModeRecipe && _data.count == 0) {  // deleting last cell in recipes mode

            float heightForSecondSectionHeader = [self tableView:self.tableView heightForHeaderInSection:1];  // needed for recipes deleting last entry
            float heightForPersonsCell = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

            heightDiff -= heightForFirstSectionHeader + heightForSecondSectionHeader + heightForPersonsCell;

            [self.tableView beginUpdates];

            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0],indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
            
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
            
        }

        else {
          
            [self.tableView beginUpdates];

            // delete section if empty

            if (numberOfRowsBeforeDeletion == 1) {
                
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {
                
                // delete row
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }

            [self.tableView endUpdates];

            uint numberOfSectionsAfterDeletion = [self numberOfSectionsInTableView:tableView];

            heightDiff -= [self tableView:tableView heightForRowAtIndexPath:indexPath];
            
            if (numberOfSectionsBeforeDeletion > numberOfSectionsAfterDeletion) heightDiff -= [self tableView:tableView heightForHeaderInSection:indexPath.section];
        }
        

        
        // overlay resize animation
        
        
        float newContentHeight = tableView.contentSize.height + heightDiff;
        
        [UIView animateWithDuration:0.3 animations:^(void) {
            [_overlayView setFrameHeight:newContentHeight];
        }];
    }
}


- (NSString*) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"löschen";
}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}


- (void) updateOverLay {
    
    [self.tableView addSubview:_overlayView]; // place back on top
    [self.tableView addSubview:titleLabel];
    [self.tableView addSubview:button];
    [self.tableView addSubview:button2];
}


- (IBAction) actionIncreaseScale {

    uint newScale = [[ContentDataManager instance] increaseScaleForRecipe:recipe];
    
    [self loadData];
    [self.tableView reloadData];
    [self updatePersonsLabelWithScale:newScale];
    [self updateOverLay];
}


- (IBAction) actiondecreaseScale {

    uint newScale = [[ContentDataManager instance] decreaseScaleForRecipe:recipe];

    [self loadData];
    [self.tableView reloadData];
    [self updatePersonsLabelWithScale:newScale];
    [self updateOverLay];
}


- (void) updatePersonsLabelWithScale:(uint) scale {
    
    personsLabel.text = [NSString stringWithFormat:PERSONS_LABEL_TEXT, scale];
}



- (IBAction) actionToggleEdit:(UIButton*) sender {

    NSLog(@"toggle edit");
    
    _editing = !_editing;
    
    sender.selected = _editing;
   
    [self.tableView setEditing:_editing animated:true];
}


- (IBAction) actionAddRow {
    
    if (_mode == ShoppingIngredientsModeCustom) {
    
        uint numberOfSectionsBeforeInsertion = [self numberOfSectionsInTableView:self.tableView];
        
        uint numberOfRowsBeforeInsertion;
        
        if (numberOfSectionsBeforeInsertion == 0) numberOfRowsBeforeInsertion = 0;
        else if (_data.count == 0) numberOfRowsBeforeInsertion = 0;
        else numberOfRowsBeforeInsertion = [self tableView:self.tableView numberOfRowsInSection:0];
        
        uint dataCountBeforeInsertion = _data.count;
        
        NSLog(@"add row");
     
        UserShoppingEntry* entry = [[ContentDataManager instance] insertCustomShoppingEntry];
        
        NSLog(@"number: %d", entry.number);
        
        [self loadData];
        
        NSIndexPath* insertedPath = [NSIndexPath indexPathForItem:numberOfRowsBeforeInsertion inSection:0];
        
        
        [self.tableView beginUpdates];
        
        if (numberOfSectionsBeforeInsertion == 0) {
            
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }

        if (dataCountBeforeInsertion == 0) {
            
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {

            [self.tableView insertRowsAtIndexPaths:@[insertedPath] withRowAnimation:UITableViewRowAnimationFade];

            // overlay resize animation
            
            float newContentHeight = tableView.contentSize.height + [self tableView:tableView heightForRowAtIndexPath:insertedPath];
            if (numberOfSectionsBeforeInsertion == 0) newContentHeight += [self tableView:tableView heightForHeaderInSection:0];
            
            NSLog(@"heightforrow: %f", [self tableView:tableView heightForRowAtIndexPath:insertedPath]);
            
            [UIView animateWithDuration:0.3 animations:^(void) {
                [_overlayView setFrameHeight:newContentHeight];
            }];
            
            
            // reload cells above
            
            for (uint r = 0; r < numberOfRowsBeforeInsertion; ++r) {
                
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:r inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        
        [self.tableView endUpdates];
        

        [self.tableView scrollToRowAtIndexPath:insertedPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
        


        
        

    }
}


- (void) actionTap {
    
    NSLog(@"content tap");
    
    [_activeCell resign];
}




//- (void) loadDataAll {
//    
//    // populate ingredients dict with categories
//    NSMutableDictionary* ingredientsDict = [NSMutableDictionary dictionary];
//    // dict
//    //     <category>: dict
//    //         "number": uint
//    //         "shoppingEntries": array
//    //             UserShoppingEntry
//    //         "texts" : array
//    //             NSString*
//    
//    // dict
//    //     <category>: dict
//    //         <ingredientNumber>: array
//    //             dict
//    //                 text: NSString*
//    //                 checked: bool
//    //                 entry: ShoppingEntry
//    
//    
//    NSArray* ingredientCategories = [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"IngredientCategory" withPredicate:nil sortedBy:@"number", nil];
//
//    // IngredientCategories
//    for (IngredientCategory* category in ingredientCategories) {
//
//        NSMutableDictionary* catDict = [NSMutableDictionary dictionary];
//        [ingredientsDict setObject:catDict forKey:category.title];
//        
//        NSArray* ingredients = [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Ingredient" withPredicate:[NSPredicate predicateWithFormat:@"category == %@", category] sortedBy:@"number", nil];
//
//        // Ingredients
//        for (Ingredient* ingredient in ingredients) {
//            
//            if (ingredients.count == 0) continue;
//            
//            
//            NSMutableArray* ingArray = [NSMutableArray array];
//            [catDict setObject:ingArray forKey:[NSNumber numberWithInt:ingredient.number]];
//            
//            NSArray* shoppingEntries = [[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserShoppingEntry" withPredicate:[NSPredicate predicateWithFormat:@"ingredientNumber == %d", ingredient.number] sortedBy:@"recipe.number", nil];
//            
//            // UserShoppingEntries
//            for (UserShoppingEntry* shoppingEntry in shoppingEntries) {
//                
////                Recipe* recipe = [[[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", shoppingEntry.recipe.number] sortedBy:nil] firstElement];
//                
////                IngredientEntry* entry = [[[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"IngredientEntry" withPredicate:[NSPredicate predicateWithFormat:@"recipe.number == %d AND number == %d", shoppingEntry.recipe.number, shoppingEntry.number] sortedBy:nil] firstElement];
//                
//                
//                
//                [ingArray addObject:shoppingEntry];
//            }
//        }
//        
//    }
//    
//    
//    
//    
//    
//    NSMutableArray* data = [NSMutableArray array];
//    NSMutableArray* sectionTitles = [NSMutableArray array];
//    
//    // transfer arrays from ingredientsDict into data (sectioned)
//    for (IngredientCategory* category in ingredientCategories) {
//    
//        NSDictionary* catDict = [ingredientsDict objectForKey:category.title];
//
//        // output
//        NSMutableArray* rowArray = [NSMutableArray array];
//
//        NSArray* ingredients = [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Ingredient" withPredicate:[NSPredicate predicateWithFormat:@"category == %@", category] sortedBy:@"number", nil];
//        
//        // Ingredients
//        for (Ingredient* ingredient in ingredients) {
//            
//            NSArray* ingArray = [catDict objectForKey:[NSNumber numberWithInt:ingredient.number]];
//        
//            if (ingArray.count == 0) continue;
//            
//            // creating sum
//            uint totalAmount = 0;
//            uint totalAmountMax = 0;
//            
//            for (UserShoppingEntry* shoppingEntry in ingArray) {
//                
//                totalAmount += shoppingEntry.amount;
//                totalAmountMax += shoppingEntry.amountMax;
//            }
//            
//            
//            // text
//            NSString* amountString = @"";
//            if (totalAmount != 0) {
//                
//                if (totalAmountMax != 0) {
//                    
//                    amountString = [NSString stringWithFormat:@"%d - %d ", totalAmount, totalAmountMax];
//                }
//                else {
//                    
//                    amountString = [NSString stringWithFormat:@"%d ", totalAmount];
//                }
//            }
//            
//            UserShoppingEntry* firstEntry = [ingArray objectAtIndex:0];
//            NSString* entryText = firstEntry.text;
//            
//            NSString* text = [NSString stringWithFormat:@"%@%@", amountString, entryText];
//            // /text
//            
//            
//            NSDictionary* ingDict = @{
//                                      @"text":text,
//                                      @"entries":ingArray
//                                          };
//            [rowArray addObject:ingDict];
//        }
//
//        if (rowArray.count == 0) continue;
//        
//        
//        // section title
//        [sectionTitles addObject:category.title];
//
//        
//        [data addObject:rowArray];
//    }
//
//    _data = data;
//    _sectionTitles = sectionTitles;
//}



- (void) loadData {
    
    // populate ingredients dict with categories
    NSMutableDictionary* ingredientsDict = [NSMutableDictionary dictionary];

    NSArray* ingredientCategories = [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"IngredientCategory" withPredicate:nil sortedBy:@"number", nil];

    
    // IngredientCategories from RECIPES
    
    if (_mode != ShoppingIngredientsModeCustom) {


        for (IngredientCategory* category in ingredientCategories) {
        
            NSMutableDictionary* catDict = [NSMutableDictionary dictionary];
            [ingredientsDict setObject:catDict forKey:category.title];
            
            NSArray* ingredients = [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Ingredient" withPredicate:[NSPredicate predicateWithFormat:@"category == %@", category] sortedBy:@"number", nil];
            
            // Ingredients
            for (Ingredient* ingredient in ingredients) {
                
                if (ingredients.count == 0) continue;
                
                
                NSMutableArray* ingArray = [NSMutableArray array];
                [catDict setObject:ingArray forKey:[NSNumber numberWithInt:ingredient.number]];
                
                
                NSPredicate* predicate = nil;
                if (_mode == ShoppingIngredientsModeAll) {
                    
                    predicate = [NSPredicate predicateWithFormat:@"ingredientNumber == %d && recipe != nil", ingredient.number];
                }
                else if (_mode == ShoppingIngredientsModeRecipe) {
                    
                    predicate = [NSPredicate predicateWithFormat:@"recipe.number == %d AND ingredientNumber == %d && recipe != nil", recipe.number, ingredient.number];
                }
                
                NSArray* shoppingEntries = [[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserShoppingEntry" withPredicate:predicate sortedBy:@"recipe.number", nil];
                
                // UserShoppingEntries
                for (UserShoppingEntry* shoppingEntry in shoppingEntries) {
                    
//                    NSLog(@"************* LOAD DATA ************");
//                    
//                    NSLog(@"entry: %@", shoppingEntry.text);
//                    
//                    NSLog(@"************************************");
                    
                    //                Recipe* recipe = [[[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", shoppingEntry.recipe.number] sortedBy:nil] firstElement];
                    
                    //                IngredientEntry* entry = [[[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"IngredientEntry" withPredicate:[NSPredicate predicateWithFormat:@"recipe.number == %d AND number == %d", shoppingEntry.recipe.number, shoppingEntry.number] sortedBy:nil] firstElement];
                    
                    
                    
                    [ingArray addObject:shoppingEntry];
                }
            }
            
        }
    }
    

    NSMutableArray* data = [NSMutableArray array];
    NSMutableArray* sectionTitles = [NSMutableArray array];

    
    
    // Custom Entries
    
    if (_mode == ShoppingIngredientsModeAll || _mode == ShoppingIngredientsModeCustom) {

        NSArray* customEntries = [[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserShoppingEntry" withPredicate:[NSPredicate predicateWithFormat:@"recipe == nil"] sortedBy:@"number", nil];
    
        
        
        
        
        // insert custom entries first
        NSMutableArray* customRowArray = [NSMutableArray array];
        
        for (UserShoppingEntry* entry in customEntries) {
            
            NSDictionary* ingDict = @{
                                      @"text":entry.text,
                                      @"entries":@[entry],
                                      @"source":@"custom"
                                      };
            [customRowArray addObject:ingDict];
        }

        
        // if custom entries not empty
        
        if (customRowArray.count != 0) {

            [sectionTitles addObject:@"Selbst hinzugefügt"];
            
            [data addObject:customRowArray];
        }
    }
    
    
    
    // transfer arrays from ingredientsDict into data (sectioned)
    for (IngredientCategory* category in ingredientCategories) {
        
        NSDictionary* catDict = [ingredientsDict objectForKey:category.title];
        
        // output
        NSMutableArray* rowArray = [NSMutableArray array];
        
        NSArray* ingredients = [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Ingredient" withPredicate:[NSPredicate predicateWithFormat:@"category == %@", category] sortedBy:@"number", nil];
        
        // Ingredients
        for (Ingredient* ingredient in ingredients) {
            
            NSArray* ingArray = [catDict objectForKey:[NSNumber numberWithInt:ingredient.number]];
            
            if (ingArray.count == 0) continue;
            
            // creating sum
            float totalAmount = 0;
            float totalAmountMax = 0;
            
            for (UserShoppingEntry* shoppingEntry in ingArray) {
                
                if (shoppingEntry.amount != 0) {
                    
                    float ratio = (float)shoppingEntry.recipe.scale / shoppingEntry.recipe.baseScale;
                    
                    if (shoppingEntry.amountMax == 0) {

                        totalAmount += shoppingEntry.amount * ratio;
                        totalAmountMax += shoppingEntry.amount * ratio;
                    }
                    else {

                        totalAmount += shoppingEntry.amount * ratio;
                        totalAmountMax += shoppingEntry.amountMax * ratio;
                    }
                }
                
            }
            
            
            // text
            NSString* amountString = @"";
            if (totalAmount != 0) {
                
                if (totalAmountMax > totalAmount) {
                    
                    amountString = [NSString stringWithFormat:@"%@ - %@ ", [FloatFormatter stringForFloat:totalAmount], [FloatFormatter stringForFloat:totalAmountMax]];
                }
                else {
                    
                    amountString = [NSString stringWithFormat:@"%@ ", [FloatFormatter stringForFloat:totalAmount]];
                }
            }
            
            UserShoppingEntry* firstEntry = [ingArray objectAtIndex:0];
            NSString* entryText = firstEntry.text;
            
            NSString* text = [NSString stringWithFormat:@"%@%@", amountString, entryText];
            // /text
            
            
            NSDictionary* ingDict = @{
                                      @"text":text,
                                      @"entries":ingArray,
                                      @"source":@"recipe"
                                      };
            [rowArray addObject:ingDict];
        }
        
        if (rowArray.count == 0) continue;
        
        
        // section title
        [sectionTitles addObject:category.title];
        
        
        [data addObject:rowArray];
    }
    
//    NSLog(@"data: %@", data);
    
    _data = data;
    _sectionTitles = sectionTitles;
}


- (void) enterEditingMode {
    
    float netKBHeight = KEYBOARD_HEIGHT - TABBAR_HEIGHT;
    float newSBHeight = self.view.frame.size.height - netKBHeight;
    
    [self.tableView setFrameHeight:newSBHeight];
    
}


- (void) exitEditingMode {
    
    CGPoint currentContentOffset = self.tableView.contentOffset;
    float heightDiff = self.view.frame.size.height -  self.tableView.frame.size.height;
    CGPoint newContentOffset = CGPointMake(currentContentOffset.x, MAX(0.0, currentContentOffset.y - heightDiff));
    [self.tableView setFrameHeight:self.view.frame.size.height];
    [self.tableView setContentOffset:currentContentOffset animated:false];
    [self.tableView setContentOffset:newContentOffset animated:TRUE];
}


#pragma mark Delegate Methods

- (void) keyboardWillShow {
    
    NSLog(@"will show");
}


- (void) keyboardDidShow {
    
    NSLog(@"did show");
    
    [self enterEditingMode];
}


- (void) keyboardWillHide {
    
    NSLog(@"will hide");
    
    [self exitEditingMode];
}


- (void) keyboardDidHide {
    
    NSLog(@"did hide");
}


- (void) shoppingIngredientsCellDidBeginEditing:(ShoppingIngredientsCellEdit *)cell {
    
    _activeCell = cell;
}


- (void) shoppingIngredientsCellDidEndEditing:(ShoppingIngredientsCellEdit *)cell {
    
    _activeCell = nil;
}

@end
