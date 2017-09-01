//
//  ShoppingIngredientsViewController~ipad.m
//  Landmann
//
//  Created by Wang on 23.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "ShoppingIngredientsViewControllerIpad.h"
#import "ShoppingIngredientsCell.h"
#import "ShoppingIngredientsSectionHeader.h"
#import "CALayer+Extensions.h"
#import "FloatFormatter.h"
#import "EmptyCells.h"
#import "ShoppingRecipesViewController.h"



#define PERSONS_LABEL_TEXT @"für %d Personen"

#define BOTTOM_MARGIN 0
#define KEYBOARD_HEIGHT 352
#define KEYBOARD_DURATION 0.3
#define NAVBAR_HEIGHT 44
//#define TABBAR_HEIGHT 49

#define TABLEVIEW_WIDTH             342
#define TABLEVIEW_CELL_HEIGHT       64
#define TABLEVIEW_HEADER_HEIGHT     38




@implementation ShoppingIngredientsViewControllerIpad

@synthesize scrollView;
@synthesize contentView;
@synthesize recipe;
@synthesize personsView;
@synthesize personsLabel;


- (id) initWithMode:(ShoppingIngredientsMode) mode {
    
    if (self = [super initWithNibName:@"ShoppingIngredientsViewController" bundle:[NSBundle mainBundle]]) {
        
        _mode = mode;
        
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

    [self createTableViews];

    [self loadData];

//    [_leftTableView reloadData];
//    [_rightTableView reloadData];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,60)];
//    self.tableView.tableHeaderView.alpha = 0.0;
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
//    self.tableView.tableFooterView.alpha = 0.0;
//    self.tableView.clipsToBounds = false;
    
//    UIImage* overlay = [resource(@"Images.RecipeMenu.TableView.Overlay") resizableImageWithCapInsets:UIEdgeInsetsMake(60, 0, 30, 0) resizingMode:UIImageResizingModeStretch];
//    _overlayView = [[UIImageView alloc] initWithImage:overlay];
//    [_overlayView setFrameSize:CGSizeMake(320, self.tableView.contentSize.height)];
//    [_overlayView setFrameOrigin:CGPointMake(-16, 0)];
//    _overlayView.opaque = false;
    
    
//    [self.tableView addSubview:_overlayView];
//    self.tableView.autoresizesSubviews = true;
    
//    [titleLabel setFrameOrigin:CGPointMake(0, 20)]; // war 7
//    [self.tableView addSubview:titleLabel];
    
    
//    if (_mode == ShoppingIngredientsModeAll) {
//        
//        titleLabel.text = @"Alle Zutaten";
//    }
//    else if (_mode == ShoppingIngredientsModeCustom) {
//        
//        titleLabel.text = @"Selbst hinzugefügt";
//    }
//    else if (_mode == ShoppingIngredientsModeRecipe) {
//        
//        titleLabel.text = recipe.title;
//    }
    
    
    // persons cell layer mask
    
//    personsCell.layer.mask = [CALayer maskLayerWithSize:CGSizeMake(290, 40) roundedCornersTop:YES bottom:NO left:NO right:NO radius:4.0];
//    personsCell.layer.mask.frame = CGRectMake(0, 0, 290, 40);
//    personsCell.layer.masksToBounds = true;
    
    
    [self updatePersonsLabelWithScale:[[ContentDataManager instance] userRecipeForRecipe:recipe].scale];
    
    
    //    UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
    //    [self.view addGestureRecognizer:recognizer]; // blockiert edit controls
    
}


//- (void) viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    
//    [_leftTableView reloadData];
//    [_rightTableView reloadData];
//}


- (void) createTableViews {

    float posY = 0;
    
    if (_mode == ShoppingIngredientsModeRecipe) {
        
        [contentView addSubview:personsView];
        
        posY += personsView.frame.size.height;
    }
    
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, posY, TABLEVIEW_WIDTH, 10) style:UITableViewStylePlain];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.scrollEnabled = false;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:_leftTableView];

    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(TABLEVIEW_WIDTH + 2, posY, TABLEVIEW_WIDTH, 10) style:UITableViewStylePlain];
    _rightTableView.scrollEnabled = false;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:_rightTableView];

    UIImage* separator = [resource(@"Images.Shopping.IngredientsSeparator") resizableImageWithCapInsets:UIEdgeInsetsZero];
    _separator= [[UIImageView alloc] initWithImage:separator];
    [_separator setFrame:CGRectMake(TABLEVIEW_WIDTH, posY, 2, contentView.bounds.size.height - posY)];
    _separator.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [contentView addSubview:_separator];
}



