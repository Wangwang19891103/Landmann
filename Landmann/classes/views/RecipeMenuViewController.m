//
//  RecipeMenuViewController.m
//  Landmann
//
//  Created by Wang on 15.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeMenuViewController.h"
#import "RecipeMenuCell.h"
#import "RecipeDetailsViewController.h"
#import "CALayer+Extensions.h"
#import "EmptyCells.h"
#import "NavigationBarImageCreator.h"


#define EMPTY_CELL_TEXT_FAVORITE @"Keine Favoriten\nNoch kein Rezept ausgewählt"
#define EMPTY_CELL_TEXT_RECIPE @"Kein Rezept\nfür diese Schwierigkeitsstufe"
#define EMPTY_CELL_TEXT_SEARCH @"Kein Suchergebnis"


@implementation RecipeMenuViewController


@synthesize tableView;
@synthesize buttonsView;
@synthesize buttons;
@synthesize preselectedRecipe;


- (id) initWithCategory:(NSString*) category {
    
    if (self = [super initWithNibName:@"RecipeMenuViewController" bundle:[NSBundle mainBundle]]) {
        
        _category = [category copy];
        _difficulty = RecipeDifficultyAll;
        _selectedIndexPath = nil;

//        [self.navigationItem setTitle:category];
        UIImage* navImage = [NavigationBarImageCreator createImageWithString:category];
        [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:navImage]];
        
        [self loadDataForCategory:category];
        
        _loadDataSelector = @selector(loadDataForCategory:);
        _loadDataObject = [category copy];
        _showButtons = true;
    }
    
    return self;
}


- (id) initWithKeywords:(NSArray *)keywords {
    
    if (self = [super initWithNibName:@"RecipeMenuViewController" bundle:[NSBundle mainBundle]]) {
        
        _keywords = keywords;
        _difficulty = RecipeDifficultyAll;
        _selectedIndexPath = nil;
        
//        [self.navigationItem setTitle:[NSString stringWithFormat:@"Suche: %@", [keywords componentsJoinedByString:@" "]]];
        UIImage* navImage = [NavigationBarImageCreator createImageWithString:[NSString stringWithFormat:@"Suche: %@", [keywords componentsJoinedByString:@" "]]];
        [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:navImage]];
        
        [self loadDataForKeywords:keywords];
        
        _loadDataSelector = @selector(loadDataForKeywords:);
        _loadDataObject = keywords;
        _showButtons = true;
    }
    
    return self;
}


- (id) initWithRecommendations {
    
    if (self = [super initWithNibName:@"RecipeMenuViewController" bundle:[NSBundle mainBundle]]) {
        
        _difficulty = RecipeDifficultyAll;
        _selectedIndexPath = nil;
        
//        [self.navigationItem setTitle:@"Empfehlungen"];
        UIImage* navImage = [NavigationBarImageCreator createImageWithString:@"Empfehlungen"];
        [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:navImage]];
        
        NSArray* recipes = resource(@"Dictionaries.Arrays.RecommendedRecipes");
        
        [self loadDataForRecipes:recipes];
        
        _loadDataSelector = @selector(loadDataForRecipes:);
        _loadDataObject = recipes;
        _showButtons = false;
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
    
    UIImage* overlay = [resource(@"Images.RecipeMenu.TableView.Overlay") resizableImageWithCapInsets:UIEdgeInsetsMake(60, 0, 30, 0) resizingMode:UIImageResizingModeStretch];
    _overlayView = [[UIImageView alloc] initWithImage:overlay];
    [_overlayView setFrameSize:self.tableView.contentSize];
//    _overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _overlayView.opaque = false;
//    self.tableView.autoresizesSubviews = true;
    

    
    [self.tableView addSubview:_overlayView];
    
    if (_showButtons) {
        
        [self.tableView addSubview:buttonsView];
        [buttonsView setFrameY:13];
    }
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _didDisappear = true;
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    // IDIOM
    
    if (!_didDisappear && is_ipad) {
        if ([[_sectionData objectAtIndex:0] count] > 0) {  // PROBLEM Favoriten empty
            
            NSIndexPath* selectedIndexPath;
            
            if (preselectedRecipe) {
                selectedIndexPath = [self indexPathForRecipe:preselectedRecipe];
            }
            else {
                selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            }
            
            Recipe* recipe = [[_sectionData objectAtIndex:selectedIndexPath.section] objectAtIndex:selectedIndexPath.row];
            RecipeDetailsViewController* detailViewController = [[RecipeDetailsViewController alloc] initWithRecipe:recipe];
            [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.rightNavigationController pushViewController:detailViewController animated:false];
            
            // selection
            [tableView selectRowAtIndexPath:selectedIndexPath animated:true scrollPosition:UITableViewScrollPositionNone];
        }
    }

    // TEST
    
    if (_didDisappear && !is_ipad) {  // for favorites?
        [self performSelector:_loadDataSelector withObject:_loadDataObject];
        [self.tableView reloadData];
        [_overlayView setFrameSize:CGSizeMake(320, self.tableView.contentSize.height)];
    }
    
    _didDisappear = false;

}



