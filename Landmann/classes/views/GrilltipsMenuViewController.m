//
//  GrilltipsMenuViewController.m
//  Landmann
//
//  Created by Wang on 17.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "GrilltipsMenuViewController.h"
#import "GrilltipsMenuCell.h"
#import "CALayer+Extensions.h"
#import "GrilltipsDetailViewController.h"
#import "GrilltipsDetailViewControllerIpad.h"


@implementation GrilltipsMenuViewController

@synthesize tableView;
@synthesize titleLabel;


- (id) init {
    
    if (self = [super initWithNibName:@"GrilltipsMenuViewController" bundle:[NSBundle mainBundle]]) {
        
        [self loadData];
    }
    
    return self;
}


#pragma mark View

- (void) viewDidLoad {
    
    [super viewDidLoad];
    


    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:resource(@"Images.NavigationBar.GrilltipsImage")];
    self.navigationItem.titleView.contentMode = UIViewContentModeLeft;  //  from right to left, seems to fix the 1px problem in IOS7
//    NSLog(@"titleview frame: %@", NSStringFromCGRect(self.navigationItem.titleView.frame));
    
    //IOS7
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.navigationItem.titleView setFrameHeight:43];
        self.navigationItem.titleView.contentMode = UIViewContentModeBottomRight;
    }

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,60)];
    self.tableView.tableHeaderView.alpha = 0.0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
    self.tableView.tableFooterView.alpha = 0.0;
    self.tableView.clipsToBounds = false;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -13);
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;  // TEST
    
    UIImage* overlay = [resource(@"Images.RecipeMenu.TableView.Overlay") resizableImageWithCapInsets:UIEdgeInsetsMake(60, 0, 30, 0) resizingMode:UIImageResizingModeStretch];
    _overlayView = [[UIImageView alloc] initWithImage:overlay];
    [_overlayView setFrameSize:CGSizeMake(320, self.tableView.contentSize.height)];
    [_overlayView setFrameOrigin:CGPointMake(-16, 0)];
    _overlayView.opaque = false;
//    _overlayView.hidden = true;
    
    
    [self.tableView addSubview:_overlayView];
    self.tableView.autoresizesSubviews = true;
    
    [titleLabel setFrameOrigin:CGPointMake(0, 20)];
    [self.tableView addSubview:titleLabel];
    
    titleLabel.text = @"Für mehr Erfolg beim Grillen";
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // IDIOM
    
    if (is_ipad) {
        GrilltipsDetailViewControllerIpad* controller =[[GrilltipsDetailViewControllerIpad alloc] initWithTip:[_data objectAtIndex:0]];
        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.rightNavigationController pushViewController:controller animated:false];
    }
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
    
    return _data.count;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 73;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    GrilltipsMenuCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"GrilltipsMenuCell"];
    
    if (!cell) {
        
        cell = [GrilltipsMenuCell cell];
        
        
    }
    
    Grilltip* tip = [_data objectAtIndex:indexPath.row];
    cell.titleLabel.text = tip.menuTitle;
    
    BOOL bottom = (indexPath.row == [self.tableView numberOfRowsInSection:0] - 1);
    BOOL top = (indexPath.row == 0);
    
    cell.layer.mask = [CALayer maskLayerWithSize:CGSizeMake(290, 73) roundedCornersTop:top bottom:bottom left:NO right:NO radius:4.0];
    cell.layer.mask.frame = CGRectMake(0, 0, 290, 73);
    cell.layer.masksToBounds = true;
    
    return cell;
}



#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
//    UITableViewCell* cell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelected:true];

    // IDIOM
    
    if (is_ipad) {
        
        GrilltipsDetailViewControllerIpad* controller =[[GrilltipsDetailViewControllerIpad alloc] initWithTip:[_data objectAtIndex:indexPath.row]];

        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.rightNavigationController popViewControllerAnimated:false];
        [((AppDelegateIpad*)[[UIApplication sharedApplication] delegate]).customNavigationController.rightNavigationController pushViewController:controller animated:false];
    }
    else {
    
        GrilltipsDetailViewController* controller =[[GrilltipsDetailViewController alloc] initWithTip:[_data objectAtIndex:indexPath.row]];
        
        UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:backButtonImage forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        controller.navigationItem.leftBarButtonItem = backButtonItem;
        
        [self.navigationController pushViewController:controller animated:true];
    }
    
//    [self performSelector:@selector(deselectCell:) withObject:cell afterDelay:TABLEVIEW_CELL_DESELECTION_DELAY];
}


- (void) deselectCell:(UITableViewCell*) cell {
    
    [cell setSelected:false];
}

- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}




#pragma mark Private Methods

- (void) loadData {
    
    _data = [[ContentDataManager instance] grilltips];
}


@end