#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
//    NSLog(@"frame: %@", NSStringFromCGRect(_leftTableView.frame));
//    NSLog(@"contentOffset: %@", NSStringFromCGPoint(_leftTableView.contentOffset));
//    NSLog(@"contentSize: %@", NSStringFromCGSize(_leftTableView.contentSize));
    
    if (tableView == _leftTableView && _leftData.count == 0)
        return 1;  // "empty" cell
    
    else {
        
        return (tableView == _leftTableView) ? _leftData.count : _rightData.count;
    }
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _leftTableView && section == 0 && _leftData.count == 0)
        return 1; // "empty" cell
    
    else {
        
        return (tableView == _leftTableView) ? [[_leftData objectAtIndex:section] count] : [[_rightData objectAtIndex:section] count];
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == _leftTableView && _leftData.count == 0 && section == 0) return 0;
    
    if (_mode == ShoppingIngredientsModeCustom && section == 0)
        return 0;
    else
        return TABLEVIEW_HEADER_HEIGHT;
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _leftTableView && _leftData.count == 0 && section == 0) return nil;
    
    if (_mode == ShoppingIngredientsModeCustom && section == 0)
        return nil;
    
    else {
        
        NSArray* titles = (tableView == _leftTableView) ? _leftSectionTitles : _rightSectionTitles;
        
        ShoppingIngredientsSectionHeader* header = [ShoppingIngredientsSectionHeader sectionHeader];
        header.titleLabel.text = [titles objectAtIndex:section];
        
        return header;
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return TABLEVIEW_CELL_HEIGHT;
}


- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _leftTableView && _leftData.count == 0) return false;
    
    else
        return true;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _leftTableView && _leftData.count == 0) {
        
        EmptyIngredientsCell* cell = [EmptyIngredientsCell cell];
//        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    uint section = indexPath.section;
    
    NSArray* sectionData = (tableView == _leftTableView) ? _leftData : _rightData;
    
    NSDictionary* data = [[sectionData objectAtIndex:section] objectAtIndex:indexPath.row];
    
    NSString* source = [data objectForKey:@"source"];
    
    
    ShoppingIngredientsCell* cell = nil;
    
    
    if (_mode == ShoppingIngredientsModeCustom && [source isEqualToString:@"custom"]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingIngredientsCellEdit"];
        
        if (!cell) {
            
            cell = [ShoppingIngredientsCellEdit cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        ((ShoppingIngredientsCellEdit*)cell).textView.text = [data objectForKey:@"text"];
        ((ShoppingIngredientsCellEdit*)cell).delegate = self;
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingIngredientsCell"];
        
        if (!cell) {
            
            cell = [ShoppingIngredientsCell cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.titleLabel.text = [data objectForKey:@"text"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.shoppingEntries = [data objectForKey:@"entries"];
    
    BOOL allChecked = true;
    for (UserShoppingEntry* shoppingEntry in cell.shoppingEntries) {
        if (!shoppingEntry.checked) {
            allChecked = false;
            break;
        }
    }
    
    cell.checkbox.selected = allChecked;
    
//    cell.backgroundColor = [UIColor clearColor];

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
        
//        uint leftNumberOfSections = _leftData.count;
//        uint rightNumberOfSections = _rightData.count;

        // delete all associated ShoppingEntries from database
        ShoppingIngredientsCell* cell = (ShoppingIngredientsCell*)[tableView cellForRowAtIndexPath:indexPath];
        [[ContentDataManager instance] deleteShoppingEntries:cell.shoppingEntries];

        [self loadData];
        
        [_leftTableView reloadData];
        [_rightTableView reloadData];
        

        // update left menu (potentially remove recipes from tableview)
        
        UIViewController* leftController = ((AppDelegateIpad*)[UIApplication sharedApplication].delegate).customNavigationController.leftNavigationController.topViewController;
        
        if ([leftController isKindOfClass:[ShoppingRecipesViewController class]]) {
            [(ShoppingRecipesViewController*)leftController refresh];
        }
        
        
        // der untere Dreck is viel zu heftig und zu anfällig für crashes als dass man den mal kurz auf die Schnell hinbekommt
        
        
        
        
        
        
        
        
        
//        [_leftTableView reloadSections:leftSections withRowAnimation:UITableViewRowAnimationFade];
//        [_rightTableView reloadSections:rightSections withRowAnimation:UITableViewRowAnimationFade];

        
        
//        uint numberOfSectionsBeforeDeletion = [self numberOfSectionsInTableView:tableView];
//        uint numberOfRowsBeforeDeletion = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        
        
//        // delete all associated ShoppingEntries from database
//        ShoppingIngredientsCell* cell = (ShoppingIngredientsCell*)[tableView cellForRowAtIndexPath:indexPath];
//        [[ContentDataManager instance] deleteShoppingEntries:cell.shoppingEntries];
//
//        
//        uint oldLeftCountLastSection = [[_leftData objectAtIndex:_leftData.count - 1] count];  // count of rows in LAST section
//        uint oldRightCountFirstSection = [[_rightData objectAtIndex:_rightData.count - 1] count];  // count of rows in FIRST section
////        uint oldLeftLastSectionIndex = _leftData.count - 1;
//        uint leftLastSectionIndexBeforeDeletion = _leftData.count - 1;
//        
//        uint relativeSectionIndexForDeletedRow;
//        if (tableView == _leftTableView) relativeSectionIndexForDeletedRow = indexPath.section;
//        else relativeSectionIndexForDeletedRow = indexPath.section - _leftData.count;
//        
//        BOOL shouldDeleteSection = ([tableView numberOfRowsInSection:indexPath.section] == 1);
//        
//        uint leftNumberOfSectionsBeforeDeletion = _leftData.count;
//        uint rightNumberOfSectionsBeforeDeletion = _rightData.count;
//  
//        uint leftLastRelativeSectionIndexBeforeDeletion = _leftData.count - 1;
//        uint rightFirstRelativeSectionIndexBeforeDeletion = leftLastRelativeSectionIndexBeforeDeletion + 1;
//        
//        
//        // -------------------------------- reloading data
//        [self loadData];
//
//        
//        uint leftNumberOfSectionsAfterDeletion = _leftData.count;
//        uint rightNumberOfSectionsAfterDeletion = _rightData.count;
//        
//        uint newLeftCountLastSection = [[_leftData objectAtIndex:_leftData.count - 1] count];  // count of rows in LAST section
//        uint newRightCountFirstSection = [[_rightData objectAtIndex:_rightData.count - 1] count];  // count of rows in FIRST section
//        
//        int diffCountLeftLastSection = newLeftCountLastSection - oldLeftCountLastSection;
//        int diffCountRightFirstSection = newRightCountFirstSection - oldRightCountFirstSection;
//
//        
//        NSLog(@"oldLeftCountLastSection: %d", oldLeftCountLastSection);
//        NSLog(@"newLeftCountLastSection: %d", newLeftCountLastSection);
//        
//        NSLog(@"oldRightCountFirstSection: %d", oldRightCountFirstSection);
//        NSLog(@"newRightCountFirstSection: %d", newRightCountFirstSection);
//
//        
//        // updates
//        
//        [_leftTableView beginUpdates];
//        [_rightTableView beginUpdates];
//        
//        
//        // 1 ----------------------------- delete actual row
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        if (shouldDeleteSection)
//            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//        
//        
//        // 2 -----------------------------
//        
//        NSLog(@"indexPath: %@", indexPath);
//        NSLog(@"should delete section: %d", shouldDeleteSection);
//        NSLog(@"LEFT number of sections BEFORE deletion: %d", leftNumberOfSectionsBeforeDeletion);
//        NSLog(@"RIGHT number of sections BEFORE deletion: %d", rightNumberOfSectionsBeforeDeletion);
//        NSLog(@"LEFT number of sections AFTER deletion: %d", leftNumberOfSectionsAfterDeletion);
//        NSLog(@"RIGHT number of sections AFTER deletion: %d", rightNumberOfSectionsAfterDeletion);
//        
//        // deleted / added sections
//        
//        // LEFT
//        
//        if (leftNumberOfSectionsAfterDeletion < leftNumberOfSectionsBeforeDeletion &&
//            !(shouldDeleteSection && tableView == _leftTableView)) {
//            
//            NSLog(@"LEFT: deleting last section");
//            
//            [_leftTableView deleteSections:[NSIndexSet indexSetWithIndex:leftLastRelativeSectionIndexBeforeDeletion] withRowAnimation:UITableViewRowAnimationFade];
//        }
//        else if (leftNumberOfSectionsAfterDeletion > leftNumberOfSectionsBeforeDeletion ||
//                 (shouldDeleteSection && tableView == _leftTableView)) {
//            
//            NSLog(@"LEFT: adding section at bottom");
//            
//            [_leftTableView insertSections:[NSIndexSet indexSetWithIndex:leftLastRelativeSectionIndexBeforeDeletion + 1] withRowAnimation:UITableViewRowAnimationFade];
//            
//            // insert rows of added section
//            uint sectionIndex = _leftData.count - 1;
//            uint numberOfAddedRows = [[_leftData objectAtIndex:sectionIndex] count];
//            
//            NSLog(@"LEFT: adding %d new rows in new section", numberOfAddedRows);
//            
//            for (uint i = 0; i < numberOfAddedRows; ++i) {
//                
//                [_leftTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:sectionIndex]] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        }
//        else if ([[_leftData objectAtIndex:leftLastSectionIndexBeforeDeletion] count] != oldLeftCountLastSection) {
//            
//            int diff = [[_leftData objectAtIndex:leftLastSectionIndexBeforeDeletion] count] - oldLeftCountLastSection;
//            
//            NSLog(@"LEFT: last section (%d) row difference: %d", leftLastSectionIndexBeforeDeletion, diff);
//            
//            if (diff > 0) {
//                
//                // append rows at bottom of section
//                
//                uint currentRowCount = [[_leftData objectAtIndex:leftLastSectionIndexBeforeDeletion] count];
//                
//                for (uint i = currentRowCount; i < currentRowCount + diff; ++i) {
//                    
//                    NSLog(@"LEFT: adding row in section (%d) at index: %d", leftLastSectionIndexBeforeDeletion, i);
//                    
//                    [_leftTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:leftLastSectionIndexBeforeDeletion]] withRowAnimation:UITableViewRowAnimationFade];
//                }
//            }
//            else if (diff < 0) {
//                
//                // delete rows at bottom of section
//                
//                uint currentRowCount = [[_leftData objectAtIndex:leftLastSectionIndexBeforeDeletion] count];
//                
//                for (uint i = currentRowCount + diff + 1; i > currentRowCount; --i) {
//                    
//                    NSLog(@"LEFT: deleting row in section (%d) at index: %d", leftLastSectionIndexBeforeDeletion, i);
//                    
//                    [_leftTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:leftLastSectionIndexBeforeDeletion]] withRowAnimation:UITableViewRowAnimationFade];
//                }
//            }
//        }
//
//        
//        // RIGHT
//        
//        if (rightNumberOfSectionsAfterDeletion < rightNumberOfSectionsBeforeDeletion &&
//            !(shouldDeleteSection && tableView == _rightTableView)) {
//            
//            NSLog(@"RIGHT: deleting first section");
//            
//            [_rightTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//        }
//        else if (rightNumberOfSectionsAfterDeletion > rightNumberOfSectionsBeforeDeletion ||
//                 (shouldDeleteSection && tableView == _rightTableView)) {
//            
//            NSLog(@"RIGHT: adding section at top");
//            
//            [_rightTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//
//            // insert rows of added section
//            uint sectionIndex = _rightData.count - 1;
//            uint numberOfAddedRows = [[_rightData objectAtIndex:sectionIndex] count];
//            
//            NSLog(@"RIGHT: adding %d new rows in new section", numberOfAddedRows);
//            
//            for (uint i = 0; i < numberOfAddedRows; ++i) {
//                
//                [_rightTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:sectionIndex]] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        }
//        else if ([[_rightData objectAtIndex:0] count] != oldRightCountFirstSection) {
//            
//            int diff = [[_rightData objectAtIndex:0] count] - oldRightCountFirstSection;
//            
//            NSLog(@"RIGHT: first section (0) row difference: %d", diff);
//            
//            if (diff > 0) {
//                
//                // append rows at top of section
//                
////                uint currentRowCount = [[_rightData objectAtIndex:0] count];
//                
//                for (uint i = 0; i < diff; ++i) {
//                    
//                    NSLog(@"RIGHT: adding row in section (0) at index: 0");
//                    
//                    [_rightTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//                }
//            }
//            else if (diff < 0) {
//                
//                // delete rows at bottom of section
//                
////                uint currentRowCount = [[_rightData objectAtIndex:0] count];
//                
//                for (uint i = 0; i < -diff; ++i) {
//                    
//                    NSLog(@"RIGHT: deleting row in section (0) at index: 0");
//                    
//                    [_leftTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:leftLastSectionIndexBeforeDeletion]] withRowAnimation:UITableViewRowAnimationFade];
//                }
//            }
//
//        }
//
//        
//        
//        // -------------------- end updates
//        
//        [_leftTableView endUpdates];
//        [_rightTableView endUpdates];
        
        
//        // left
//        
//        NSLog(@"left tableview");
//        
//        [_leftTableView beginUpdates];
//        
//        // delete actual row
//        if (tableView == _leftTableView) {
//            [_leftTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [self deleteEmptySectionWithIndex:indexPath.section inTableView:_leftTableView forData:_leftData];
//        }
//        
//        // added rows (through layout strategy)
//        if (diffCountLeftLastSection > 0) {
//            
//            uint sectionIndex = oldLeftLastSectionIndex;
//            NSMutableArray* addedIndexPaths = [NSMutableArray array];
//            
//            for (uint i = 0; i < diffCountLeftLastSection; ++i) {
//                [addedIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:sectionIndex]];
//            }
//            
//            [_leftTableView insertRowsAtIndexPaths:addedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//            
//            [self deleteEmptySectionWithIndex:sectionIndex inTableView:_leftTableView forData:_leftData];
//        }
//        
//        // deleted rows (throught layout stragety)
//        else if (diffCountLeftLastSection < 0) {
//
//            uint sectionIndex = oldLeftLastSectionIndex;
//            NSMutableArray* deletedIndexPaths = [NSMutableArray array];
//            uint lastRowIndex = [[_leftData objectAtIndex:sectionIndex] count] - 1;
//            
//            for (uint i = lastRowIndex; i > lastRowIndex + diffCountLeftLastSection; --i) {
//                [deletedIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:sectionIndex]];
//            }
//            
//            [_leftTableView deleteRowsAtIndexPaths:deletedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//            
//            [self deleteEmptySectionWithIndex:sectionIndex inTableView:_leftTableView forData:_leftData];
//        }
//        
//        [_leftTableView endUpdates];
//
//        
//        
//        // right
//        
//        NSLog(@"right tableview");
//        
//        [_rightTableView beginUpdates];
//        
//        // delete actual row
//        if (tableView == _rightTableView) {
//            [_rightTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [self deleteEmptySectionWithIndex:indexPath.section inTableView:_rightTableView forData:_rightData];
//        }
//        
//        // added rows (through layout strategy)
//        if (diffCountLeftLastSection > 0) {
//            
//            uint sectionIndex = 0;
//            NSMutableArray* addedIndexPaths = [NSMutableArray array];
//            
//            for (uint i = 0; i < diffCountLeftLastSection; ++i) {
//                [addedIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:sectionIndex]];
//            }
//            
//            [_rightTableView insertRowsAtIndexPaths:addedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//
//            [self deleteEmptySectionWithIndex:sectionIndex inTableView:_rightTableView forData:_rightData];
//        }
//        
//        // deleted rows (throught layout stragety)
//        else if (diffCountLeftLastSection < 0) {
//            
//            uint sectionIndex = 0;
//            NSMutableArray* deletedIndexPaths = [NSMutableArray array];
//            
//            for (uint i = 0; i < -diffCountLeftLastSection; ++i) {
//                [deletedIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:sectionIndex]];
//            }
//            
//            [_rightTableView deleteRowsAtIndexPaths:deletedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//
//            [self deleteEmptySectionWithIndex:sectionIndex inTableView:_rightTableView forData:_rightData];
//        }
//        
//        [_rightTableView endUpdates];
    }
}


- (void) deleteEmptySectionWithIndex:(uint) sectionIndex inTableView:(UITableView*) tableView forData:(NSArray*) data {
    
    if (sectionIndex != data.count - 1) {
        
        for (uint i = sectionIndex; i >= data.count; ++i) {
        
            NSLog(@"deleting section: %d", sectionIndex);
            
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


- (NSString*) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"löschen";
}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}


- (IBAction) actionIncreaseScale {
    
    uint newScale = [[ContentDataManager instance] increaseScaleForRecipe:recipe];
    
    [self loadData];
    [_leftTableView reloadData];
    [_rightTableView reloadData];
    [self updatePersonsLabelWithScale:newScale];
}


- (IBAction) actiondecreaseScale {
    
    uint newScale = [[ContentDataManager instance] decreaseScaleForRecipe:recipe];
    
    [self loadData];
    [_leftTableView reloadData];
    [_rightTableView reloadData];
    [self updatePersonsLabelWithScale:newScale];
}


- (void) updatePersonsLabelWithScale:(uint) scale {
    
    personsLabel.text = [NSString stringWithFormat:PERSONS_LABEL_TEXT, scale];
}



- (IBAction) actionToggleEdit:(UIButton*) sender {
    
    NSLog(@"toggle edit");
    
    _editing = !_editing;
    
    sender.selected = _editing;
    
    [_leftTableView setEditing:_editing animated:true];
    [_rightTableView setEditing:_editing animated:true];
}


- (IBAction) actionAddRow {
    
    if (_mode == ShoppingIngredientsModeCustom) {
        
        uint numberOfSectionsBeforeInsertion = [self numberOfSectionsInTableView:_leftTableView];
        
        uint numberOfRowsBeforeInsertion;
        
        if (numberOfSectionsBeforeInsertion == 0) numberOfRowsBeforeInsertion = 0;
        else if (_leftData.count == 0) numberOfRowsBeforeInsertion = 0;
        else numberOfRowsBeforeInsertion = [self tableView:_leftTableView numberOfRowsInSection:0];
        
        uint dataCountBeforeInsertion = _leftData.count;
        
        NSLog(@"add row");
        
        UserShoppingEntry* entry = [[ContentDataManager instance] insertCustomShoppingEntry];
        
        NSLog(@"number: %d", entry.number);
        
        [self loadData];
        
        NSIndexPath* insertedPath = [NSIndexPath indexPathForItem:numberOfRowsBeforeInsertion inSection:0];
        
        
        [_leftTableView beginUpdates];
        
        if (numberOfSectionsBeforeInsertion == 0) {
            
            [_leftTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        if (dataCountBeforeInsertion == 0) {
            
            [_leftTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_leftTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            
            [_leftTableView insertRowsAtIndexPaths:@[insertedPath] withRowAnimation:UITableViewRowAnimationFade];
            
            // overlay resize animation
            
            float newContentHeight = _leftTableView.contentSize.height + [self tableView:_leftTableView heightForRowAtIndexPath:insertedPath];
            if (numberOfSectionsBeforeInsertion == 0) newContentHeight += [self tableView:_leftTableView heightForHeaderInSection:0];
            
            NSLog(@"heightforrow: %f", [self tableView:_leftTableView heightForRowAtIndexPath:insertedPath]);
            
            [UIView animateWithDuration:0.3 animations:^(void) {
                [_overlayView setFrameHeight:newContentHeight];
            }];
            
            
            // reload cells above
            
            for (uint r = 0; r < numberOfRowsBeforeInsertion; ++r) {
                
                [_leftTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:r inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        
        [_leftTableView endUpdates];
        
        
        [_leftTableView scrollToRowAtIndexPath:insertedPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
}




- (void) actionTap {
    
    NSLog(@"content tap");
    
    [_activeCell resign];
}


- (void) enterEditingMode {
    
    float netKBHeight = KEYBOARD_HEIGHT;
    float newSBHeight = self.view.frame.size.height - netKBHeight;
    
    [scrollView setFrameHeight:newSBHeight];
    
    [scrollView scrollRectToVisible:_activeCell.frame animated:true];
}


- (void) exitEditingMode {

    CGPoint currentContentOffset = scrollView.contentOffset;
    float heightDiff = self.view.frame.size.height -  scrollView.frame.size.height;
    CGPoint newContentOffset = CGPointMake(currentContentOffset.x, MAX(0.0, currentContentOffset.y - heightDiff));
//    [_leftTableView setFrameHeight:self.view.frame.size.height];
//    [_leftTableView setContentOffset:currentContentOffset animated:false];
//    [_leftTableView setContentOffset:newContentOffset animated:TRUE];
//    [_rightTableView setFrameHeight:self.view.frame.size.height];
//    [_rightTableView setContentOffset:currentContentOffset animated:false];
//    [_rightTableView setContentOffset:newContentOffset animated:TRUE];

    [scrollView setFrameHeight:self.view.frame.size.height];
    [scrollView setContentOffset:currentContentOffset animated:false];
    [scrollView setContentOffset:newContentOffset animated:true];
    
}



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

    
    
    
    // Split data into left and right arrays. Split by full sections.
    
    NSMutableArray* leftData = [NSMutableArray array];
    NSMutableArray* rightData = [NSMutableArray array];
    NSMutableArray* leftSectionTitles = [NSMutableArray array];
    NSMutableArray* rightSectionTitles = [NSMutableArray array];
    
    enum {Left, Right} side = Left;
    enum {TryNoScrolling, DistributeEvenly, SplitSections} strategy = TryNoScrolling;
    uint counter = 0;
//    float availableHeight = contentView.bounds.size.height;  // height without scrolling
    float availableHeight = scrollView.frame.size.height - 44;  // HACK
    float currentHeight = 0;
    float maximumHeight = TABLEVIEW_CELL_HEIGHT;
    
    // iterate sections
    for (NSArray* rowArray in data) {

        float sectionHeight = TABLEVIEW_HEADER_HEIGHT + (TABLEVIEW_CELL_HEIGHT * rowArray.count);
        NSLog(@"(%d) Height for section '%@': %f (currentHeight: %f)", counter, [sectionTitles objectAtIndex:counter], sectionHeight, currentHeight);
        
        // check if currentHeight + current section height would be too large for availableHeight on LEFT side
        // if the first section is already too large -> HAVE to use scrolling
        if (side == Left && counter > 0 && currentHeight + sectionHeight > availableHeight) {
            
            // switch side and add section to right side
            side = Right;
            currentHeight = 0;
            NSLog(@"SWITCHING SIDE");
        }
        // check if section is too large to fit into right side
        // if true --> CHANGE STRATEGY
        else if (side == Right && currentHeight + sectionHeight > availableHeight) {
            
//            strategy = DistributeEvenly;
            strategy = SplitSections;
            NSLog(@"SWITCHING STRATEGY");
            break;
        }
        
        if (side == Left) {
            [leftData addObject:rowArray];
            [leftSectionTitles addObject:[sectionTitles objectAtIndex:counter]];
        }
        else {
            [rightData addObject:rowArray];
            [rightSectionTitles addObject:[sectionTitles objectAtIndex:counter]];
        }

        currentHeight += sectionHeight;
        maximumHeight = MAX(maximumHeight, currentHeight);
        
        NSLog(@"added to side: %d", side);
        
        ++counter;
    }

    // if 1st strategy did not work -> empty data and use 2nd strategy
    if (strategy == DistributeEvenly) {
        
        NSLog(@"THIS IS 2ND STRATEGY");
        
        [@[leftData, rightData, leftSectionTitles, rightSectionTitles] makeObjectsPerformSelector:@selector(removeAllObjects)];

        float totalHeight = 0;
        counter = 0;
        
        // iterate sections to calculate TOTAL HEIGHT
        for (NSArray* rowArray in data) {

            float sectionHeight = TABLEVIEW_HEADER_HEIGHT + (TABLEVIEW_CELL_HEIGHT * rowArray.count);
            totalHeight += sectionHeight;
        }

        NSLog(@"totalHeight: %f", totalHeight);
        
        counter = 0;
        side = Left;
        currentHeight = 0;
        maximumHeight = TABLEVIEW_CELL_HEIGHT;
        BOOL oneMore = false;
        
        // iterate sections
        for (NSArray* rowArray in data) {
            
            float sectionHeight = TABLEVIEW_HEADER_HEIGHT + (TABLEVIEW_CELL_HEIGHT * rowArray.count);
            NSLog(@"(%d) Height for section '%@': %f (currentHeight: %f)", counter, [sectionTitles objectAtIndex:counter], sectionHeight, currentHeight);
            
            if (side == Left && currentHeight + sectionHeight > totalHeight * 0.5) {
                
                float height2 = totalHeight - currentHeight - sectionHeight; // right side height to decide which is smaller
                
                if (currentHeight <= height2) {
                    oneMore = true;  // initiate side switch but add currect section to left side
                }
                else {
                    // switch immediately
                    side = Right;
                    currentHeight = 0;
                    NSLog(@"SWITCHING SIDE");
                }
            }
            
            if (side == Left) {
                [leftData addObject:rowArray];
                [leftSectionTitles addObject:[sectionTitles objectAtIndex:counter]];
            }
            else {
                [rightData addObject:rowArray];
                [rightSectionTitles addObject:[sectionTitles objectAtIndex:counter]];
            }
            
            currentHeight += sectionHeight;
            maximumHeight = MAX(maximumHeight, currentHeight);
            
            NSLog(@"added to side: %d", side);

            
            // pending side switch
            if (oneMore) {
                oneMore = false;
                side = Right;
                currentHeight = 0;
                NSLog(@"SWITCHING SIDE");
            }
            
            ++counter;
        }
    }
    
    // SplitSections
    
    else if (strategy == SplitSections) {
        
        NSLog(@"THIS IS 2ND STRATEGY (SplitSections)");
        
        [@[leftData, rightData, leftSectionTitles, rightSectionTitles] makeObjectsPerformSelector:@selector(removeAllObjects)];
        
        float totalHeight = 0;
        counter = 0;
        
        // iterate sections to calculate TOTAL HEIGHT
        for (NSArray* rowArray in data) {
            
            float sectionHeight = TABLEVIEW_HEADER_HEIGHT + (TABLEVIEW_CELL_HEIGHT * rowArray.count);
            totalHeight += sectionHeight;
        }
        
        NSLog(@"totalHeight: %f", totalHeight);
        
        counter = 0;
        side = Left;
        currentHeight = 0;
        maximumHeight = TABLEVIEW_CELL_HEIGHT;
        BOOL oneMore = false;
        
        // iterate sections
        for (NSArray* rowArray in data) {
            
            float sectionHeight = TABLEVIEW_HEADER_HEIGHT + (TABLEVIEW_CELL_HEIGHT * rowArray.count);
            NSLog(@"(%d) Height for section '%@': %f (currentHeight: %f)", counter, [sectionTitles objectAtIndex:counter], sectionHeight, currentHeight);
            
            if (side == Left && currentHeight + sectionHeight > totalHeight * 0.5) {

                // split rowArray into 2 arrays
                
                float height2 = totalHeight - currentHeight - sectionHeight; // right side height to decide which is smaller
                
                float diff = (currentHeight + sectionHeight) - height2;
//                int numberOfRowsForDiffLeft = (currentHeight + diff - totalHeight * 0.5) / TABLEVIEW_CELL_HEIGHT;
                int numberOfRowsForDiffLeft = (diff * 0.5) / TABLEVIEW_CELL_HEIGHT;
                
                NSLog(@"diff: %f", diff);
                
                if (numberOfRowsForDiffLeft == 0) { // all rows fit on left side
                    
                    // just add current section to left side without splitting
                }
                else if (numberOfRowsForDiffLeft >= rowArray.count) { // all rows fit on right side
                    
                    // just add current section to right side without splitting
                    
                    side = Right;
                    currentHeight = 0;
                }

                else {
                    
                    uint leftRows = rowArray.count - numberOfRowsForDiffLeft;
                    
                    if (leftRows == 0) leftRows = 1;  // at least one row on left side
                    
                    NSMutableArray* leftArray = [NSMutableArray array];
                    NSMutableArray* rightArray = [NSMutableArray array];
                    
                    uint i = 0;
                    
                    for (; i < leftRows; ++i) {
                        [leftArray addObject:[rowArray objectAtIndex:i]];
                    }
                    for (; i < rowArray.count; ++i) {
                        [rightArray addObject:[rowArray objectAtIndex:i]];
                    }

//                    for (NSDictionary* dict in leftArray) {
//                        [leftData addObject:dict];
//                    }
//                    for (NSDictionary* dict in rightArray) {
//                        [leftData addObject:dict];
//                    }

                    [leftData addObject:leftArray];
                    [leftSectionTitles addObject:[sectionTitles objectAtIndex:counter]];

                    if (rightArray.count > 0) {
                        [rightData addObject:rightArray];
                        [rightSectionTitles addObject:[sectionTitles objectAtIndex:counter]];
                    }
                    
                    side = Right;
                    float leftHeight = currentHeight + TABLEVIEW_HEADER_HEIGHT + (TABLEVIEW_CELL_HEIGHT * leftArray.count);
                    currentHeight = TABLEVIEW_HEADER_HEIGHT + (TABLEVIEW_CELL_HEIGHT * rightArray.count);
                    maximumHeight = MAX(maximumHeight, MAX(currentHeight, leftHeight));
                    
                    NSLog(@"SPLITTING");
                    
                    ++counter;
                    continue; // next loop
                }
                
                
//
//                if (currentHeight <= height2) {
//                    oneMore = true;  // initiate side switch but add currect section to left side
//                }
//                else {
//                    // switch immediately
//                    side = Right;
//                    currentHeight = 0;
//                    NSLog(@"SWITCHING SIDE");
//                }
            }
            
            if (side == Left) {
                [leftData addObject:rowArray];
                [leftSectionTitles addObject:[sectionTitles objectAtIndex:counter]];
            }
            else {
                [rightData addObject:rowArray];
                [rightSectionTitles addObject:[sectionTitles objectAtIndex:counter]];
            }
            
            currentHeight += sectionHeight;
            maximumHeight = MAX(maximumHeight, currentHeight);
            
            NSLog(@"added to side: %d", side);
            
            
//            // pending side switch
//            if (oneMore) {
//                oneMore = false;
//                side = Right;
//                currentHeight = 0;
//                NSLog(@"SWITCHING SIDE");
//            }
            
            ++counter;
        }
    }
    
    _leftData = leftData;
    _rightData = rightData;
    _leftSectionTitles = leftSectionTitles;
    _rightSectionTitles = rightSectionTitles;
    
    
    // resize tableviews and contentview
    
    [_leftTableView setFrameHeight:maximumHeight];
    [_rightTableView setFrameHeight:maximumHeight];
    
    float personsHeight = (_mode == ShoppingIngredientsModeRecipe) ? personsView.frame.size.height : 0;
    
    NSLog(@"HEIGHTS: %f, %f", maximumHeight, scrollView.frame.size.height);
    
    [contentView setFrameHeight:MAX(maximumHeight, scrollView.frame.size.height)];
    [scrollView setContentSize:contentView.bounds.size];
//    [_separator setFrameHeight:contentView.frame.size.height - personsHeight];
}


- (void) deleteDataAtIndexPath:(NSIndexPath*) indexPath inTableView:(UITableView*) tableView {
    
    NSMutableArray* data = [NSMutableArray arrayWithArray:(tableView == _leftTableView) ? _leftData : _rightData];
    NSMutableArray* sectionTitles = [NSMutableArray arrayWithArray:(tableView == _leftTableView) ? _leftSectionTitles : _rightSectionTitles];
    
    NSMutableArray* sectionArray = [NSMutableArray arrayWithArray:[data objectAtIndex:indexPath.section]];
    [sectionArray removeObjectAtIndex:indexPath.row];
    
    if (sectionArray.count == 0) {
        [data removeObjectAtIndex:indexPath.section];
        [sectionTitles removeObjectAtIndex:indexPath.section];
    }
    
    if (tableView == _leftTableView) {
        
        _leftData = data;
        _leftSectionTitles = sectionTitles;
    }
    else {
        
        _rightData = data;
        _rightSectionTitles = sectionTitles;
    }
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
