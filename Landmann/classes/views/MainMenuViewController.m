//
//  MainMenuViewController.m
//  Landmann
//
//  Created by Wang on 14.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "MainMenuViewController.h"
#import "RecipeCategoriesViewController.h"
#import "ShoppingRecipesViewController.h"
#import "InvitationsListViewController.h"
#import "GrilltipsMenuViewController.h"
#import "UserProfileViewController.h"
#import <MessageUI/MessageUI.h>
#import "RecipeMenuViewController.h"
#import "ImprintViewController.h"
#import "AppDelegateIpad.h"
#import "RecipeStreamViewController.h"
#import "InvitationsListViewControllerIpad.h"


#define URL_LANDMANN        @"http://www.landmann.de"
#define URL_FACEBOOK        @"http://www.facebook.com/LANDMANNgermany"
#define URL_FACEBOOK_APP    @"http://facebook.com/LANDMANNgermany"
//#define APP_STORE_LINK      @"http://itunes.apple.com/app/id645725836"


@implementation MainMenuViewController


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _image = [resource(@"Images.MainMenu.TableViewImage") CGImage];
        _imageSelected = [resource(@"Images.MainMenu.TableViewImageSelected") CGImage];
    }
    
    return self;
}



#pragma mark View

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.clearsSelectionOnViewWillAppear = true;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:resource(@"Images.NavigationBar.MainMenuImage")];
    
    if (is_ipad) {
        self.tableView.bounces = false;
    }
}







#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // IDIOM
    
    if (is_ipad) return 11;
    
    else return 12;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            // IDIOM
            if (is_ipad) return 65;
            else return 228;
            break;
            
        default:
            return 65;
            break;
    }
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = nil;
    
    // IDIOM
    
    if (!is_ipad && indexPath.row == 0) {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImageCell"];
        }
        
        UIImage* image = resource(@"Images.MainMenu.Image");
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        [cell.contentView addSubview:imageView];
    }
    else {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"TextCell"];

        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextCell"];
        }

        
        // tile image
        
        // IDIOM
        
        uint row = indexPath.row - (false) * 1;
        float offsetY = (is_ipad) ? 0 : -228;
        
        CGRect tileRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:row inSection:indexPath.section]];
        tileRect = CGRectOffset(tileRect, 0, offsetY);
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

    }

    return cell;
}


# pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController* controller = nil;
    UIViewController* controller2 = nil;
    
    // IDIOM
    
    uint cellIndex = indexPath.row + (is_ipad) * 1;
    
    
    switch (cellIndex) {
            
        case 1:
            controller = [[RecipeMenuViewController alloc] initWithCategory:@"Favoriten"];
            break;
            
        case 2:
            controller = [[RecipeCategoriesViewController alloc] init];
            if (is_ipad) controller2 = [[RecipeStreamViewController alloc] init];
            break;
            
        case 3:
            controller = [[RecipeMenuViewController alloc] initWithRecommendations];
            break;
            
        case 4:
            controller = [[ShoppingRecipesViewController alloc] init];
            break;
            
        case 5:
            controller = [[GrilltipsMenuViewController alloc] init];
            break;
            
        case 6:
            // IDIOM
            
            if (is_ipad) {
                controller = [[InvitationsListViewControllerIpad alloc] init];
                UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
                UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [backButton setImage:backButtonImage forState:UIControlStateNormal];
                [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
                [backButton addTarget:self action:@selector(popViewController2) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
                controller.navigationItem.leftBarButtonItem = backButtonItem;

                [((AppDelegateIpad*)[UIApplication sharedApplication].delegate).customNavigationController pushViewController:controller animated:false];
                controller = nil; // to ignore standard behaviour at bottom of method
            }
            else {
                controller = [[InvitationsListViewController alloc] init];
            }
            break;
            
        case 7:
            [self openFacebook];
            break;

        case 8:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_LANDMANN]];
            break;

        case 9:
            // IDIOM
            
            // IDIOM
            
            if (is_ipad) {
                controller = [[UserProfileViewController alloc] init];
                UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
                UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [backButton setImage:backButtonImage forState:UIControlStateNormal];
                [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
                [backButton addTarget:self action:@selector(popViewController2) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
                controller.navigationItem.leftBarButtonItem = backButtonItem;
                
                [((AppDelegateIpad*)[UIApplication sharedApplication].delegate).customNavigationController pushViewController:controller animated:false];
                controller = nil; // to ignore standard behaviour at bottom of method
            }
            else {
                controller = [[UserProfileViewController alloc] init];
            }
            break;
            
        case 10:
            [self recommend];
            break;
            
        case 11:
            controller = [[ImprintViewController alloc] init];
            break;
            
        default:
            break;
    }

//    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [self performSelector:@selector(deselectCell:) withObject:cell afterDelay:TABLEVIEW_CELL_DESELECTION_DELAY];

    [self.tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:TABLEVIEW_CELL_DESELECTION_DELAY];
    
    
    if (!controller) return;
    
    
    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;

    [self.navigationController pushViewController:controller animated:true];
}


//- (void) deselectCell:(UITableViewCell*) cell {
//
//    [cell setSelected:false];
//}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}


- (void) popViewController2 {
    
    [((AppDelegateIpad*)[UIApplication sharedApplication].delegate).customNavigationController popViewControllerAnimated:false];
}


- (void) openFacebook {
    
    BOOL facebookInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://requests"]];
    NSURL* url = nil;
    

    
    if (facebookInstalled) {
        
        url = [NSURL URLWithString:URL_FACEBOOK_APP];
    }
    else {
        
        url = [NSURL URLWithString:URL_FACEBOOK];
    }

//    alert (@"%d (%@)", facebookInstalled, url);
    
    [[UIApplication sharedApplication] openURL:url];
}


- (void) pushInvitations {
    
    UIViewController* controller = [[InvitationsListViewController alloc] init];
    
    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;
    
    [self.navigationController popToRootViewControllerAnimated:false];
    [self.navigationController pushViewController:controller animated:false];
}


- (void) pushShopping {
    
    UIViewController* controller = [[ShoppingRecipesViewController alloc] init];
    
    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;
    
    [self.navigationController popToRootViewControllerAnimated:false];
    [self.navigationController pushViewController:controller animated:false];
}


#pragma mark Mail

- (void) recommend {
    
	MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
    
    if (mailController == nil) {
        
        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:resource(@"Dictionaries.Strings.Recommend.AlertTitle")
                                  message:resource(@"Dictionaries.Strings.Recommend.CheckEmailSettings")
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
	mailController.mailComposeDelegate = self;
	
    NSString* bodyFileName = resource(@"Dictionaries.Strings.Recommend.BodyFile");
    NSString* bodyPath = [[NSBundle mainBundle] pathForResource:bodyFileName ofType:nil];
    NSString* bodyString = [NSString stringWithContentsOfFile:bodyPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString* subjectString = resource(@"Dictionaries.Strings.Recommend.Subject");
    
    [mailController setSubject:subjectString];
    [mailController setMessageBody:bodyString isHTML:true];
    [self presentModalViewController:mailController animated:true];
    
    
}


- (void) mailComposeController:(MFMailComposeViewController *) controller
           didFinishWithResult:(MFMailComposeResult) result
                         error:(NSError *) error {
    
    NSString* message = nil;
    
	switch (result) {
            
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
            message = resource(@"Dictionaries.Strings.Recommend.ThanksForRecommending");
			break;
		case MFMailComposeResultFailed:
            message = resource(@"Dictionaries.Strings.Recommend.ErrorEmailSettings");
            break;
		default:
			break;
	}
    
    if (message) {
        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:resource(@"Dictionaries.Strings.Recommend.AlertTitle")
                                  message:message
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
	[self dismissModalViewControllerAnimated:true];
}

@end