#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionData.count;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 && [[_sectionData objectAtIndex:0] count] == 0) return 1;
    
    return [(NSArray*)[_sectionData objectAtIndex:section] count];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 73;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 2;
    }
    else {
        
        return 0;
    }
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {

        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
        headerView.backgroundColor = [UIColor clearColor];
        UIImage* image = [resource(@"Images.RecipeMenu.SectionSeparator") resizableImageWithCapInsets:UIEdgeInsetsZero];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrameSize:CGSizeMake(290, 2)];
        [imageView setFrameX:16];
        [headerView addSubview:imageView];
        return headerView;
    }
    else {
        
        return nil;
    }
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_overlayView setFrameHeight:self.tableView.contentSize.height];
    
    
    if (indexPath.section == 0 && indexPath.row == 0 && [[_sectionData objectAtIndex:0] count] == 0) {
        
        EmptyRecipeCell* cell = [EmptyRecipeCell cell];
        
        if ([_category isEqualToString:@"Favoriten"]) {
        
            cell.titleLabel.text = EMPTY_CELL_TEXT_FAVORITE;
        }
        else if (_keywords) {
            
            cell.titleLabel.text = EMPTY_CELL_TEXT_SEARCH;
        }
        else {
            
            cell.titleLabel.text = EMPTY_CELL_TEXT_RECIPE;
        }
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    RecipeMenuCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"RecipeMenuCell"];
    
    if (!cell) {
        
        cell = [RecipeMenuCell cell];
        
        BOOL top = (indexPath.row == 0);
        BOOL bottom = (indexPath.row == [self.tableView numberOfRowsInSection:0]);
        
        cell.layer.mask = [CALayer maskLayerWithSize:CGSizeMake(290, 73) roundedCornersTop:top bottom:bottom left:NO right:NO radius:4.0];
        cell.layer.mask.frame = CGRectMake(16, 0, 290, 73);
        cell.layer.masksToBounds = true;

    }
    
    Recipe* recipe = [[_sectionData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    NSLog(@"cellForRow (title: %@)", recipe.title);
    
    cell.titleLabel.text = recipe.title;
    
    NSLog(@"imageName: %@", recipe.imageThumb);

    NSString* fileName = [NSString stringWithFormat:@"_%@_thumb.jpg", [recipe.imageFull stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSString* imagePath = [RECIPE_IMAGES_THUMB_IPHONE stringByAppendingPathComponent:fileName];
    NSString* fullPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
    UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
    
    cell.image.image = image;
    
    [cell setDifficulty:recipe.difficulty];

    if (_difficulty != RecipeDifficultyAll && indexPath.section == 0) {
        [cell setRed:true];
    }
    
    NSLog(@"image: %@", image);
    
    return cell;
}



#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 0 && [[_sectionData objectAtIndex:0] count] == 0) {
        return;
    }

    
    RecipeMenuCell* cell = (RecipeMenuCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelected:true];

    Recipe* recipe = [[_sectionData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIViewController* controller = [[RecipeDetailsViewController alloc] initWithRecipe:recipe];

    _selectedIndexPath = indexPath;

    // IDIOM

    if (is_ipad) {
        
        preselectedRecipe = recipe;
        
        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.rightNavigationController popViewControllerAnimated:false];
        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.rightNavigationController pushViewController:controller animated:false];
    }
    else {
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
    
//    [self performSelector:@selector(deselectCell:) withObject:cell afterDelay:TABLEVIEW_CELL_DESELECTION_DELAY];
}


- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"rect: %@", NSStringFromCGRect(cell.frame));
    
    [cell setFrameX:16];

    NSLog(@"rect after: %@", NSStringFromCGRect(cell.frame));
}



#pragma mark Private Methods


//- (void) deselectCell:(UITableViewCell*) cell {
//    
//    [cell setSelected:false];
//}

//- (void) deselectCell {
//
//    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
//    [cell setSelected:false];
//    [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//    _selectedIndexPath = nil;
//
//}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}


