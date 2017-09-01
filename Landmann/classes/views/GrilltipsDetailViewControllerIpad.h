//
//  GrilltipsDetailViewControllerIpad.h
//  Landmann
//
//  Created by Wang on 02.06.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface GrilltipsDetailViewControllerIpad : UIViewController <WKNavigationDelegate> {
    
    Grilltip* _tip;
}


@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) IBOutlet UIView* contentView;

@property (nonatomic, strong) WKWebView* webView;

@property (nonatomic, strong) IBOutlet UIView* webViewDummy;

@property (nonatomic, strong) IBOutlet UIView* sideView;


- (id) initWithTip:(Grilltip*) tip;

@end
