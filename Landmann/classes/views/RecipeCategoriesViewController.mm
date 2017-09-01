//
//  RecipeCategoriesViewController.m
//  Landmann
//
//  Created by Wang on 15.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeCategoriesViewController.h"
#import "RecipeMenuViewController.h"
#import "NavigationBarImageCreator.h"


#define SEARCH_BAR_RECT CGRectMake(25,20,268,30)


@implementation RecipeCategoriesViewController


@synthesize tableView;
@synthesize penView;


- (id) init {
    
    if (self = [super initWithNibName:@"RecipeCategoriesViewController" bundle:[NSBundle mainBundle]]) {
        
        _image = [resource(@"Images.RecipeCategories.TableViewImage") CGImage];
        _imageSelected = [resource(@"Images.RecipeCategories.TableViewImageSelected") CGImage];
        
        // IDIOM
        
        if (is_ipad) {
        
            _heights = new uint[10] {
                98,
                66,
                67,
                67,
                67,
                66,
                67,
                66,
                67,
                75,
            };
            
            _categories = new NSString*[9] {
                @"Favoriten",
                @"Empfehlungen",
                @"Fleisch",
                @"Geflügel",
                @"Aus dem Wasser",
                @"Vegetarisch",
                @"Süßer Genuss",
                @"Beilagen",
                @"Marinaden"
            };
        }
        else {
            
            _heights = new uint[9] {
                68,
                66,
                67,
                67,
                66,
                67,
                66,
                67,
                64
            };
            
            _categories = new NSString*[8] {
                @"Favoriten",
                @"Fleisch",
                @"Geflügel",
                @"Aus dem Wasser",
                @"Vegetarisch",
                @"Süßer Genuss",
                @"Beilagen",
                @"Marinaden"
            };
        }
        

    }
    
//    [self.navigationItem setTitle:@"Rezeptkategorien"];
    
    UIImage* navImage = [NavigationBarImageCreator createImageWithString:@"Rezeptkategorien"];
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:navImage]];
    
//    UIView* dummy = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navImage.size.width, navImage.size.height)];
//    dummy.backgroundColor = [UIColor redColor];
//    [self.navigationItem setTitleView:dummy];

    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // IDIOM
    
    if (is_ipad) {
        self.tableView.bounces = false;
        penView.hidden = false;
    }
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([_searchBar isFirstResponder]) {
        
        [_searchBar resignFirstResponder];
    }
}



#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // IDIOM
    
    if (is_ipad) return 10;
    else return 9;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return _heights[indexPath.row];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = nil;
    
    // search field

    if (indexPath.row == 0) {
    
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellSearch"];

        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellSearch"];
        }

        // IDIOM
        
        if (!is_ipad) {
        
            _searchBar = [[UISearchBar alloc] initWithFrame:SEARCH_BAR_RECT];
            _searchBar.backgroundImage = [UIImage new];
            _searchBar.translucent = true;
            _searchBar.delegate = self;
            _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
            _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:_searchBar];
        }
    }
    else {
    
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
    }
    
    cell.opaque = false;
    cell.backgroundColor = [UIColor clearColor];
    
    
    // tile image
    CGRect tileRect = [self.tableView rectForRowAtIndexPath:indexPath];
    float scale = [UIScreen mainScreen].scale;
    scale = MIN(scale, 2.0);
    tileRect = CGRectApplyAffineTransform(tileRect, CGAffineTransformMakeScale(scale, scale));
    CGImageRef imageRef = CGImageCreateWithImageInRect(_image, tileRect);
    UIImage* image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    cell.backgroundView = imageView;
    
    // selected image
    imageRef = CGImageCreateWithImageInRect(_imageSelected, tileRect);
    image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    imageView = [[UIImageView alloc] initWithImage:image];
    cell.selectedBackgroundView = imageView;
    
    return cell;
}


#pragma mark UITableViewDelegate


- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return NO;
    }
    else {
        
        return YES;
    }
}


- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([_searchBar isFirstResponder]) {

        [_searchBar resignFirstResponder];

        return nil;
    }
    else if (indexPath.row == 0) {
        
        return nil;
    }
    else {
        
        return indexPath;
    }

}

//- (void) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
//
//    if ([_searchBar isFirstResponder]) {
//    
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    else {
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    }
//}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0) {
     
//        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        [cell setSelected:true];
        
//        [self.tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
        
        NSString* category = _categories[indexPath.row - 1];
        UIViewController* controller = nil;
        
        if ([category isEqualToString:@"Empfehlungen"]) {
            controller = [[RecipeMenuViewController alloc] initWithRecommendations];
        }
        else {
            controller = [[RecipeMenuViewController alloc] initWithCategory:category];
        }
        
        UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:backButtonImage forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        controller.navigationItem.leftBarButtonItem = backButtonItem;
        
        [self.navigationController pushViewController:controller animated:true];
     
        [self.tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:TABLEVIEW_CELL_DESELECTION_DELAY];

    }
}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}


//- (void) deselectCell:(UITableViewCell*) cell {
//    
//    [cell setSelected:false];
//}



#pragma mark Delegate Methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    NSLog(@"search: %@", searchBar.text);
    
    UIViewController* controller = [[RecipeMenuViewController alloc] initWithKeywords:[searchBar.text componentsSeparatedByString:@" "]];
    
    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;
    
    [self.navigationController pushViewController:controller animated:true];
}

@end
