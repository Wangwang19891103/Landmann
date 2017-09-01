//
//  DummyViewController.m
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "DummyViewController.h"
#import "RecipeDetailsViewController.h"


@interface DummyViewController ()

@end

@implementation DummyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                        [UIColor redColor], UITextAttributeTextColor,
//                                                                       [UIFont fontWithName:@"HelveticaNeue_Bold" size:8.0], UITextAttributeFont,
//                                                                        nil];
        
        self.navigationItem.title = @"Start";

    }
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(100, 100, 70, 40)];
    [button setTitle:@"Rezept1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void) tap {
    
    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // recipe
    Recipe* recipe = [[[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe"
                                                                                withPredicate:[NSPredicate predicateWithFormat:@"number == 1"] sortedBy:nil] firstElement];
    
    
    RecipeDetailsViewController* controller = [[RecipeDetailsViewController alloc] initWithRecipe:recipe];
    controller.navigationItem.leftBarButtonItem = backButtonItem;

    [self.navigationController pushViewController:controller animated:true];
}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
