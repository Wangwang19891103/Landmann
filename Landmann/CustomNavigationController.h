//
//  CustomNavigationController.h
//  Landmann
//
//  Created by Wang on 27.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomNavigationController : UINavigationController <UINavigationControllerDelegate, UISearchBarDelegate> {
    
    uint _leftCount;
    
    RecipeStreamViewController* _recipeStreamViewController;
    
    UISearchBar* _searchBar;

}


@property (nonatomic, strong) IBOutlet UIView* leftView;

@property (nonatomic, strong) IBOutlet UIView* rightView;

@property (nonatomic, strong) IBOutlet UINavigationController* leftNavigationController;

@property (nonatomic, strong) IBOutlet UINavigationController* rightNavigationController;

@property (nonatomic, strong) IBOutlet UIViewController* rootViewController;

@property (nonatomic, strong) IBOutlet UIButton* homeButton;

@property (nonatomic, strong) IBOutlet UIView* buttonsView;

@property (nonatomic, strong) IBOutlet UIButton* shareButton;


- (IBAction) actionHomeIpad;
- (IBAction) actionShopping;
- (IBAction) actionInvitations;
- (IBAction) actionShare;

@end
