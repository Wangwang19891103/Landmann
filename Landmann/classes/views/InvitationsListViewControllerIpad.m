//
//  InvitationsListViewControllerIpad.m
//  Landmann
//
//  Created by Wang on 27.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "InvitationsListViewControllerIpad.h"
#import <QuartzCore/QuartzCore.h>
#import "InvitationsEditViewController.h"


#define INVITATION_DATA_FILE @"invitations.plist"



@implementation InvitationsListViewControllerIpad


float degree2radians(float deg) {
    
    return (deg / 180) * M_PI;
}


- (id) init {
    
    if (self = [super initWithNibName:@"InvitationsListViewControllerIpad" bundle:[NSBundle mainBundle]]) {

        // index in array equals order of subview adding
        _buttonData = @[
                        
                        @{
                            @"number": @(1),
                            @"rect": @"{{35,117},{218,304}}",
                            @"angle": @(-3.9f)
                            },

                        @{
                            @"number": @(2),
                            @"rect": @"{{787,27},{218,306}}",
                            @"angle": @(6.5)
                            },

                        @{
                            @"number": @(6),
                            @"rect": @"{{537,85},{218,306}}",
                            @"angle": @(-8.2)
                            },

                        @{
                            @"number": @(4),
                            @"rect": @"{{140,373},{218,306}}",
                            @"angle": @(4.6)
                            },

                        @{
                            @"number": @(3),
                            @"rect": @"{{406,395},{218,306}}",
                            @"angle": @(0)
                            },
                        
                        @{
                            @"number": @(5),
                            @"rect": @"{{716,331},{218,306}}",
                            @"angle": @(-0.3)
                            }

                        ];
        

        [self.navigationItem setTitle:@"Karte auswählen"];
        
        NSString* path = [[NSBundle mainBundle] pathForResource:INVITATION_DATA_FILE ofType:nil];
        _invitationData = [NSArray arrayWithContentsOfFile:path];

    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    for (NSDictionary* buttonDict in _buttonData) {
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.anchorPoint = CGPointZero;
        [button setFrame:CGRectFromString([buttonDict objectForKey:@"rect"])];
        button.tag = 1000 + [[buttonDict objectForKey:@"number"] integerValue];
        [button addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];

        float radians = degree2radians([[buttonDict objectForKey:@"angle"] floatValue]);
        CGAffineTransform rotation = CGAffineTransformMakeRotation(radians);
        button.transform = rotation;
        
        [self.view addSubview:button];
    }
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:false];
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:false];
}


- (void) actionButton:(UIButton*) sender {
    
    uint number = sender.tag - 1000;
    
    NSLog(@"number: %d", number);
    
    NSDictionary* data = [_invitationData objectAtIndex:number - 1];
    InvitationsEditViewController* controller = [[InvitationsEditViewController alloc] initWithData:data];
    
    UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;
    
    [self.navigationController pushViewController:controller animated:false];
}


- (void) popViewController {
    
    [self.navigationController popViewControllerAnimated:false];
}


- (IBAction) actionHomeIpad {
    
    [self.navigationController popToRootViewControllerAnimated:false];
}


@end
