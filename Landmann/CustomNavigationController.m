//
//  CustomNavigationController.m
//  Landmann
//
//  Created by Wang on 27.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "CustomNavigationController.h"
#import "MainMenuViewController.h"
#import "RecipeCategoriesViewController.h"
#import "ShoppingRecipesViewController.h"
#import "InvitationsListViewControllerIpad.h"
#import "ShareProtocol.h"
#import "RecipeDetailsViewController.h"
#import "RecipeMenuViewController.h"


#define SEARCH_BAR_RECT CGRectMake(0,0,250,30)


@implementation CustomNavigationController


@synthesize leftView;
@synthesize rightView;
@synthesize leftNavigationController;
@synthesize rightNavigationController;
@synthesize rootViewController;
@synthesize homeButton;
@synthesize buttonsView;
@synthesize shareButton;


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
    
        _leftCount = 0;
        
        // Navigation Bar
        UIImage* navbarBackgroundImage = resource(@"Images.NavigationBar.Background");
        navbarBackgroundImage = [navbarBackgroundImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        [[UINavigationBar appearance] setBackgroundImage:navbarBackgroundImage forBarMetrics:UIBarMetricsDefault];
        //    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        NSDictionary* titleTextAttributes = @{
                                              UITextAttributeFont : [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0],
                                              UITextAttributeTextColor: [UIColor colorWithRed:75.0/255 green:87.0/255 blue:95.0/255 alpha:1.0],
                                              };
        [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
        
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        
        
                
        
        
        // TODO
        
        //    if ([SettingsManager sharedInstance].firstRun) {
        //
        //        [SettingsManager sharedInstance].firstRun = false;
        //
        //        UserProfileViewController* controller = [[UserProfileViewController alloc] init];
        //
        //        UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
        //        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [backButton setImage:backButtonImage forState:UIControlStateNormal];
        //        [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
        //        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        //        UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        //        controller.navigationItem.leftBarButtonItem = backButtonItem;
        //        
        //        [self.navigationController pushViewController:controller animated:false];
        //    }
        
        
        _recipeStreamViewController = [[RecipeStreamViewController alloc] init];

    }
    
    return self;
}



- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self.leftView addSubview:self.leftNavigationController.view];
    [self.leftNavigationController.view setFrame:self.leftView.bounds];
    [self.rootViewController addChildViewController:self.leftNavigationController];
    
    [self.rightView addSubview:self.rightNavigationController.view];
    [self.rightNavigationController.view setFrame:self.rightView.bounds];
    [self.rootViewController addChildViewController:self.rightNavigationController];
    
    
    NSLog(@"navigationcontroller view: %@", self.leftNavigationController.view);
    NSLog(@"navigationcontroller view superview: %@", self.leftNavigationController.view.superview);
    NSLog(@"navigationcontroller viewcontrollers: %@", self.leftNavigationController.viewControllers);
    NSLog(@"navigationcontroller topviewcontroller: %@", self.leftNavigationController.topViewController);
    NSLog(@"navigationcontroller topviewcontroller view: %@", self.leftNavigationController.topViewController.view);
    NSLog(@"navigationcontroller topviewcontroller view superview: %@", self.leftNavigationController.topViewController.view.superview);

    [homeButton setFrameX:0];
    [homeButton setFrameY:self.leftView.frame.size.height - homeButton.frame.size.height + 1];
    homeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.leftView addSubview:homeButton];

    
    // search bar
    
    _searchBar = [[UISearchBar alloc] initWithFrame:SEARCH_BAR_RECT];
    _searchBar.backgroundImage = [UIImage new];
    _searchBar.translucent = true;
    _searchBar.delegate = self;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

}


#pragma mark Delegate

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (navigationController == leftNavigationController) {
        
        enum {Pushed, Popped, Nothing} action = (navigationController.viewControllers.count > _leftCount) ? Pushed : (navigationController.viewControllers.count < _leftCount) ? Popped : Nothing;
        _leftCount = navigationController.viewControllers.count;
        
        if (action == Nothing) alert(@"RightNavigationController: action=Nothing");
        
        if ([viewController isKindOfClass:[MainMenuViewController class]]) {
            [rightNavigationController popToRootViewControllerAnimated:false];
        }
        else if ([viewController isKindOfClass:[RecipeCategoriesViewController class]]) {
            if (action == Pushed) {
                [rightNavigationController pushViewController:_recipeStreamViewController animated:false];
            }
            else {
                [rightNavigationController popToViewController:_recipeStreamViewController animated:false];
            }
        }
        
        if ([viewController isKindOfClass:[MainMenuViewController class]]) {
            homeButton.hidden = true;
        }
        else {
            homeButton.hidden = false;
        }
    }
    else if (navigationController == rightNavigationController) {
        
        [viewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:buttonsView]];
        
        if ([viewController respondsToSelector:@selector(toggleShareMenu)]) {
            shareButton.hidden = false;
        }
        else {
            shareButton.hidden = true;
        }
        
        if ([viewController isKindOfClass:[RecipeStreamViewController class]]
            || [viewController isKindOfClass:[RecipeDetailsViewController class]]) {
            
            [viewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_searchBar]];
        }
    }
}


- (IBAction) actionHomeIpad {

    if (self.topViewController == rootViewController) {
        [leftNavigationController popToRootViewControllerAnimated:true];
    }
    else {
        [self popToRootViewControllerAnimated:false];
    }
}


- (IBAction) actionShopping {
    
    if ([self.leftNavigationController.topViewController isKindOfClass:[ShoppingRecipesViewController class]]) return;
    
    
    UIViewController* controller = [[ShoppingRecipesViewController alloc] init];
    
    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;

    [self.leftNavigationController popToRootViewControllerAnimated:false];
    [self.leftNavigationController pushViewController:controller animated:false];
}


- (IBAction) actionInvitations {
    
    if ([self.topViewController isKindOfClass:[InvitationsListViewControllerIpad class]]) return;
    
    
    UIViewController* controller = [[InvitationsListViewControllerIpad alloc] init];
    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController2) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;
    
    [self.leftNavigationController popToRootViewControllerAnimated:false];
    [self popToRootViewControllerAnimated:false];
    [self pushViewController:controller animated:false];
}


- (IBAction) actionShare {
    
    if ([self.rightNavigationController.topViewController respondsToSelector:@selector(toggleShareMenu)]) {
        [(id<ShareProtocol>)self.rightNavigationController.topViewController toggleShareMenu];
    }
}



- (void) popViewController {
    
    [self.leftNavigationController popViewControllerAnimated:true];
}


- (void) popViewController2 {
    
    [self popViewControllerAnimated:false];
}



#pragma mark Delegate Methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [searchBar resignFirstResponder];

    NSLog(@"search: %@", searchBar.text);
    
    UIViewController* controller = [[RecipeMenuViewController alloc] initWithKeywords:[searchBar.text componentsSeparatedByString:@" "]];
    
    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;
    
    // case 1: search bar on RecipeStreamViewController (Categories) -> push Menu View Controller
    // case 2: search bar on RecipeDetailsViewController (Menu) -> pop and push Menu View Controller

    if ([self.leftNavigationController.topViewController isKindOfClass:[RecipeMenuViewController class]]) {
        
        [self.leftNavigationController popViewControllerAnimated:false];
        [self.rightNavigationController popToViewController:_recipeStreamViewController animated:false];
        [self.leftNavigationController pushViewController:controller animated:false];
    }
    else {
        [self.leftNavigationController pushViewController:controller animated:true];
    }
    

}

@end
