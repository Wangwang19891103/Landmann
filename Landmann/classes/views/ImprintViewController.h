//
//  ImprintViewController.h
//  Landmann
//
//  Created by Wang on 03.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


@interface ImprintViewController : UIViewController <WKNavigationDelegate>


@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) WKWebView* webView;

@property (nonatomic, strong) IBOutlet UIView* webViewDummy;

@property (nonatomic, strong) IBOutlet UIView* contentView;

@end
