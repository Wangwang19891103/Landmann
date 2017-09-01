//
//  GrilltipsMenuViewController.h
//  Landmann
//
//  Created by Wang on 17.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrilltipsMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray* _data;

    UIImageView* _overlayView;

}

@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@end
