//
//  RezeptViewController.h
//  Landmann
//
//  Created by Wang on 24.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeInfoBar.h"
#import "NotesViewDelegate.h"
#import "TouchView.h"
#import "NotesView.h"
#import "IngredientsViewDelegate.h"
#import "IngredientsView.h"
#import "RecipeDetailsTipViewControllerDelegate.h"
#import "RecipeDetailsTipViewController.h"
#import "FavoriteViewDelegate.h"
#import "FavoriteView.h"
#import "ShareProtocol.h"
#import "RecipeDetailsFullscreenViewControllerDelegate.h"
#import "RecipeDetailsTipViewControllerIpad.h"
#import <WebKit/WebKit.h>


@interface RecipeDetailsViewController : UIViewController <NotesViewDelegate, IngredientsViewDelegate, UIWebViewDelegate,
    WKNavigationDelegate,
RecipeDetailsTipViewControllerDelegate, FavoriteViewDelegate, ShareProtocol, RecipeDetailsFullscreenViewControllerDelegate, UIGestureRecognizerDelegate> {
    
    Recipe* _recipe;
    RecipeInfoBar* _infoBar;
    
    RecipeDetailsTipViewController* _tipViewController;
    
    RecipeDetailsTipViewControllerIpad* _tipViewControllerIpad;
    
    NSString* _shareString;
    
    BOOL _notesEditing;
    
    UIGestureRecognizer* _webviewRecognizer;
    
    UIPopoverController* _popover;

    CGSize _oldContentSize;
    
    id _webViewToUse;
}

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) IBOutlet UIView* contentView;

@property (nonatomic, strong) IBOutlet UIImageView* imageView;

//@property (nonatomic, strong) IBOutlet TouchView* touchView;

@property (nonatomic, strong) IBOutlet FavoriteView* favoriteView;

@property (nonatomic, strong) IBOutlet NotesView* notesView;

@property (nonatomic, strong) IBOutlet IngredientsView* ingredientsView;

@property (nonatomic, strong) IBOutlet UIWebView* webView_ios8;

@property (nonatomic, strong) WKWebView* webView_ios9;

@property (nonatomic, strong) IBOutlet UIView* webViewDummy;

@property (nonatomic, strong) IBOutlet UIButton* tipButton;

//@property (nonatomic, strong) IBOutlet UIScrollView* scrollView2;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray* fontsizeButtons;






- (id) initWithRecipe:(Recipe*) recipe;


- (IBAction) actionShowTip;
- (IBAction) actionFontsizeMinus;
- (IBAction) actionFontsizePlus;


@end