- (void) loadDataForCategory:(NSString*) category {
    
    NSMutableArray* sectionData = [NSMutableArray array];
    
    if (_difficulty == RecipeDifficultyAll) {
    
        if ([category isEqualToString:@"Favoriten"]) {

            [sectionData addObject:[[ContentDataManager instance] recipesWithFavoritesForDifficulty:_difficulty]];
        }
        else {
            
            [sectionData addObject:[[ContentDataManager instance] recipesForCategory:category difficulty:_difficulty]];
        }
    }
    else {
        
        // split into 2 sections

        if ([category isEqualToString:@"Favoriten"]) {
            
            [sectionData addObject:[[ContentDataManager instance] recipesWithFavoritesForDifficulty:_difficulty]];
        }
        else {
            
            [sectionData addObject:[[ContentDataManager instance] recipesForCategory:category difficulty:_difficulty]];
        }
        
        NSMutableArray* subData = [NSMutableArray array];
        
        for (uint diff = 1; diff <= 4; ++diff) {
            
            if (diff == _difficulty) continue;
            
            NSArray* recipes = nil;
            
            if ([category isEqualToString:@"Favoriten"]) {
                
                recipes = [[ContentDataManager instance] recipesWithFavoritesForDifficulty:diff];
            }
            else {
            
                recipes = [[ContentDataManager instance] recipesForCategory:category difficulty:diff];
            }
            
            for (Recipe* recipe in recipes) {
                
                [subData addObject:recipe];
            }
        }
        
        [sectionData addObject:subData];
    }
    
    _sectionData = sectionData;
}


- (void) loadDataForKeywords:(NSArray*) keywords {
    
    NSMutableArray* sectionData = [NSMutableArray array];
    
    if (_difficulty == RecipeDifficultyAll) {
        
        [sectionData addObject:[[ContentDataManager instance] recipesForKeywords:keywords withDiffculty:_difficulty]];
    }
    else {
        
        // split into 2 sections
        [sectionData addObject:[[ContentDataManager instance] recipesForKeywords:keywords withDiffculty:_difficulty]];

        // 2. section
        
        NSMutableArray* subData = [NSMutableArray array];
        
        for (uint diff = 1; diff <= 4; ++diff) {
            
            if (diff == _difficulty) continue;
            
            NSArray* recipes = [[ContentDataManager instance] recipesForKeywords:keywords withDiffculty:diff];
            
            for (Recipe* recipe in recipes) {
                
                [subData addObject:recipe];
            }
        }
        
        [sectionData addObject:subData];
    }
    
    _sectionData = sectionData;
}


- (void) loadDataForRecipes:(NSArray*) recipes {
    
    NSMutableArray* sectionData = [NSMutableArray array];

    NSMutableArray* subData = [NSMutableArray array];

    for (NSNumber* number in recipes) {
        
        Recipe* recipe = [[ContentDataManager instance] recipeWithNumber:[number intValue]];
        [subData addObject:recipe];
    }
    
    [sectionData addObject:subData];
    
    _sectionData = sectionData;
}


- (NSIndexPath*) indexPathForRecipe:(Recipe*) recipe {
    
    uint sectionIndex = 0;
    uint rowIndex = 0;
    BOOL found = false;
    
    for (NSArray* rowArray in _sectionData) {
        
        for (Recipe* recipe1 in rowArray) {
            
            if (recipe == recipe1) {
                
                found = true;
                break;
            }
            
            
            ++rowIndex;
        }

        if (found) break;

        ++sectionIndex;
        rowIndex = 0;
    }
    
    if (found) return [NSIndexPath indexPathForItem:rowIndex inSection:sectionIndex];
    else return [NSIndexPath indexPathForItem:0 inSection:0];
}



#pragma mark Actions

- (IBAction) actionHat:(id)sender {
    
    [self deselectAllButtonsExcept:sender];
    [self toggleButton:sender];
}


- (void) deselectAllButtonsExcept:(UIButton*) button2 {
    
    for (UIButton* button in self.buttons) {
        
        if (button != button2) {
            
            [button setSelected:false];
        }
    }
}


- (void) toggleButton:(UIButton*) button {
    
    [button setSelected:!button.selected];

    if (button.selected) {
        
        _difficulty = button.tag - 1000;
    }
    else {
        
        _difficulty = RecipeDifficultyAll;
    }
    
    NSLog(@"set difficulty to: %d", _difficulty);
    
//    [self loadData];
    [self performSelector:_loadDataSelector withObject:_loadDataObject];
    [self.tableView reloadData];
    
    
    // handle selection (ipad) after reloading section data
    
    if (is_ipad) {
        
        NSIndexPath* selectedIndexPath;
        
        if (preselectedRecipe) {
            selectedIndexPath = [self indexPathForRecipe:preselectedRecipe];
        }
        else {
            selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        }
        
        [tableView selectRowAtIndexPath:selectedIndexPath animated:true scrollPosition:UITableViewScrollPositionNone];
    }
}

@end
