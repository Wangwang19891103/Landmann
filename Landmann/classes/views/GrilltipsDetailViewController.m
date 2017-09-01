//
//  GrilltipsDetailViewController.m
//  Landmann
//
//  Created by Wang on 17.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "GrilltipsDetailViewController.h"
#import "CALayer+Extensions.h"


#define TITLETEXTVIEW_INSETS UIEdgeInsetsMake(5,10,0,10)
#define TEXTTEXTVIEW_INSETS UIEdgeInsetsMake(0,10,30,10)
#define TITLEFONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]
#define TEXTFONT [UIFont fontWithName:@"HelveticaNeue" size:14.0]


@implementation GrilltipsDetailViewController


@synthesize tableView;
@synthesize titleLabel;

- (id) initWithTip:(Grilltip*) tip {
    
    if (self = [super initWithNibName:@"GrilltipsDetailViewController" bundle:[NSBundle mainBundle]]) {
        
        _tip = tip;
        
        [self createCells];
        
        
    }
    
    return self;
}


#pragma mark View

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:resource(@"Images.NavigationBar.GrilltipsImage")];
    self.navigationItem.titleView.contentMode = UIViewContentModeLeft;
    //    alert(@"titleview frame: %@", NSStringFromCGRect(self.navigationItem.titleView.frame));
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,60)]; // war 47
    self.tableView.tableHeaderView.alpha = 0.0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
    self.tableView.tableFooterView.alpha = 0.0;
    self.tableView.clipsToBounds = false;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -13);
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    
    UIImage* overlay = [resource(@"Images.RecipeMenu.TableView.Overlay") resizableImageWithCapInsets:UIEdgeInsetsMake(60, 0, 30, 0) resizingMode:UIImageResizingModeStretch];
    _overlayView = [[UIImageView alloc] initWithImage:overlay];
    [_overlayView setFrameSize:CGSizeMake(320, self.tableView.contentSize.height)];
    [_overlayView setFrameOrigin:CGPointMake(-16, 0)]; // war 0
    _overlayView.opaque = false;
//    _overlayView.hidden = true;
    
    
    [self.tableView addSubview:_overlayView];
    self.tableView.autoresizesSubviews = true;
    
    [titleLabel setFrameOrigin:CGPointMake(0, 20)]; // war 7
    [self.tableView addSubview:titleLabel];
    
    titleLabel.text = _tip.menuTitle;
}


- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //    alert(@"titleview frame: %@", NSStringFromCGRect(self.navigationItem.titleView.frame));
    
}


#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {

        case 0:
            return _imageCell.bounds.size.height;
            break;
            
        case 1:
            return _textCell.bounds.size.height;
            
        default:
            return 0;
            break;
    }
 
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {

        case 0:
            return _imageCell;
            break;
            
        case 1:
//            alert(@"textcell frame: %@", NSStringFromCGRect(_textCell.frame));
            return _textCell;
            
        default:
            return nil;
            break;
    }
}







- (void) deselectCell:(UITableViewCell*) cell {
    
    [cell setSelected:false];
}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}


- (void) createCells {
    
    _imageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImageCell"];

    UIImage* image = resource(@"Images.Grilltips.Menu.Image");
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [_imageCell.contentView addSubview:imageView];
    [_imageCell setFrameSize:image.size];

    _imageCell.layer.mask = [CALayer maskLayerWithSize:_imageCell.bounds.size roundedCornersTop:YES bottom:NO left:NO right:NO radius:4.0];
    _imageCell.layer.mask.frame = _imageCell.bounds;
    _imageCell.layer.masksToBounds = true;

    


    
    _textCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextCell"];
    [_textCell setFrameSize:CGSizeMake(290, 10)];
    _textCell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    

    
    
    
//    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(
//                                                                    TEXTTEXTVIEW_INSETS.left,
//                                                                    TITLETEXTVIEW_INSETS.top,
//                                                                    290 - TEXTTEXTVIEW_INSETS.left - TEXTTEXTVIEW_INSETS.right,
//                                                                     30)];
    WKWebView* webView = [[WKWebView alloc] initWithFrame:CGRectMake(
                                                                     TEXTTEXTVIEW_INSETS.left,
                                                                     TITLETEXTVIEW_INSETS.top,
                                                                     290 - TEXTTEXTVIEW_INSETS.left - TEXTTEXTVIEW_INSETS.right,
                                                                     30)];

    
    [_textCell addSubview:webView];
    
    webView.scrollView.bounces = FALSE;
    webView.navigationDelegate = self;
    webView.opaque = FALSE;
    webView.backgroundColor = [UIColor clearColor];
    
    NSString* dummyNewLineChar= @"\\n";
    NSString* htmlString = [NSString stringWithFormat:@""
                            "<html style=\"-webkit-text-size-adjust: none;\">"
                            "<head>"
                            "<meta name=\"viewport\" content=\"width=device-width\"/>"
                            "</head>"
                            "<body><p style=\"font-family:HelveticaNeue-Bold; font-size:18px\">%@"
                            "<br/>"
                            "</p>"
                            "<p style=\"font-family:HelveticaNeue; font-size:14px\">%@</p></body></html>", _tip.title, _tip.text];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:dummyNewLineChar withString:@"<br/>"];

    [webView loadHTMLString:htmlString baseURL:nil];

    
