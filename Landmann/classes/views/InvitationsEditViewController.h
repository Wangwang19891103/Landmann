//
//  InvitationsEditViewController.h
//  Landmann
//
//  Created by Wang on 28.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitationCardRenderer.h"
#import "InvitationTextFieldDelegate.h"
//#import "EventCaptureView.h"
//#import "EventCaptureViewDelegate.h"
#import "InvitationTextField.h"
#import "InvitationTextViewDelegate.h"
#import "InvitationTextView.h"
#import "KeyboardWatcher.h"
#import "KeyboardWatcherDelegate.h"
#import "ShareProtocol.h"
#import "RecipeImageViewControllerDelegate.h"
#import "InvitationsCardFullscreenViewControllerDelegate.h"



@interface InvitationsEditViewController : UIViewController <InvitationTextFieldDelegate, // EventCaptureViewDelegate,
    InvitationTextViewDelegate,
    KeyboardWatcherDelegate,    UIImagePickerControllerDelegate, UINavigationControllerDelegate, ShareProtocol, RecipeImageViewControllerDelegate, InvitationsCardFullscreenViewControllerDelegate, UIPopoverControllerDelegate> {

    NSDictionary* _data;
    InvitationCardRenderer* _renderer;
    
    CGPoint _storedContentOffset;
        
        KeyboardWatcher* _keyboardWatcher;
        
        CGSize _largeImageSize;
        
        UIPopoverController* _popover;
}

@property (nonatomic, strong) IBOutlet UIImageView* shadowImage;

@property (nonatomic, strong) IBOutlet UIImageView* largeImage;


@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) IBOutlet UIView* topView;

@property (nonatomic, strong) IBOutlet UIView* contentView;

//@property (nonatomic, strong) IBOutlet EventCaptureView* captureView;

@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray* formBackgroundImages;

@property (nonatomic, strong) IBOutlet UIView* dateTimeView;

@property (nonatomic, strong) IBOutlet UIView* titleView;

@property (nonatomic, strong) IBOutlet UIView* locationView;

@property (nonatomic, strong) IBOutlet UIView* textView;

@property (nonatomic, strong) IBOutlet UIView* photoView;

@property (nonatomic, strong) IBOutlet UIView* optionalImageView;

@property (nonatomic, strong) IBOutlet UIView* submitView;

@property (nonatomic, strong) IBOutlet UIView* shareMessageView;

@property (nonatomic, strong) IBOutlet UIView* previewView;

@property (nonatomic, strong) IBOutlet UIImageView* previewImageView;

@property (nonatomic, strong) IBOutlet UILabel* optionalImageLabel;

@property (nonatomic, strong) IBOutlet UIButton* optionalImageButton;

@property (nonatomic, strong) IBOutletCollection(id) NSArray* textFields;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* activityView;


- (id) initWithData:(NSDictionary*) data;

- (IBAction) actionPhotoAlbum;
- (IBAction) actionPhotoCamera;
- (IBAction) actionPhotoRecipe;
- (IBAction) actionPhotoDefault;
- (IBAction) actionSubmit;
- (void) actionClosePreview;
- (void) actionOpenPreview;
- (IBAction) actionOptionalImage:(UIButton*) sender;

- (IBAction) actionHomeIpad;


@end
