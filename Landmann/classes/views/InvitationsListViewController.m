//
//  InvitationsListViewController.m
//  Landmann
//
//  Created by Wang on 28.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "InvitationsListViewController.h"
#import "InvitationsEditViewController.h"


#define INVITATION_DATA_FILE @"invitations.plist"


@implementation InvitationsListViewController


@synthesize shadowImage;
@synthesize largeImage;
@synthesize cardList;


- (id) init {
    
    if (self = [super initWithNibName:@"InvitationsListViewController" bundle:[NSBundle mainBundle]]) {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:INVITATION_DATA_FILE ofType:nil];
        _invitationData = [NSArray arrayWithContentsOfFile:path];
        
        [self.navigationItem setTitle:@"Einladen"];

        _selectedIndex = 0;
    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];

    shadowImage.image = [resource(@"Images.Invitations.List.ShadowBackground") resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
    
    largeImage.image = [UIImage imageNamed:[[_invitationData objectAtIndex:0] valueForKeyPath:@"Preview.Large"]];

    NSMutableArray* images = [NSMutableArray array];
    
    for (NSDictionary* dict in _invitationData) {
        
        NSString* imageName = [dict valueForKeyPath:@"Preview.Thumbnail"];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    
    [cardList setImages:images];
    
//    InvitationsCardList* invitationsCardList = [[InvitationsCardList alloc] initWithImages:images];
//    [invitationsCardList setFrame:cardList.frame];
//    invitationsCardList.autoresizingMask = cardList.autoresizingMask;
//    [cardList.superview addSubview:invitationsCardList];
//    [cardList removeFromSuperview];
//    cardList = invitationsCardList;
    
}


- (IBAction) actionNext {
    
    NSLog(@"next");
    
    NSDictionary* data = [_invitationData objectAtIndex:_selectedIndex];
    InvitationsEditViewController* controller = [[InvitationsEditViewController alloc] initWithData:data];

    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;
    
    [self.navigationController pushViewController:controller animated:true];
}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
}



#pragma mark Delegate Methods

- (void) cardList:(InvitationsCardList*)cardList didSelectImageAtIndex:(uint)index {
    
    largeImage.image = [UIImage imageNamed:[[_invitationData objectAtIndex:index] valueForKeyPath:@"Preview.Large"]];
    
    _selectedIndex = index;
}




@end
