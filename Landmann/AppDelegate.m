//
//  AppDelegate.m
//  Landmann
//
//  Created by Wang on 19.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "RecipeDetailsViewController.h"
#import "DummyViewController.h"
#import "MainMenuViewController.h"

#import "InvitationsListViewController.h"
#import "InvitationsEditViewController.h"

#import "ShoppingRecipesViewController.h"
#import "ShoppingIngredientsViewController.h"
#import "ShareProtocol.h"

#import "SettingsManager.h"
#import "UserProfileViewController.h"



@implementation AppDelegate


@synthesize window;
@synthesize tabBar;
@synthesize navigationController;
@synthesize view2;
@synthesize mainMenuController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    // Window
//    self.window = [[[NSBundle mainBundle] loadNibNamed:@"MainWindow" owner:self options:nil] firstElement];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    
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
    

    
//    [[UINavigationBar appearance] setTitleColor:[UIColor colorWithRed:75 green:87 blue:95 alpha:1.0] forState:UIControlStateNormal];

    
    // RootViewController
//    RezeptViewController* controller = [[RezeptViewController alloc] initWithRecipe:nil];
//    RezeptViewController* controller2 = [[RezeptViewController alloc] initWithRecipe:nil];
    DummyViewController* controllerfssdasd = [[DummyViewController alloc] init];

    MainMenuViewController* mainMenuViewController = [[MainMenuViewController alloc] init];

//    [self.navigationController.toolbar setFrameHeight:100];
//    [self.navigationController.toolbar setFrameY:self.navigationController.toolbar.frame.origin.y - (100 - 49)];
    
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainMenuViewController];
//    navigationController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
//    [self.window setRootViewController:navigationController];

//    [navigationController.view setFrame:CGRectMake(0, 0, 320, self.window.frame.size.height - self.tabBar.frame.size.height)];
//    [self.window addSubview:navigationController.view];
    
//    self.navigationController.toolbarHidden = false;
//    [self.navigationController.toolbar setFrameHeight:49];
//    [self.navigationController.toolbar addSubview:self.tabBar];
//    [self.tabBar setFrameY:0];
    
    
//    [self.window setRootViewController:navigationController];

    
//    // workaround for loading it from NIB
//    [self.navigationController.view addSubview:self.navigationController.topViewController.view];
    
    [self.view2 addSubview:self.navigationController.view];
    [self.navigationController.view setFrame:self.view2.bounds];
    [self.window.rootViewController addChildViewController:self.navigationController];
    
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:resource(@"Images.TabBar.Icons.HomeSelected") withFinishedUnselectedImage:resource(@"Images.TabBar.Icons.Home")];
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:resource(@"Images.TabBar.Icons.InvitationsSelected") withFinishedUnselectedImage:resource(@"Images.TabBar.Icons.Invitations")];
    [[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:resource(@"Images.TabBar.Icons.ShoppingSelected") withFinishedUnselectedImage:resource(@"Images.TabBar.Icons.Shopping")];
    [[self.tabBar.items objectAtIndex:3] setFinishedSelectedImage:resource(@"Images.TabBar.Icons.ShareSelected") withFinishedUnselectedImage:resource(@"Images.TabBar.Icons.Share")];
    
    
    //IOS7
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]
                                                            } forState:UIControlStateSelected];

    }

    
    NSLog(@"navigationcontroller view: %@", self.navigationController.view);
    NSLog(@"navigationcontroller view superview: %@", self.navigationController.view.superview);
    NSLog(@"navigationcontroller viewcontrollers: %@", self.navigationController.viewControllers);
    NSLog(@"navigationcontroller topviewcontroller: %@", self.navigationController.topViewController);
    NSLog(@"navigationcontroller topviewcontroller view: %@", self.navigationController.topViewController.view);
    NSLog(@"navigationcontroller topviewcontroller view superview: %@", self.navigationController.topViewController.view.superview);
    
//    [(UINavigationController*)self.window.rootViewController pushViewController:controllerfssdasd animated:false];

//    UITabBar* tabbar = [[UITabBar alloc] init];
    
//    navigationController 
    
//    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
//    [backButtonImage saveInDocumentsWithName:@"backbutton"]; //
//    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:backButtonImage]];
//    
//    
////    controller.navigationItem.backBarButtonItem = backButtonItem;
//    controller.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    
    
    
//    [navigationController pushViewController:controller2 animated:false];
    
    
    
//    [self.window setRootViewController:navigationController];
    
    
    
    if ([SettingsManager sharedInstance].firstRun) {
        
        [SettingsManager sharedInstance].firstRun = false;
        
        UserProfileViewController* controller = [[UserProfileViewController alloc] init];
        
        UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:backButtonImage forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        controller.navigationItem.leftBarButtonItem = backButtonItem;
        
        [self.navigationController pushViewController:controller animated:false];
    }
    
    
    [self.window makeKeyAndVisible];

//    [TreeInspectorInvoker addInvokeForViewController:navigationController onView:navigationController.view];
//    [TreeInspectorInvoker addInvokerToWindow];
    
    return YES;
}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark UITabBarDelegate

- (void) tabBar:(UITabBar *)tabBar2 didSelectItem:(UITabBarItem *)item {
    
    NSLog(@"tabbar tag: %d", item.tag);
    
    if (item == _lastItem) return;
    
    
    switch (item.tag) {

        case 1001:
            [self.navigationController popToRootViewControllerAnimated:false];
            _lastItem = item;
            break;
            
        case 1002:
            [mainMenuController pushInvitations];
            _lastItem = item;
            break;
            
        case 1003:
            [mainMenuController pushShopping];
            _lastItem = item;
            break;
            
        case 1004:
            [tabBar2 setSelectedItem:_lastItem];
            if ([self.navigationController.topViewController respondsToSelector:@selector(toggleShareMenu)]) {
                [(id<ShareProtocol>)self.navigationController.topViewController toggleShareMenu];
            }
            break;
            
        default:
            break;
    }
    

}


- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UITabBarItem* item = nil;
    
    // Home
    if ([viewController isKindOfClass:[MainMenuViewController class]]) {
        
        item = [tabBar.items objectAtIndex:0];
    }
    
    // Invitations
    else if ([viewController isKindOfClass:[InvitationsListViewController class]]
        || [viewController isKindOfClass:[InvitationsEditViewController class]]) {
        
        item = [tabBar.items objectAtIndex:1];
    }
    
    // Shopping
    else if ([viewController isKindOfClass:[ShoppingRecipesViewController class]]
             || [viewController isKindOfClass:[ShoppingIngredientsViewController class]]) {
        
        item = [tabBar.items objectAtIndex:2];
    }
    else {
        
        item = nil;
    }
    
    [tabBar setSelectedItem:item];
    _lastItem = item;
    
    
    // share button
    
    item = [tabBar.items objectAtIndex:3];
    UIImage* image = nil;
    BOOL enabled;
    
    if ([viewController respondsToSelector:@selector(toggleShareMenu)]) {

        image = resource(@"Images.TabBar.Icons.Share");
        enabled = true;
    }
    else {
        
        image = resource(@"Images.TabBar.Icons.ShareDisabled");
        enabled = false;
    }
    
//    [item setFinishedSelectedImage:image withFinishedUnselectedImage:image];
    item.enabled = enabled;
}


@end