//    // title textview
//    
//
//    float posY = TITLETEXTVIEW_INSETS.top;
//    
//    CGRect rect = UIEdgeInsetsInsetRect(CGRectMake(0, 0, 290, 30), TITLETEXTVIEW_INSETS);
//    
////    alert(@"rect: %@", NSStringFromCGRect(rect));
//
//    UITextView* titleTextView = [[UITextView alloc] initWithFrame:rect];
//    titleTextView.editable = false;
//    titleTextView.backgroundColor = [UIColor whiteColor];
//    titleTextView.font = TITLEFONT;
//    titleTextView.text = _tip.title;
//    [_textCell addSubview:titleTextView];
////    [titleTextView layoutIfNeeded];
//    [titleTextView setFrameSize:titleTextView.contentSize];
//    [titleTextView setFrameY:posY];
//    
//    
//    posY += titleTextView.bounds.size.height + TITLETEXTVIEW_INSETS.bottom;
//    
//    
//    
//    
//    // text textview
//    
//    NSString* newlineChar = @"\n";
//    NSString* dummyNewLineChar= @"\\n";
//    NSString* text = [_tip.text stringByReplacingOccurrencesOfString:dummyNewLineChar withString:newlineChar];
//    
//    rect = UIEdgeInsetsInsetRect(CGRectMake(0, 0, 290, 30), TEXTTEXTVIEW_INSETS);
//    
//    UITextView* textTextView = [[UITextView alloc] initWithFrame:rect];
//    textTextView.editable = false;
//    textTextView.text = text;
//    textTextView.backgroundColor = [UIColor whiteColor];
//    textTextView.font = TEXTFONT;
//    [_textCell addSubview:textTextView];
////    [textTextView layoutIfNeeded];
//    [textTextView setFrameSize:textTextView.contentSize];
//    [textTextView setFrameY:posY];
//    
//    
//    posY += textTextView.bounds.size.height + TEXTTEXTVIEW_INSETS.bottom;
    
//    [_textCell setFrameWidth:290];
//    [_textCell setFrameHeight:posY];
//    
//    _textCell.layer.mask = [CALayer maskLayerWithSize:_textCell.bounds.size roundedCornersTop:NO bottom:YES left:NO right:NO radius:4.0];
//    _textCell.layer.mask.frame = _textCell.bounds;
//    _textCell.layer.masksToBounds = true;
    
}


//- (void)webViewDidFinishLoad:(UIWebView *)theWebView {

- (void) webView:(WKWebView *)theWebView didFinishNavigation:(WKNavigation *)navigation {

    [theWebView evaluateJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
                                    (int)theWebView.frame.size.width] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
        [theWebView setFrameHeight:1];
        
        [theWebView evaluateJavaScript:@"document.height;" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {

            float posY = theWebView.frame.origin.y;

            CGFloat height = [obj floatValue];
            [theWebView setFrameHeight:height];

            posY += theWebView.bounds.size.height + TEXTTEXTVIEW_INSETS.bottom;

            [_textCell setFrameWidth:290];
            [_textCell setFrameHeight:posY];
            
            _textCell.layer.mask = [CALayer maskLayerWithSize:_textCell.bounds.size roundedCornersTop:NO bottom:YES left:NO right:NO radius:4.0];
            _textCell.layer.mask.frame = _textCell.bounds;
            _textCell.layer.masksToBounds = true;
            
            float newContentHeight = self.tableView.contentSize.height - 10 + posY;
            
            [_overlayView setFrameSize:CGSizeMake(320, newContentHeight)];
            
            [self.tableView reloadData];
            
            
            NSLog(@"WKWebView height: %f", height);
        }];
        
    }];
//    
//    
//    
//    
//    
//    
//    
//    
//    if (theWebView.loading) return;
//    
//    
//    float posY = theWebView.frame.origin.y;
//    
//    // ...
//    [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
//                                                     (int)theWebView.frame.size.width]];
//    
//    [theWebView setFrameHeight:1];
//    CGSize size = [theWebView sizeThatFits: CGSizeMake(theWebView.frame.size.width, 10000)];
//    [theWebView setFrameHeight:size.height];
//    [theWebView setFrameY: posY];
//    
//    posY += theWebView.bounds.size.height + TEXTTEXTVIEW_INSETS.bottom;
//    
//    [_textCell setFrameWidth:290];
//    [_textCell setFrameHeight:posY];
//    
//    _textCell.layer.mask = [CALayer maskLayerWithSize:_textCell.bounds.size roundedCornersTop:NO bottom:YES left:NO right:NO radius:4.0];
//    _textCell.layer.mask.frame = _textCell.bounds;
//    _textCell.layer.masksToBounds = true;
//    
//    float newContentHeight = self.tableView.contentSize.height - 10 + posY;
//    
//    [_overlayView setFrameSize:CGSizeMake(320, newContentHeight)];
//    
//    [self.tableView reloadData];

}



@end
