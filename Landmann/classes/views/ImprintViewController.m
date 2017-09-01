//
//  ImprintViewController.m
//  Landmann
//
//  Created by Wang on 03.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "ImprintViewController.h"

@implementation ImprintViewController


@synthesize scrollView;
@synthesize webView;
@synthesize contentView;
@synthesize webViewDummy;


- (id) init {
    
    if (self = [super initWithNibName:@"ImprintViewController" bundle:[NSBundle mainBundle]]) {
        
        [self.navigationItem setTitle:@"Impressum"];
    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    webView = [[WKWebView alloc] initWithFrame:webViewDummy.frame];
    webView.autoresizingMask = webViewDummy.autoresizingMask;
    webView.navigationDelegate = self;
    
    [webViewDummy.superview insertSubview:webView belowSubview:webViewDummy];
    [webViewDummy removeFromSuperview];
    
    webView.scrollView.bounces = FALSE;
    webView.opaque = FALSE;
    webView.backgroundColor = [UIColor clearColor];
    
    NSString* fileName = @"imprint.html";
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSString* string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:string baseURL:nil];
//    [webView setFrameSize:CGSizeMake(320, 1000)];
//    [scrollView setContentSize:webView.bounds.size];
}


//- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
//    
//    if (webView.loading) return;
//    
//    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
//                                                     (int)webView.frame.size.width]];
//    
//    [webView setFrameHeight:1];
//    CGSize size = [webView sizeThatFits: CGSizeMake(webView.frame.size.width, 10000)];
//    [contentView setFrameHeight:size.height + ((is_ipad) ? 30 : 0)];  // IDIOM
//    [webView setFrameHeight:size.height];
//    
//    [scrollView setContentSize:contentView.bounds.size];
//}


- (void) webView:(WKWebView *)theWebView didFinishNavigation:(WKNavigation *)navigation {
    
    [theWebView evaluateJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
                                    (int)theWebView.frame.size.width] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
        [theWebView setFrameHeight:1];
        
        [theWebView evaluateJavaScript:@"document.height;" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            
            CGFloat height = [obj floatValue];
            [theWebView setFrameHeight:height];
            
            [contentView setFrameHeight:height + ((is_ipad) ? 30 : 0)];  // IDIOM
            [scrollView setContentSize:contentView.bounds.size];
            
            NSLog(@"WKWebView height: %f", height);
        }];
        
    }];
}


@end
