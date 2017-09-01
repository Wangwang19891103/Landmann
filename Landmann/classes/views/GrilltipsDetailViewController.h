//
//  GrilltipsDetailViewController.h
//  Landmann
//
//  Created by Wang on 17.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


@interface GrilltipsDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, WKNavigationDelegate> {
    
    UITableViewCell* _imageCell;
    UITableViewCell* _textCell;
    
    UIImageView* _overlayView;
    
    Grilltip* _tip;
}

@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

- (id) initWithTip:(Grilltip*) tip;

@end
