//
//  RezeptViewController.m
//  Landmann
//
//  Created by Wang on 24.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeDetailsViewController.h"
#import "FloatFormatter.h"
#import "HTML2StringScanner.h"
#import "IngredientsTextCreator.h"
#import "RecipeDetailsFullscreenViewController.h"
#import "NavigationBarImageCreator.h"


#define BOTTOM_MARGIN 20
//#define KEYBOARD_HEIGHT 216
#define KEYBOARD_DURATION 0.3
#define NAVBAR_HEIGHT 44
#define TABBAR_HEIGHT 49
#define INFO_BAR_BOTTOM_BORDER 200
#define INFO_BAR_TOP_BORDER 160
#define INGREDIENTS_VIEW_BOTTOM_MARGIN 20

#define INFO_BAR_TOP_BORDER_IPAD 305

#define KEYBOARD_HEIGHT_IPHONE 216
#define KEYBOARD_HEIGHT_IPAD 352

//#define FONT [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0]
//#define FONT2 [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0]
//#define FONT3 [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]

#define FONT_NAME       @"HelveticaNeue-Medium"
#define FONT_SIZE1      14.0
#define FONT_SIZE2      18.0
#define FONT_SIZE_STRIDE    2.0

#define FONT_SIZE1_IPAD     18.0
#define FONT_SIZE2_IPAD     24.0

#define INDEX_FONTSIZE_BUTTON_MINUS     0
#define INDEX_FONTSIZE_BUTTON_PLUS      1

#define WEBVIEW_CONTENT_WIDTH_IPAD    686

#define WEBVIEW_CONTENT_MARGIN_IPAD     70
#define WEBVIEW_CONTENT_MARGIN_TOP_IPAD     70
#define WEBVIEW_CONTENT_CAPTION_WIDTH_IPAD      550


#define SYSTEM_VERSION_LESS_THAN__RDVC(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)



@implementation RecipeDetailsViewController


@synthesize scrollView;
@synthesize contentView;
@synthesize imageView;
//@synthesize touchView;
@synthesize ingredientsView;
@synthesize notesView;
@synthesize webView_ios9;
@synthesize webView_ios8;
@synthesize webViewDummy;
//@synthesize scrollView2;
@synthesize tipButton;
@synthesize favoriteView;
@synthesize fontsizeButtons;


- (id) initWithRecipe:(Recipe*)recipe {

    NSString* nibName = SYSTEM_VERSION_LESS_THAN__RDVC(@"9.0") ? @"RecipeDetailsViewController_ios8" : @"RecipeDetailsViewController";
    
    if (self =[super initWithNibName:nibName bundle:[NSBundle mainBundle]]) {

        _recipe = recipe;
        
        _infoBar = [[RecipeInfoBar alloc] init];


    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];

    
    // resolve webview
    
    if (SYSTEM_VERSION_LESS_THAN__RDVC(@"9.0")) {
     
        _webViewToUse = webView_ios8;
    }
    else {
        
        webView_ios9 = [[WKWebView alloc] initWithFrame:webViewDummy.frame];
        webView_ios9.autoresizingMask = webViewDummy.autoresizingMask;
        webView_ios9.navigationDelegate = self;
        
        UIView* superView = webViewDummy.superview;
        [superView insertSubview:webView_ios9 belowSubview:webViewDummy];
        [webViewDummy removeFromSuperview];
        
        _webViewToUse = webView_ios9;
    }
    
    // ---
    
    
    UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapContent)];
    [contentView addGestureRecognizer:recognizer];
    
    
