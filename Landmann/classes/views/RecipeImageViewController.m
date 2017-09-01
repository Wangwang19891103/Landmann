//
//  RecipeImageViewController.m
//  Landmann
//
//  Created by Wang on 24.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeImageViewController.h"
#import "RecipeMenuCell.h"
#import "CALayer+Extensions.h"


@implementation RecipeImageViewController


@synthesize tableView;
@synthesize delegate;
@synthesize titleLabel;


- (id) init {
    
    if (self = [super initWithNibName:@"RecipeImageViewController" bundle:[NSBundle mainBundle]]) {
        
        [self loadData];

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
    
    [titleLabel setFrameOrigin:CGPointMake(0, 20)]; // war 7
    [self.tableView addSubview:titleLabel];

    titleLabel.text = @"Rezeptbilder";

}


#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionData.count;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [(NSArray*)[_sectionData objectAtIndex:section] count];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 73;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
    
    NSLog(@"image: %@", image);
    
    return cell;
}



#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecipeMenuCell* cell = (RecipeMenuCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:true];
    
    Recipe* recipe = [[_sectionData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    NSString* fileName = [NSString stringWithFormat:@"_%@_Full.jpg", [recipe.imageFull stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSString* imagePath = [RECIPE_IMAGES_FULL stringByAppendingPathComponent:fileName];
    NSString* fullPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
    UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
    
    if ([delegate respondsToSelector:@selector(recipeImageViewController:didPickRecipeImage:)]) {
        
        [delegate recipeImageViewController:self didPickRecipeImage:image];
    }
    
    [self performSelector:@selector(deselectCell:) withObject:cell afterDelay:TABLEVIEW_CELL_DESELECTION_DELAY];
}


- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"rect: %@", NSStringFromCGRect(cell.frame));
    
    [cell setFrameX:16];
    
    NSLog(@"rect after: %@", NSStringFromCGRect(cell.frame));
}



#pragma mark Private methods

- (void) deselectCell:(UITableViewCell*) cell {
    
    [cell setSelected:false];
}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}


- (void) loadData {
    
    NSMutableArray* sectionData = [NSMutableArray array];
    
    NSArray* recipes = [[ContentDataManager instance] recipesSortedAlhpabetically];
    
    [sectionData addObject:recipes];
    
    _sectionData = sectionData;
}


@end
