//
//  RecipeStreamViewController.m
//  Landmann
//
//  Created by Wang on 15.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeStreamViewController.h"
#import "CALayer+Extensions.h"
#import "RecipeStreamCell.h"
#import "RecipeDetailsViewController.h"
#import "RecipeMenuViewController.h"


#define ITEM_SIZE               CGSizeMake(220,220)
#define ITEM_INSETS             UIEdgeInsetsMake(2,2,2,2)
#define ITEM_MARGIN_LEFT        5
#define ITEM_MARGIN_TOP         10
#define ITEM_PADDING            8
#define ITEM_COUNT_X            3
#define ITEM_MARGIN_BOTTOM      10
#define ITEM_TITLE_VIEW_HEIGHT  47
#define ITEM_TITLE_TEXT_MARGIN  10
#define ITEM_TITLE_TEXT_FONT    [UIFont fontWithName:@"Helvetica" size:13.0]
#define ITEM_TITLE_BACKGROUND   @"Images.RecipeStream.TitleBackground"
#define ITEM_BACKGROUND         @"Images.RecipeStream.ItemBackground"


@implementation RecipeStreamViewController


@synthesize collectionView;


- (id) init {
    
    if (self = [super init]) {
        
        [self loadData];
        
        [self.navigationItem setHidesBackButton:true];

    }
    
    return self;
}



#pragma mark View

- (void) viewDidLoad {
    
    [super viewDidLoad];

    [collectionView registerClass:[RecipeStreamCell class] forCellWithReuseIdentifier:@"cell"];

    
    // preload recipe images
    
    NSMutableArray* images = [NSMutableArray array];
    
    for (Recipe* recipe in _data) {
        
        NSString* fileName = [NSString stringWithFormat:@"_%@_stream.jpg", [recipe.imageFull stringByReplacingOccurrencesOfString:@" " withString:@""]];
        NSString* imagePath = [RECIPE_IMAGES_STREAM_IPAD stringByAppendingPathComponent:fileName];
        NSString* fullPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
        UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
        [images addObject:image];
    }
    
    _images = images;
    
//    float posX = ITEM_MARGIN_LEFT;
//    float posY = ITEM_MARGIN_TOP;
//    uint count = 0;
    
//    NSMutableArray* views = [NSMutableArray array];
//    
//    for (Recipe* recipe in _data) {
//        
//        // containerView
////        UIView* containerView = [[UIView alloc] initWithFrame:(CGRect){{posX, posY}, ITEM_SIZE}];
//        UIImageView* containerView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointZero, ITEM_SIZE}];
////        containerView.backgroundColor = [UIColor whiteColor];
//        containerView.image = [resource(ITEM_BACKGROUND) resizableImageWithCapInsets:UIEdgeInsetsZero];
//        containerView.layer.mask = [CALayer maskLayerWithSize:containerView.bounds.size roundedCornersTop:YES bottom:YES left:YES right:YES radius:3.0];
//        containerView.layer.mask.frame = containerView.bounds;
//        containerView.layer.masksToBounds = true;
//        
//        // imageView
//        NSString* fileName = [NSString stringWithFormat:@"_%@_thumb.jpg", [recipe.imageFull stringByReplacingOccurrencesOfString:@" " withString:@""]];
//        NSString* imagePath = [RECIPE_IMAGES_THUMB_IPAD stringByAppendingPathComponent:fileName];
//        NSString* fullPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
//        UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
//        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
////        imageView.contentMode = UIViewContentModeCenter;
//        imageView.frame = CGSizeInset(ITEM_SIZE, ITEM_INSETS);
//        [containerView addSubview:imageView];
////        [contentView addSubview:containerView];
//        
//        // titleView
//        UIImageView* titleView = [[UIImageView alloc] initWithFrame:CGRectMake(ITEM_INSETS.left,
//                                                                              ITEM_INSETS.top,
//                                                                              ITEM_SIZE.width - ITEM_INSETS.left - ITEM_INSETS.right,
//                                                                               ITEM_TITLE_VIEW_HEIGHT)];
//        titleView.alpha = 0.8;
//        titleView.image = [resource(ITEM_TITLE_BACKGROUND) resizableImageWithCapInsets:UIEdgeInsetsZero];
//        [containerView addSubview:titleView];
//        
//        // titleLabel
//        NSString* text = recipe.title;
//        float textWidth = imageView.bounds.size.width - (2 * ITEM_TITLE_TEXT_MARGIN);
//        CGSize textSize = [text sizeWithFont:ITEM_TITLE_TEXT_FONT constrainedToSize:CGSizeMake(textWidth, ITEM_TITLE_VIEW_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
//        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textWidth, textSize.height)];
//        label.text = recipe.title;
//        label.numberOfLines = 0;
//        label.textColor = [UIColor blackColor];
//        label.textAlignment = UITextAlignmentLeft;
//        label.backgroundColor = [UIColor clearColor];
////        CGPoint centerPoint = CGPointMake(ITEM_SIZE.width * 0.5,
////                                          ITEM_TITLE_VIEW_HEIGHT * 0.5 + ITEM_INSETS.top);
////        [label centerOverPoint:centerPoint];
//        [titleView addSubview:label];
//        [label centerXInSuperview];
//        [label centerYInSuperview];
//        
//        
//        // add view to array
//        
//        [views addObject:containerView];
//        
//        
////        ++count;
//        
////        if (count % ITEM_COUNT_X == 0) {
////            posX = ITEM_MARGIN_LEFT;
////            posY += ITEM_SIZE.height + ITEM_PADDING;
////        }
////        else {
////            posX += ITEM_SIZE.width + ITEM_PADDING;
////        }
//    }
//    
////    posY += ITEM_SIZE.height + ITEM_MARGIN_BOTTOM;
////    
////    [contentView setFrameHeight:posY];
////    [scrollView setContentSize:contentView.bounds.size];
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    [collectionView setContentOffset:CGPointZero];
}



#pragma mark CollectionView

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _data.count;
}


- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecipeStreamCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    Recipe* recipe = [_data objectAtIndex:indexPath.row];
    
    cell.titleText = recipe.title;

    UIImage* image = [_images objectAtIndex:indexPath.row];
    cell.imageView.image = image;
    
    return cell;
}


- (BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return true;
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    // right
    Recipe* recipe = [_data objectAtIndex:indexPath.row];
    
    
//    UIViewController* controller = [[RecipeDetailsViewController alloc] initWithRecipe:recipe];
    
//    [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.rightNavigationController pushViewController:controller animated:false];

    
    // Left
    NSString* category = recipe.category.title;
    
    RecipeMenuViewController* controller = [[RecipeMenuViewController alloc] initWithCategory:category];
    
    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;

    controller.preselectedRecipe = recipe;
    
    
    // TEST
    
    if ([((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.leftNavigationController.topViewController isKindOfClass:[RecipeMenuViewController class]]) {
        
        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.leftNavigationController popViewControllerAnimated:false];
        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.leftNavigationController pushViewController:controller animated:false];
    }
    else {
    
        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.leftNavigationController pushViewController:controller animated:true];
    }


}


- (void) popViewController {
    
    [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.leftNavigationController popViewControllerAnimated:true];
}



#pragma mark Data

- (void) loadData {

    _data = [[ContentDataManager instance] recipesSortedAlhpabetically];
}

@end