//    self.navigationItem.title = _recipe.title;
    
    // IDIOM
    
    if (!is_ipad) {
        UIImage* navImage = [NavigationBarImageCreator createImageWithString:_recipe.title];
        [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:navImage]];
    }
    else {
        [self.navigationItem setHidesBackButton:true];
    }
    
    // IDIOM
    
    NSString* imageFolder = (is_ipad) ? RECIPE_IMAGES_LARGE_IPAD : RECIPE_IMAGES_LARGE_IPHONE;
    
    NSString* fileName = [NSString stringWithFormat:@"_%@_large.jpg", [_recipe.imageFull stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSString* imagePath = [imageFolder stringByAppendingPathComponent:fileName];
    NSString* fullPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
    UIImage* image = [UIImage imageWithContentsOfFile:fullPath];

    self.imageView.image = image;
    
    // TEST
    
    // IDIOM
    
    float topBorder = (is_ipad) ? INFO_BAR_TOP_BORDER_IPAD : INFO_BAR_TOP_BORDER;
    
    [_infoBar setFrameOrigin:CGPointMake(0, topBorder)];
    [_infoBar setFrameWidth:self.view.bounds.size.width];
//    [self.view insertSubview:_infoBar belowSubview:self.touchView];
    [contentView addSubview:_infoBar];
    [_infoBar setTime1:_recipe.time1];
    [_infoBar setTime2:_recipe.time2];
    [_infoBar setPriceLevel:_recipe.price];
    [_infoBar setDifficulty:_recipe.difficulty];
    
    // note
    UserRecipe* userRecipe = [[ContentDataManager instance] userRecipeForRecipe:_recipe];
    
    if (userRecipe && userRecipe.note) {
        self.notesView.textView.text = userRecipe.note.text;
        [notesView updateIndicator];
    }

    // ingredients
    NSArray* ingredients = [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"IngredientEntry" withPredicate:[NSPredicate predicateWithFormat:@"recipe == %@", _recipe] sortedBy:@"number", nil];
    
    NSMutableArray* ingredientsArray = [NSMutableArray array];
    for (IngredientEntry* entry in ingredients) {

        if (!entry.title) continue;
        
        NSString* unit = entry.ingredient.unit;
        if (!unit) unit = @"";
        
        [ingredientsArray addObject:@[entry.title, [NSNumber numberWithFloat:entry.amount], unit]];
    }
    
    [self.ingredientsView setIngredients:ingredientsArray withBaseScale:_recipe.persons];
    
//    UserRecipe* userRecipe = [[ContentDataManager instance] userRecipeForRecipe:_recipe];
//    if (userRecipe.added) [self.ingredientsView setAdded];
    
    
    // webview
    
//    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_webViewToUse scrollView].bounces = FALSE;
    [_webViewToUse setOpaque : FALSE];
    [_webViewToUse setBackgroundColor : [UIColor clearColor]];

//    // hook delegate to webviews tap gesturerecognizer
//    for (UIGestureRecognizer* recognizer in webView.gestureRecognizers) {
//        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//            alert (@"recognizer found");
//            _webviewRecognizer = recognizer;
//            _webviewRecognizer .delegate = self;
//        }
//    }
    
    [self reloadWebview];
    
//    NSString* basePath = [[NSBundle mainBundle] pathForResource:@"images/full_iPhone" ofType:nil];
//    NSURL* baseURL = [NSURL fileURLWithPath:basePath];
//    
//    fileName = _recipe.text;
//    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
//    NSString* string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    string = [string stringByReplacingOccurrencesOfString:@"FONT_NAME1" withString:FONT.fontName];
//    string = [string stringByReplacingOccurrencesOfString:@"FONT_SIZE1" withString:[NSString stringWithFormat:@"%f", FONT.pointSize]];
//    string = [string stringByReplacingOccurrencesOfString:@"FONT_NAME2" withString:FONT2.fontName];
//    string = [string stringByReplacingOccurrencesOfString:@"FONT_SIZE2" withString:[NSString stringWithFormat:@"%f", FONT2.pointSize]];
//    string = [string stringByReplacingOccurrencesOfString:@"FONT_NAME3" withString:FONT3.fontName];
//    string = [string stringByReplacingOccurrencesOfString:@"FONT_SIZE3" withString:[NSString stringWithFormat:@"%f", FONT3.pointSize]];
//    [webView loadHTMLString:string baseURL:baseURL];
    
    
    [self.contentView setFrameHeight:self.scrollView.bounds.size.height];
    [self.scrollView setContentSize:self.contentView.bounds.size];
    
    
    if (_recipe.tip.length != 0) {

        // IDIOM
        
        if (is_ipad) {
        
            _tipViewController = [[RecipeDetailsTipViewController alloc] initWithText:_recipe.tip];
            _tipViewController.delegate = self;
            _tipViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            _tipViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        }
        else {
            _tipViewController = [[RecipeDetailsTipViewController alloc] initWithText:_recipe.tip];
            _tipViewController.delegate = self;
        }

        tipButton.hidden = false;
    }
    
    
    // favorite
    
    BOOL favorite = [[ContentDataManager instance] isFavoriteForRecipe:_recipe];
    
    [favoriteView setSelected:favorite animated:false];
    
    
    
    // share string
    
    // recipe text
    NSString* HTMLPath = [[NSBundle mainBundle] pathForResource:_recipe.text ofType:nil];
    NSString* HTMLString = [NSString stringWithContentsOfFile:HTMLPath encoding:NSUTF8StringEncoding error:nil];
    HTML2StringScanner* scanner = [[HTML2StringScanner alloc] initWithHTMLString:HTMLString];
    [scanner scan];
    NSString* recipeText = scanner.outputString;
    
    // ingredients text
    NSString* ingText = [IngredientsTextCreator textFromIngredients:ingredientsArray];
    
    _shareString = [NSString stringWithFormat:@"%@\n\nZutaten für %d Personen:\n\n%@", recipeText, _recipe.persons, ingText];
    
//    LogM(@"share_text", @"%@", _shareString);
//    LogM_write(@"share_text");
//    LogM_purge(@"share_text");
    
    
    // fullscreen
    
    UIGestureRecognizer* recognizerFS = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionFullscreen:)];
    recognizerFS.delegate = self;
    [imageView addGestureRecognizer:recognizerFS];
    
    
    // fontsize buttons
    
    [self updateFontsizeButtons];
}





