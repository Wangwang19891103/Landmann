//
//  GrilltipsDetailViewControllerIpad.m
//  Landmann
//
//  Created by Wang on 02.06.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "GrilltipsDetailViewControllerIpad.h"


#define TITLETEXTVIEW_INSETS UIEdgeInsetsMake(5,10,0,10)
#define TEXTTEXTVIEW_INSETS UIEdgeInsetsMake(0,10,30,10)
#define TITLEFONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]
#define TEXTFONT [UIFont fontWithName:@"HelveticaNeue" size:16.0]

#define MARGIN_BOTTOM       20
#define TEXTVIEW_INSETS     UIEdgeInsetsMake(15,15,0,15)

#define SIDEVIEW_MARGIN_TOP     20
#define SIDEVIEW_PADDIG         20


@implementation GrilltipsDetailViewControllerIpad


@synthesize scrollView;
@synthesize contentView;
@synthesize webView;
@synthesize sideView;
@synthesize webViewDummy;


- (id) initWithTip:(Grilltip*) tip {
    
    if (self = [super initWithNibName:@"GrilltipsDetailViewControllerIpad" bundle:[NSBundle mainBundle]]) {
        
        _tip = tip;
        
    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self.navigationItem setHidesBackButton:true];

    
//    NSLog(@"textView frame: %@", NSStringFromCGRect(textView.frame));
    
    CGPoint sideViewPosition = CGPointMake(contentView.bounds.size.width - sideView.bounds.size.width, webViewDummy.frame.origin.y);
    
    [sideView setFrameOrigin:sideViewPosition];
    [contentView addSubview:sideView];

    // populate sideView
    
    if (_tip.images.length > 0) {
        
        NSArray* fileNames = [_tip.images componentsSeparatedByString:@","];
        
        float posY = SIDEVIEW_MARGIN_TOP;
        
        for (NSString* fileName in fileNames) {
            
//            NSString* fullpath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
            UIImage* image = [UIImage imageNamed:fileName];
            UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
            
            [imageView setFrameY:posY];
            [sideView addSubview:imageView];
            [imageView centerXInSuperview];
            
            posY += imageView.frame.size.height + SIDEVIEW_PADDIG;
        }
        
        [sideView setFrameHeight:posY];
    }
    

    
    webView = [[WKWebView alloc] initWithFrame:webViewDummy.frame];
    webView.autoresizingMask = webViewDummy.autoresizingMask;
    webView.navigationDelegate = self;
    
    [webViewDummy.superview insertSubview:webView belowSubview:webViewDummy];
    [webViewDummy removeFromSuperview];

    
    
//    NSString* newlineChar = @"\n";
    NSString* dummyNewLineChar= @"\\n";
//    NSString* text = [_tip.text stringByReplacingOccurrencesOfString:dummyNewLineChar withString:newlineChar];
//
//    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n%@", _tip.title, text]];
//    
//    [string addAttribute:NSFontAttributeName value:TITLEFONT range:NSMakeRange(0, _tip.title.length)];
//    [string addAttribute:NSFontAttributeName value:TEXTFONT range:NSMakeRange(_tip.title.length + 2, text.length)];
    
    webView.frame = CGRectInset2(webView.frame, TEXTVIEW_INSETS);

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
    

    webView.scrollView.bounces = FALSE;
//    webView.delegate = self;
    webView.opaque = FALSE;
    webView.backgroundColor = [UIColor clearColor];

    [webView loadHTMLString:htmlString baseURL:nil];

//    float textViewHeight = textView.frame.origin.y + textView.frame.size.height;
//    float sideViewHeight = sideView.frame.origin.y + sideView.frame.size.height;
//    
//    [contentView setFrameHeight:MAX(MAX(scrollView.frame.size.height, textViewHeight), sideViewHeight) + MARGIN_BOTTOM];
//    [scrollView setContentSize:contentView.frame.size];
//    
//    NSLog(@"textView frame: %@", NSStringFromCGRect(textView.frame));

}


//- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
//    
//    if (webView.loading) return;
//    
//    
//    float posY = webView.frame.origin.y;
//    
//    // ...
//    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
//                                                     (int)webView.frame.size.width]];
//    
//    [webView setFrameHeight:1];
//    CGSize size = [webView sizeThatFits: CGSizeMake(webView.frame.size.width, 10000)];
//    [webView setFrameHeight:size.height];
//    [webView setFrameY: posY];
//    
//    posY += webView.bounds.size.height + 20;
//    
//    float textViewHeight = webView.frame.origin.y + webView.frame.size.height;
//    float sideViewHeight = sideView.frame.origin.y + sideView.frame.size.height;
//    
//    [contentView setFrameHeight:MAX(MAX(scrollView.frame.size.height, textViewHeight), sideViewHeight) + MARGIN_BOTTOM];
//    [scrollView setContentSize:contentView.frame.size];
//    
////    NSLog(@"textView frame: %@", NSStringFromCGRect(textView.frame));
//}


- (void) webView:(WKWebView *)theWebView didFinishNavigation:(WKNavigation *)navigation {
    
    [theWebView evaluateJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
                                    (int)theWebView.frame.size.width] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
        [theWebView setFrameHeight:1];
        
        [theWebView evaluateJavaScript:@"document.height;" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            
            float posY = theWebView.frame.origin.y;
            
            CGFloat height = [obj floatValue];
            [theWebView setFrameHeight:height];
            
            posY += webView.bounds.size.height + 20;
            
            float textViewHeight = webView.frame.origin.y + webView.frame.size.height;
            float sideViewHeight = sideView.frame.origin.y + sideView.frame.size.height;
            
            [contentView setFrameHeight:MAX(MAX(scrollView.frame.size.height, textViewHeight), sideViewHeight) + MARGIN_BOTTOM];
            [scrollView setContentSize:contentView.frame.size];
            
            NSLog(@"WKWebView height: %f", height);
        }];
        
    }];
}


- (void) viewDidLayoutSubviews {
    
    float textViewHeight = webView.frame.origin.y + webView.frame.size.height;
    float sideViewHeight = sideView.frame.origin.y + sideView.frame.size.height;
    
    [contentView setFrameHeight:MAX(MAX(scrollView.frame.size.height, textViewHeight), sideViewHeight) + MARGIN_BOTTOM];
    [scrollView setContentSize:contentView.frame.size];
}


@end