//- (void) viewWillAppear:(BOOL)animated {
//    
//    [self.contentView setFrameHeight:self.scrollView.bounds.size.height];
//    [self.scrollView setContentSize:self.contentView.bounds.size];
//}


- (void) actionTapContent {

    NSLog(@"tap content");
    
    [notesView resign];
    [ingredientsView resign];
    
}


- (void) saveNotes {
    
    UserNote* note = [[[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserNote" withPredicate:[NSPredicate predicateWithFormat:@"recipe.number == %d", _recipe.number] sortedBy:nil] firstElement];

    UserRecipe* userRecipe = [[[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserRecipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", _recipe.number] sortedBy:nil] firstElement];

    if (!userRecipe) {
        
        userRecipe = [[DataManager instanceNamed:@"user"] insertNewObjectForEntityName:@"UserRecipe"];
        userRecipe.number = _recipe.number;
    }
    
    if (!note) {
        
        note = [[DataManager instanceNamed:@"user"] insertNewObjectForEntityName:@"UserNote"];
        note.recipe = userRecipe;
    }
    
    note.text = self.notesView.textView.text;
    
    [[DataManager instanceNamed:@"user"] save];
}


- (void) scrollIfNeededUsingTopHeights:(NSArray*) tops bottomMargin:(float) bottom duration:(float) duration {

    // find biggest top
    
    float topHeight = 0;
    
    for (NSNumber* top in tops) {

        NSLog(@"-top: %@", top);
        
        topHeight = MAX(topHeight, [top floatValue]);
    }
    
    
    NSLog(@"scrollIfNeeded. top: %f, bottom: %f", topHeight, bottom);
    
    float diff = bottom + topHeight - self.view.bounds.size.height;
    
    NSLog(@"diff: %f", diff);
    
    
    if (diff > 0) {
        
        // needs scroll adjustment

//        [self.scrollView setContentOffset:CGPointMake(0, diff) animated:true];

        diff = MIN(diff, INFO_BAR_TOP_BORDER);
        
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void) {
                             self.scrollView.contentOffset = CGPointMake(0, diff);
//                             [self.contentView setFrameHeight:self.contentView.frame.size.height + diff];
                         }
                         completion:nil];
    }
    else if (diff < 0) {

//        [self.scrollView setContentOffset:CGPointMake(0, MAX(0, self.scrollView.contentOffset.y + diff)) animated:true];

        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void) {
//                             self.scrollView.contentOffset = CGPointMake(0, MAX(0, self.scrollView.contentOffset.y + diff));
                             self.scrollView.contentOffset = CGPointMake(0, 0);
//                             [self.contentView setFrameHeight:self.scrollView.frame.size.height];
                         }
                         completion:nil];
    }
}


- (IBAction) actionShowTip {
    
    [_tipViewController getReady];
    
    // IDIOM
    
    if (is_ipad) {
        [((AppDelegateIpad*)[UIApplication sharedApplication].delegate).window.rootViewController presentViewController:_tipViewController animated:true completion:nil];
    }
    else {
        [self.navigationController.parentViewController presentModalViewController:_tipViewController animated:true];
    }
}


- (void) actionFullscreen:(UIGestureRecognizer*) recognizer {

    NSString* fileName = [NSString stringWithFormat:@"_%@_Full.jpg", [_recipe.imageFull stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    [self showImageNamedInFullscreen:fileName];
}


- (void) showImageNamedInFullscreen:(NSString*) name {
    
    // TEST
    
    NSString* imagePath = [RECIPE_IMAGES_FULL stringByAppendingPathComponent:name];
    NSString* fullPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
    UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
    
//    alert(@"path: %@", fullPath);
    
    RecipeDetailsFullscreenViewController* controller =[[RecipeDetailsFullscreenViewController alloc] initWithImage:image];
    controller.delegate = self;
    
    if (is_ipad) {
        
        [((AppDelegateIpad*)[UIApplication sharedApplication].delegate).window.rootViewController presentViewController:controller animated:true completion:nil];
    }
    else {
    
        [self.navigationController.parentViewController presentModalViewController:controller animated:true];
    }
}


- (IBAction) actionFontsizeMinus {
    
    uint currentFontsize = [SettingsManager sharedInstance].fontSize;
    
    if (currentFontsize == UserFontsizeSmall) return;
    
    else {
        
        [SettingsManager sharedInstance].fontSize = currentFontsize - 1;
    }

    [self updateFontsizeButtons];

    [self reloadWebview];
}


- (IBAction) actionFontsizePlus {
    
    uint currentFontsize = [SettingsManager sharedInstance].fontSize;
    
    if (currentFontsize == UserFontsizeLarge) return;
    
    else {
        
        [SettingsManager sharedInstance].fontSize = currentFontsize + 1;
    }

    [self updateFontsizeButtons];

    [self reloadWebview];
}


- (void) reloadWebview {
    
    UserFontsize userFontsize = [SettingsManager sharedInstance].fontSize;
    
    // PROBLEM
    
    float fontSize1ooo = (is_ipad) ? FONT_SIZE1_IPAD : FONT_SIZE1;
    float fontSize2ooo = (is_ipad) ?  FONT_SIZE2_IPAD : FONT_SIZE2;
    
    float fontSize1 = fontSize1ooo + (userFontsize * FONT_SIZE_STRIDE);
    float fontSize2 = fontSize2ooo + (userFontsize * FONT_SIZE_STRIDE);
    
    NSString* basePath = [[NSBundle mainBundle] pathForResource:@"images/iPad" ofType:nil];
    NSURL* baseURL = [NSURL fileURLWithPath:basePath];
    
    NSString* fileName = _recipe.text;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSString* string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    string = [string stringByReplacingOccurrencesOfString:@"FONT_NAME1" withString:FONT_NAME];
    string = [string stringByReplacingOccurrencesOfString:@"FONT_SIZE1" withString:[NSString stringWithFormat:@"%f", fontSize1]];
    string = [string stringByReplacingOccurrencesOfString:@"FONT_NAME2" withString:FONT_NAME];
    string = [string stringByReplacingOccurrencesOfString:@"FONT_SIZE2" withString:[NSString stringWithFormat:@"%f", fontSize2]];
//    string = [string stringByReplacingOccurrencesOfString:@"FONT_NAME3" withString:FONT3.fontName];
//    string = [string stringByReplacingOccurrencesOfString:@"FONT_SIZE3" withString:[NSString stringWithFormat:@"%f", FONT3.pointSize]];
    
    // IDIOM
    
    if (is_ipad) {
        
        string = [string stringByReplacingOccurrencesOfString:@"device-width" withString:[NSString stringWithFormat:@"%dpx",WEBVIEW_CONTENT_WIDTH_IPAD]];
        
        string = [string stringByReplacingOccurrencesOfString:@"<body style=\"margin:20px;margin-top:50px;\">" withString:[NSString stringWithFormat:@"<body style=\"margin:%dpx;margin-top:%dpx;\">", WEBVIEW_CONTENT_MARGIN_IPAD, WEBVIEW_CONTENT_MARGIN_TOP_IPAD]];

        string = [string stringByReplacingOccurrencesOfString:@"width:230px;" withString:[NSString stringWithFormat:@"width:%dpx;",WEBVIEW_CONTENT_CAPTION_WIDTH_IPAD]];

        
    }
    
    if (SYSTEM_VERSION_LESS_THAN__RDVC(@"9.0")) {
        
        [webView_ios8 loadHTMLString:string baseURL:baseURL];
    }
    else {
        
        [webView_ios9 loadHTMLString:string baseURL:baseURL];
    }
}


- (void) updateFontsizeButtons {

    // reset both
//    [fontsizeButtons makeObjectsPerformSelector:@selector(setEnabled:)withObject:@false];
    
    [[fontsizeButtons objectAtIndex:INDEX_FONTSIZE_BUTTON_MINUS] setEnabled:false];
    [[fontsizeButtons objectAtIndex:INDEX_FONTSIZE_BUTTON_PLUS] setEnabled:false];
    
    UserFontsize userFontsize = [SettingsManager sharedInstance].fontSize;
    
    if (userFontsize > UserFontsizeSmall) {
        [[fontsizeButtons objectAtIndex:INDEX_FONTSIZE_BUTTON_MINUS] setEnabled:true];
    }
    
    if (userFontsize < UserFontsizeLarge) {
        [[fontsizeButtons objectAtIndex:INDEX_FONTSIZE_BUTTON_PLUS] setEnabled:true];
    }
}



#pragma mark Delegate Methods

- (void) favoriteViewDidGetSelected:(BOOL)selected {
    
    [[ContentDataManager instance] setFavorite:selected forRecipe:_recipe];
}


- (void) notesViewDidBeginEditing:(NotesView *)view {
    
    NSLog(@"did begin edit");
    
    _notesEditing = true;
    
//    touchView.forwardView = self.notesView.textView;
    
    float keyboardHeight = (is_ipad) ? KEYBOARD_HEIGHT_IPAD : KEYBOARD_HEIGHT_IPHONE;
    float tabbarHeight = (is_ipad) ? 0 : TABBAR_HEIGHT;
    
    float bottom = keyboardHeight - tabbarHeight;
    
    NSLog(@"window height: %f", self.view.window.bounds.size.height);
    NSLog(@"nav bar height: %f", [self.view convertPoint:self.view.frame.origin toView:self.view.window].y);
    NSLog(@"self height: %f", self.view.bounds.size.height);
    
    NSLog(@"bottom: %f", bottom);
    
    // @[[NSNumber numberWithFloat:view.frame.origin.y+view.frame.size.height], [NSNumber numberWithFloat:ingredientsView.frame.origin.y+ingredientsView.frame.size.height]]
    
    // TEST
    
    if (is_ipad) {
        _oldContentSize = scrollView.contentSize;
        CGSize newContentSize = scrollView.contentSize;
        newContentSize.height += 300;
        [scrollView setContentSize:newContentSize];
    }
    
    [self scrollIfNeededUsingTopHeights:@[[NSNumber numberWithFloat:view.frame.origin.y+view.frame.size.height]]
                          bottomMargin:bottom
                              duration:KEYBOARD_DURATION];  // use own duration here
    
}


- (void) notesViewDidEndEditing:(NotesView *)view {
    
    NSLog(@"did end edit");
    
    _notesEditing = false;
    
//    touchView.forwardView = nil;

    float bottom = BOTTOM_MARGIN; // - (self.view.window.bounds.size.height - [self.view convertPoint:self.view.frame.origin toView:self.view.window].y - self.view.bounds.size.height);

    [self scrollIfNeededUsingTopHeights:@[[NSNumber numberWithFloat:view.frame.origin.y+view.frame.size.height], [NSNumber numberWithFloat:ingredientsView.frame.origin.y+ingredientsView.frame.size.height]]
                          bottomMargin:bottom
                              duration:KEYBOARD_DURATION];  // use own duration here
    
    // TEST
    
    if (is_ipad) {
        [scrollView setContentSize:_oldContentSize];
    }
    
    
    [self saveNotes];
}


- (void) notesView:(NotesView *)view willMoveToPosition:(CGPoint)point withDuration:(float)duration {
    
    [self scrollIfNeededUsingTopHeights:@[[NSNumber numberWithFloat:point.y+view.frame.size.height], [NSNumber numberWithFloat:ingredientsView.frame.origin.y+ingredientsView.frame.size.height]]
                          bottomMargin:BOTTOM_MARGIN
                              duration:duration];
}


- (void) ingredientsView:(IngredientsView *)ingView willMoveToPosition:(CGPoint)point withDuration:(float)duration {
    
    [self scrollIfNeededUsingTopHeights:@[[NSNumber numberWithFloat:self.notesView.frame.origin.y+self.notesView.frame.size.height], [NSNumber numberWithFloat:point.y+ingView.frame.size.height]]
                          bottomMargin:BOTTOM_MARGIN
                              duration:duration];
    
    float newContentHeight = MAX([_webViewToUse frame].origin.y + [_webViewToUse frame].size.height,
                                 point.y + ingView.frame.size.height + INGREDIENTS_VIEW_BOTTOM_MARGIN);

    [UIView animateWithDuration:KEYBOARD_DURATION animations:^(void) {
        [contentView setFrameHeight:newContentHeight];
        [scrollView setContentSize:contentView.bounds.size];
    }];
}


- (void) ingredientsViewDidBeginEditing:(IngredientsView *)view {
    
//    touchView.forwardView = self.notesView.textView;
}


- (void) ingredientsViewDidEndEditing:(IngredientsView *)view {
    
//    touchView.forwardView = nil;
    
    NSLog(@"value: %d", [view.textField.text integerValue]);
}


- (void) ingredientsView:(IngredientsView *)view addToShoppingListWithScale:(uint)scale {

    BOOL alreadyAdded = [[ContentDataManager instance] isRecipeAddedToShoppingList:_recipe];
    
    [[ContentDataManager instance] addRecipe:_recipe toShoppingListWithScale:scale];
    
    if (alreadyAdded) {
        [[AlertManager instance] okAlertWithTitle:@"In den Einkaufskorb" message:@"Rezeptzutaten wurden im Einkaufskorb aktualisiert."];
    }
    else {
        [[AlertManager instance] okAlertWithTitle:@"In den Einkaufskorb" message:@"Rezeptzutaten wurden den Einkaufskorb hinzugefügt."];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    
    if (theWebView.loading) return;
    
    
    float posY = theWebView.frame.origin.y;
    
    // ...
    [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
                                                     (int)theWebView.frame.size.width]];
    
    [theWebView setFrameHeight:1];
    CGSize size = [theWebView sizeThatFits: CGSizeMake(theWebView.frame.size.width, 10000)];
    [theWebView setFrameHeight:size.height];
    [theWebView setFrameY: posY];
    
    posY += theWebView.bounds.size.height + 20;
    
//    [contentView setFrameHeight:MAX(posY, scrollView.bounds.size.height)];
//    [scrollView2 setContentSize:webView.bounds.size];
    [contentView setFrameHeight:posY];
    [scrollView setContentSize:contentView.bounds.size];
}


- (void) webView:(WKWebView *)theWebView didFinishNavigation:(WKNavigation *)navigation {
    
    [theWebView evaluateJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
                              (int)theWebView.frame.size.width] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {

        [theWebView setFrameHeight:1];
        
        [theWebView evaluateJavaScript:@"document.height;" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            
            CGFloat height = [obj floatValue];
            [theWebView setFrameHeight:height];

            CGFloat posY = theWebView.frame.origin.y + theWebView.bounds.size.height + 20;
            [contentView setFrameHeight:posY];
            [scrollView setContentSize:contentView.bounds.size];

            NSLog(@"WKWebView height: %f", height);
        }];
        
    }];
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL* url = [request URL];
        NSString* fileName = [[url pathComponents] lastObject];
        [self showImageNamedInFullscreen:fileName];
        return NO;
    } else {
        return YES;
    }
}


- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        NSURL* url = [navigationAction.request URL];
        NSString* fileName = [[url pathComponents] lastObject];
        [self showImageNamedInFullscreen:fileName];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


- (UIImage*) tipViewControllerRequestsBackgroundImage:(RecipeDetailsTipViewController *)controller {
    
    if (is_ipad) {
//        return [((AppDelegateIpad*)[UIApplication sharedApplication].delegate).customNavigationController.parentViewController.view captureImage];
        
        UIImage* image = [((AppDelegateIpad*)[UIApplication sharedApplication].delegate).customNavigationController.view captureImage];
//        return [UIImage imageWithCGImage:image.CGImage scale:0.0f orientation:UIImageOrientationRight];
        return image;
        
    }
    else {
        return [self.navigationController.parentViewController.view captureImage];
    }
}


- (void) tipViewControllerRequestsClosing:(RecipeDetailsTipViewController *)controller {
    
    NSLog(@"contentheight before: %f", scrollView.contentSize.height);
    
    // IDIOM
    
    if (is_ipad) {
        [((AppDelegateIpad*)[UIApplication sharedApplication].delegate).window.rootViewController dismissViewControllerAnimated:true completion:nil];
    }
    else {
        [self.navigationController.parentViewController dismissModalViewControllerAnimated:true];
    }

    NSLog(@"contentheight after: %f", scrollView.contentSize.height);
}

- (void) recipeDetailsFullScreenViewControllerDidRequestClosing:(RecipeDetailsFullscreenViewController *)controller {

    if (is_ipad) {
        [((AppDelegateIpad*)[UIApplication sharedApplication].delegate).window.rootViewController dismissViewControllerAnimated:true completion:nil];
    }
    else {
        [self.navigationController.parentViewController dismissModalViewControllerAnimated:true];
    }
}


- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (gestureRecognizer.view == imageView) {
        
        if (_notesEditing) return false;
        else return true;
    }
    
    else if (gestureRecognizer == _webviewRecognizer) {
        
        return !_notesEditing;
    }
    
    else return true;
}


#pragma mark Delegate Methods

- (void) toggleShareMenu {
    
    NSArray* items = @[imageView.image, _shareString];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    controller.excludedActivityTypes = @[
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
//                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact
                                         ];
    
    // IDIOM
    
    if (is_ipad) {
        _popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        UIButton* item = ((AppDelegateIpad*)[UIApplication sharedApplication].delegate).customNavigationController.shareButton;
        CGRect rect = [self.view convertRect:item.frame toView:self.view];
        [_popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
    }
    else {
        [self.navigationController.parentViewController presentModalViewController:controller animated:true];
    }

}

@end
