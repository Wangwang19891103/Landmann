//
//  InvitationsEditViewController.m
//  Landmann
//
//  Created by Wang on 28.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "InvitationsEditViewController.h"
#import "RecipeImageViewController.h"
#import "ImageItemProvider.h"
#import "InvitationsCardFullscreenViewController.h"
#import <QuartzCore/QuartzCore.h>


#define LARGE_IMAGE_SIZE_IPHONE     CGSizeMake(253,357)
#define LARGE_IMAGE_SIZE_IPAD       CGSizeMake(393,554)

#define FULLSCREEN_IMAGE_SIZE CGSizeMake(320,452)

#define IMAGE_SIZE_PLACEHOLDER      CGSizeMake(320, 452)
#define IMAGE_SIZE_FACEBOOK         CGSizeMake(640, 904)
#define IMAGE_SIZE_EMAIL            CGSizeMake(640, 904)
#define IMAGE_SIZE_PHOTOS           CGSizeMake(1241, 1749)
#define IMAGE_SIZE_PRINT            CGSizeMake(1241, 1749)

#define IMAGE_SIZE_LARGE_PREVIEW    CGSizeMake(1241, 1749)


#define BOTTOM_MARGIN 0
#define KEYBOARD_HEIGHT_IPHONE 216
#define KEYBOARD_HEIGHT_IPAD 352
#define KEYBOARD_DURATION 0.3
#define NAVBAR_HEIGHT 44
#define TABBAR_HEIGHT 49


#define TAG_DATE        1001
#define TAG_TIME        1002
#define TAG_TITLE       1003
#define TAG_STREET      1004
#define TAG_CITY        1005
#define TAG_TEXT        1006

#define IPAD_BUTTON_RECT    CGRectMake(685,624,240,81)
#define IPAD_BUTTON_ANGLE   -2.0

#define IPAD_RECIPEIMAGEVIEWCONTROLLER_POPOVER_CONTENTSIZE      CGSizeMake(320, 600)


@implementation InvitationsEditViewController


@synthesize shadowImage;
@synthesize largeImage;
@synthesize scrollView;
@synthesize topView;
@synthesize contentView;
//@synthesize captureView;
@synthesize formBackgroundImages;
@synthesize dateTimeView;
@synthesize titleView;
@synthesize locationView;
@synthesize textView;
@synthesize photoView;
@synthesize optionalImageView;
@synthesize submitView;
@synthesize previewView;
@synthesize previewImageView;
@synthesize optionalImageLabel;
@synthesize optionalImageButton;
@synthesize textFields;
@synthesize shareMessageView;
@synthesize activityView;


//float degree2radians(float deg) {
//    
//    return (deg / 180) * M_PI;
//}



- (id) initWithData:(NSDictionary*) data {
    
    if (self = [super initWithNibName:@"InvitationsEditViewController" bundle:[NSBundle mainBundle]]) {
        
        _data = data;
        _renderer = [[InvitationCardRenderer alloc] initWithData:data];
        
//        // test data
//        _renderer.title = @"Männerabend";
//        _renderer.text = @"Die Sonne lacht, das Wochenende steht vor der Tür und "
//        "das Bier ist kalt gestellt. Was läge also näher den guten "
//        "Landmann anzufeuern und einen herrlichen Grillabend "
//        "mit Freunden zu verbringen? Ich denke…NICHTS!";
//        _renderer.date = @"24.08.2013";
//        _renderer.time = @"18:00 Uhr";
//        _renderer.street = @"Musterhausenstr. 123b";
//        _renderer.city = @"12345 Musterhausen";
        
        _renderer.showOptionalImage = true;
        
        _keyboardWatcher = [[KeyboardWatcher alloc] init];
        _keyboardWatcher.delegate = self;
        
        [self.navigationItem setTitle:@"Karte bearbeiten"];
        
        _largeImageSize = (is_ipad) ? LARGE_IMAGE_SIZE_IPAD : LARGE_IMAGE_SIZE_IPHONE;
    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    shadowImage.image = [resource(@"Images.Invitations.List.ShadowBackground") resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
    
    
    UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOpenPreview)];
    [largeImage addGestureRecognizer:recognizer];
    
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionClosePreview)];
    [previewImageView addGestureRecognizer:recognizer];
    
    
    // Form
    
    float posY = topView.frame.origin.y + topView.frame.size.height;
    
    // set background images
    
    UIImage* formBackground = [resource(@"Images.Invitations.Edit.Form.Background") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0) resizingMode:UIImageResizingModeStretch];
    
    [formBackgroundImages makeObjectsPerformSelector:@selector(setImage:) withObject:formBackground];
    
    
    // Date & Time
    
    if ([_data valueForKeyPath:@"Elements.Date"] || [_data valueForKeyPath:@"Elements.DateAndTime"]) {

        [dateTimeView setFrameY:posY];
        [dateTimeView setFrameWidth:contentView.frame.size.width];
    
        [contentView addSubview:dateTimeView];
        
        posY += dateTimeView.bounds.size.height;
        
        NSString* date = [_data valueForKeyPath:@"Elements.Defaults.Date"];
        NSString* time = [_data valueForKeyPath:@"Elements.Defaults.Time"];
        
        ((InvitationTextField*)[self.view viewWithTag:TAG_DATE]).textField.text = date;
        ((InvitationTextField*)[self.view viewWithTag:TAG_TIME]).textField.text = time;
        
        _renderer.date = date;
        _renderer.time = time;
    }
    
    
    // Title Text

    if ([_data valueForKeyPath:@"Elements.Title"]) {

        [titleView setFrameY:posY];
        [titleView setFrameWidth:contentView.frame.size.width];

        [contentView addSubview:titleView];
        
        posY += titleView.bounds.size.height;
        
        NSString* title = [_data valueForKeyPath:@"Elements.Defaults.Title"];
        
        ((InvitationTextField*)[self.view viewWithTag:TAG_TITLE]).textField.text = title;
        
        _renderer.title = title;
    }

    
    // Location Text
    
    if ([_data valueForKeyPath:@"Elements.Street"] || [_data valueForKeyPath:@"Elements.Location"]) {

        [locationView setFrameY:posY];
        [locationView setFrameWidth:contentView.frame.size.width];

        [contentView addSubview:locationView];
        
        posY += locationView.bounds.size.height;

        NSString* street = [_data valueForKeyPath:@"Elements.Defaults.Street"];
        NSString* city = [_data valueForKeyPath:@"Elements.Defaults.City"];
        
        ((InvitationTextField*)[self.view viewWithTag:TAG_STREET]).textField.text = street;
        ((InvitationTextField*)[self.view viewWithTag:TAG_CITY]).textField.text = city;
        
        _renderer.street = street;
        _renderer.city = city;

    }
    
    
    // Text
    
    if ([_data valueForKeyPath:@"Elements.Text"]) {

        [textView setFrameY:posY];
        [textView setFrameWidth:contentView.frame.size.width];

        [contentView addSubview:textView];
        
        posY += textView.bounds.size.height;

        NSString* text = [_data valueForKeyPath:@"Elements.Defaults.Text"];
        
        ((InvitationTextView*)[self.view viewWithTag:TAG_TEXT]).textView.text = text;
        
        _renderer.text = text;
    }
    
    
    // Optional Image
    
    if ([_data valueForKeyPath:@"Elements.OptionalImage"]) {
        
        [optionalImageView setFrameY:posY];
        [optionalImageView setFrameWidth:contentView.frame.size.width];
        
        optionalImageLabel.text = [_data valueForKeyPath:@"Elements.OptionalImage.Text"];
        
        [contentView addSubview:optionalImageView];
        
        posY += optionalImageView.bounds.size.height;
    }
    
    
    // Photos
    
    if ([_data valueForKeyPath:@"Elements.CustomImage"]) {

        [photoView setFrameY:posY];
        [photoView setFrameWidth:contentView.frame.size.width];

        [contentView addSubview:photoView];
        
        posY += photoView.bounds.size.height;
    }
    
    
    largeImage.image = [_renderer renderForSize:_largeImageSize mode:InvitationCardRendererRenderModePreview];

    
    
//    // Submit
//    
//    [submitView setFrameY:posY];
//    
//    [contentView addSubview:submitView];
//    
//    posY += submitView.bounds.size.height;
    
    
    // Share Message
    
    [shareMessageView setFrameY:posY];
    
    [contentView addSubview:shareMessageView];
    
    posY += shareMessageView.bounds.size.height;
    
    
    
//    [contentView setFrameHeight:posY];
    
    NSLog(@"scrollview height = %f", scrollView.frame.size.height);
    
    
    // put capture view above all others
    
//    [contentView addSubview:captureView];
    
    
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
    
    // IDIOM
    
    if (is_ipad) [self.view addGestureRecognizer:recognizer];
    else [contentView addGestureRecognizer:recognizer];

    
    // IDIOM
    
    if (is_ipad) {
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.anchorPoint = CGPointZero;
        [button setFrame:IPAD_BUTTON_RECT];
        [button addTarget:self action:@selector(toggleShareMenu) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        
        float radians = (IPAD_BUTTON_ANGLE / 180) * M_PI;
        CGAffineTransform rotation = CGAffineTransformMakeRotation(radians);
        button.transform = rotation;
        
        [self.view addSubview:button];
        
    }
}


- (void) actionTap {
    
    NSLog(@"content tap");
    
    [textFields makeObjectsPerformSelector:@selector(resignFirstResponder)];
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // IDIOM
    
    if (is_ipad) {
        
        [self.navigationController setNavigationBarHidden:false animated:false];
    }
    
    NSLog(@"scrollview height = %f", scrollView.frame.size.height);

    float height = 0;
    
    for (UIView* subview in contentView.subviews) {
        
//        if (subview == captureView) continue;   // skip capture view
        
        height = MAX(height, subview.frame.origin.y + subview.frame.size.height);
    }
    
    scrollView.contentSize = CGSizeMake(contentView.bounds.size.width, height);
    
    // turn off resizing subviews on scrollview (for scrollview resizing when keyboard fades in)
    
    scrollView.autoresizesSubviews = false;
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // IDIOM
    
    if (is_ipad) {

        [self.navigationController setNavigationBarHidden:true animated:false];
    }
}


- (UIView*) sectionViewForTextFieldTag:(uint) tag {
    
    switch (tag) {

        case 1001:
            return dateTimeView;
            break;
            
        case 1002:
            return dateTimeView;
            break;

        case 1003:
            return titleView;
            break;

        case 1004:
            return locationView;
            break;
            
        case 1005:
            return locationView;
            break;

        case 1006:
            return textView;
            break;

        default:
            return nil;
            break;
    }
}


- (void) updateRendererWithData:(id) data forTag:(uint) tag {

    switch (tag) {
            
        case 1001:
            _renderer.date = (NSString*)data;
            break;
            
        case 1002:
            _renderer.time = (NSString*)data;
            break;

        case 1003:
            _renderer.title = (NSString*)data;
            break;

        case 1004:
            _renderer.street = (NSString*)data;
            break;
            
        case 1005:
            _renderer.city = (NSString*)data;
            break;

        case 1006:
            _renderer.text = (NSString*)data;
            break;

        default:
            break;
    }
    
    [self setShowActivityView:true];
    
    largeImage.image = [_renderer renderForSize:_largeImageSize mode:InvitationCardRendererRenderModePreview];
    
    [self setShowActivityView:false];
}


- (void) scrollViewToVisible:(UIView*) view {
    
    float keyboardHeight = (is_ipad) ? KEYBOARD_HEIGHT_IPAD : KEYBOARD_HEIGHT_IPHONE;
    float tabbarHeight = (is_ipad) ? 0 : TABBAR_HEIGHT;
    
    float netKBHeight = keyboardHeight - tabbarHeight;
    float newSBHeight = self.view.frame.size.height - netKBHeight;
    float bottomBorder = view.frame.origin.y + view.frame.size.height;
    
    // TEST
    
    float topBorder = view.frame.origin.y;
    
    // check if topborder is above top border of scrollview

    NSLog(@"SCROLL VIEW TO VISIBLE");
    NSLog(@"keyboardHeight: %f", keyboardHeight);
    NSLog(@"tabbarHeight: %f", tabbarHeight);
    NSLog(@"netKBHeight: %f", netKBHeight);
    NSLog(@"newSBHeight: %f", newSBHeight);
    NSLog(@"topBorder: %f", topBorder);
    NSLog(@"bottomBorder: %f", bottomBorder);

    
    if (topBorder < scrollView.contentOffset.y) {
        
        // set content offset to align topborder with top border of scrollview

        NSLog(@"new offset: %f", topBorder);

        [scrollView setContentOffset:CGPointMake(0, topBorder) animated:true];
    }
    
    // check if bottomborder is below bottom border of scrollview
    
    else if (bottomBorder > scrollView.contentOffset.y + newSBHeight) {
        
        // set content offset to align bottomborder with bottom border of scrollview
        
        NSLog(@"new offset: %f", bottomBorder - scrollView.frame.size.height);
        
        [scrollView setContentOffset:CGPointMake(0, bottomBorder - newSBHeight) animated:true];
    }
    
//        float newOffsetY = bottomBorder + BOTTOM_MARGIN - newSBHeight;
//        
//        [scrollView setContentOffset:CGPointMake(0, newOffsetY) animated:true];
    
    
}


- (void) enterEditingMode {
    
    float keyboardHeight = (is_ipad) ? KEYBOARD_HEIGHT_IPAD : KEYBOARD_HEIGHT_IPHONE;
    float tabbarHeight = (is_ipad) ? 0 : TABBAR_HEIGHT;
    
    float netKBHeight = keyboardHeight - tabbarHeight;
    float newSBHeight = self.view.frame.size.height - netKBHeight;

//    [UIView animateWithDuration:KEYBOARD_DURATION
//                     animations:^(void) {
//                         [scrollView setFrameHeight:newSBHeight];
//                     }];
    
    [scrollView setFrameHeight:newSBHeight];

    
    NSLog(@"ENTER EDITING MODE");
    NSLog(@"keyboardHeight: %f", keyboardHeight);
    NSLog(@"tabbarHeight: %f", tabbarHeight);
    NSLog(@"netKBHeight: %f", netKBHeight);
    NSLog(@"newSBHeight: %f", newSBHeight);

}


- (void) exitEditingMode {
    
//    [UIView animateWithDuration:KEYBOARD_DURATION
//                     animations:^(void) {
//                         [scrollView setFrameHeight:self.view.frame.size.height];
//                     }];
    
//    [scrollView setFrameHeight:self.view.frame.size.height];


    /*******/
//    CGPoint currentContentOffset = _scrollView.contentOffset;
//    [_scrollView setFrameHeight:_originalHeight];
//    [_scrollView setContentOffset:currentContentOffset animated:FALSE];
//    [_scrollView setContentOffset:CGPointZero animated:TRUE];
    
    CGPoint currentContentOffset = scrollView.contentOffset;
    float heightDiff = self.view.frame.size.height -  scrollView.frame.size.height;
    CGPoint newContentOffset = CGPointMake(currentContentOffset.x, MAX(0.0, currentContentOffset.y - heightDiff));
    [scrollView setFrameHeight:self.view.frame.size.height];
    [scrollView setContentOffset:currentContentOffset animated:false];
    [scrollView setContentOffset:newContentOffset animated:TRUE];
}


- (void) setShowActivityView:(BOOL) show {

    return;
    
//    activityView.hidden = !show;
    if (show) [activityView startAnimating];
    else [activityView stopAnimating];
    
    [activityView setNeedsDisplay];
}



#pragma mark Actions

- (IBAction) actionPhotoAlbum {
    
    UIImagePickerController* controller = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;

        // IDIOM
        
        if (is_ipad) {
            
            CGRect rect = [self.view.window convertRect:photoView.frame toWindow:self.view.window];;
            
            _popover = [[UIPopoverController alloc] initWithContentViewController:controller];
//            _popover.delegate = self;  // not needed
            [_popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:true];
        }
        else {
            [self.navigationController.parentViewController presentModalViewController:controller animated:true];
        }
    }
    else {
        
//        alert(@"Fehler: Fotoalbum nicht verfügbar.");
    }
}


- (IBAction) actionPhotoCamera {

    UIImagePickerController* controller = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.delegate = self;
        
        // IDIOM
        
        if (is_ipad) {
//            [((AppDelegateIpad*)[UIApplication sharedApplication].delegate).customNavigationController.parentViewController presentViewController:controller animated:true completion:nil];
            
            CGRect rect = [self.view.window convertRect:photoView.frame toWindow:self.view.window];;

            _popover = [[UIPopoverController alloc] initWithContentViewController:controller];
            [_popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:true];
        }
        [self.navigationController.parentViewController presentModalViewController:controller animated:true];
    }
    else {
        
        alert(@"Fehler: Kamera nicht verfügbar.");
    }
}


- (IBAction) actionPhotoRecipe {
    
    RecipeImageViewController* controller = [[RecipeImageViewController alloc] init];
    controller.delegate = self;
    
    // IDIOM
    
    if (is_ipad) {
        
        CGRect rect = [self.view.window convertRect:photoView.frame toWindow:self.view.window];;
        
        _popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        _popover.popoverContentSize = IPAD_RECIPEIMAGEVIEWCONTROLLER_POPOVER_CONTENTSIZE;
        [_popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:true];
    }
    else {
        [self.navigationController.parentViewController presentModalViewController:controller animated:true];
    }

}


- (IBAction) actionPhotoDefault {
    
    _renderer.customImage = nil;
    
    [self setShowActivityView:true];
    
    largeImage.image = [_renderer renderForSize:_largeImageSize mode:InvitationCardRendererRenderModePreview];

    [self setShowActivityView:false];
}


//- (IBAction) actionSubmit {
//    
////    NSDate* date = [NSDate date];
////    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
////    [formatter setDateFormat:@"yyMMdd_HHmmss"];
////    NSString* fileName = [NSString stringWithFormat:@"Landmann_%@", [formatter stringFromDate:date]];
////    
////    NSLog(@"filename: %@", fileName);
//    
//    UIImage* image = [_renderer renderForSize:FULLSCREEN_IMAGE_SIZE];
//    
////    UIImageWriteToSavedPhotosAlbum(image, self, @selector(handleWriteImageComplete), nil);
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(handleWriteImageComplete:didFinishSavingWithError:contextInfo:), nil);
//}


- (void) actionOpenPreview {
    
//    [previewView setFrameSize:self.view.bounds.size];
//    
//    previewImageView.image = [_renderer renderForSize:FULLSCREEN_IMAGE_SIZE];
//    [previewImageView setFrameSize:FULLSCREEN_IMAGE_SIZE];
//    
//    [(UIScrollView*)previewImageView.superview setContentSize:FULLSCREEN_IMAGE_SIZE];
//    
//    NSLog(@"contentsize: %@", NSStringFromCGSize(((UIScrollView*)previewImageView.superview).contentSize));
//    NSLog(@"scrollview height: %@", NSStringFromCGRect(((UIScrollView*)previewImageView.superview).frame));
//    
//    [self.view addSubview:previewView];
    
    UIImage* image = [_renderer renderForSize:IMAGE_SIZE_LARGE_PREVIEW mode:InvitationCardRendererRenderModeFull];
    
    InvitationsCardFullscreenViewController* controller = [[InvitationsCardFullscreenViewController alloc] initWithImage:image];
    controller.delegate = self;
    
    // IDIOM
    
    if (is_ipad) {
        
        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:true completion:nil];
    }
    else {
        [self.navigationController.parentViewController presentModalViewController:controller animated:true];
    }
}


//- (void) actionFullscreen:(UIGestureRecognizer*) recognizer {
//    
//    NSString* fileName = [NSString stringWithFormat:@"_%@_Full.jpg", [_recipe.imageFull stringByReplacingOccurrencesOfString:@" " withString:@""]];
//    
//    [self showImageNamedInFullscreen:fileName];
//}
//
//
//- (void) showImageNamedInFullscreen:(NSString*) name {
//    
//    NSString* imagePath = [RECIPE_IMAGES_FULL_IPAD stringByAppendingPathComponent:name];
//    NSString* fullPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
//    UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
//    
//    //    alert(@"path: %@", fullPath);
//    
//    RecipeDetailsFullscreenViewController* controller =[[RecipeDetailsFullscreenViewController alloc] initWithImage:image];
//    controller.delegate = self;
//    
//    [self.navigationController.parentViewController presentModalViewController:controller animated:true];
//}


//- (void) actionClosePreview {
//
//    [previewView removeFromSuperview];
//}


- (IBAction) actionOptionalImage:(UIButton*) sender {

    sender.selected = !sender.selected;
    
    _renderer.showOptionalImage = sender.selected;
    
    largeImage.image = [_renderer renderForSize:_largeImageSize mode:InvitationCardRendererRenderModePreview];
}


- (IBAction) actionHomeIpad {
    
    [self.navigationController popToRootViewControllerAnimated:false];
}


- (void) handleWriteImageComplete: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    NSLog(@"error: %@", error);
    
    if (error) {
        
        [[AlertManager instance] okAlertWithTitle:@"Karte speichern" message:@"Fehler beim Speichern in das Fotoalbum."];
    }
    else {
    
        [[AlertManager instance] okAlertWithTitle:@"Karte speichern" message:@"Die Karte wurde erfolgreich in das Fotoalbum gespeichert."];
    }
}



#pragma mark Delegate Methods

- (void) invitationTextFieldDidBeginEditing:(InvitationTextField *)textField {
    
    UIView* sectionView = [self sectionViewForTextFieldTag:textField.tag];
    
    _storedContentOffset = scrollView.contentOffset;
    
//    [self enterEditingMode];
    
    [self scrollViewToVisible:sectionView];
}


- (void) invitationTextFieldDidChangeValue:(id)textField {
    
}


- (void) invitationTextFieldDidEndEditing:(InvitationTextField *)textField {

//    [self exitEditingMode];

//    [scrollView setContentOffset:_storedContentOffset animated:true];
    
    [self updateRendererWithData:textField.textField.text forTag:textField.tag];
}


//- (void) eventCaptureViewWasTapped:(EventCaptureView *)captureView {
//
//    [textFields makeObjectsPerformSelector:@selector(resignFirstResponder)];
//}


- (void) invitationTextViewDidBeginEditing:(InvitationTextView *)ptextView {
    
    UIView* sectionView = [self sectionViewForTextFieldTag:ptextView.tag];
    
    _storedContentOffset = scrollView.contentOffset;
    
//    [self enterEditingMode];
    
    [self scrollViewToVisible:sectionView];
}


- (void) invitationTextViewDidChangeValue:(InvitationTextView *)textView {
    
}


- (void) invitationTextViewDidEndEditing:(InvitationTextView *)ptextView {
    
//    [self exitEditingMode];
    
//    [scrollView setContentOffset:_storedContentOffset animated:true];
    
    [self updateRendererWithData:ptextView.textView.text forTag:ptextView.tag];
}


- (void) keyboardWillShow {
    
    NSLog(@"will show");
}


- (void) keyboardDidShow {

    NSLog(@"did show");
    
    [self enterEditingMode];

}


- (void) keyboardWillHide {
    
    NSLog(@"will hide");

    [self exitEditingMode];
}


- (void) keyboardDidHide {
    
    NSLog(@"did hide");
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"media info: %@", info);
    
    _renderer.customImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    largeImage.image = [_renderer renderForSize:_largeImageSize mode:InvitationCardRendererRenderModePreview];
    
    // IDIOM
    
    if (is_ipad) {
        [_popover dismissPopoverAnimated:true];
    }
    else {
        [self.navigationController.parentViewController dismissModalViewControllerAnimated:true];
    }
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    NSLog(@"picker cancel");

    // IDIOM
    
    if (is_ipad) {
        [_popover dismissPopoverAnimated:true];
    }
    else {
        [self.navigationController.parentViewController dismissModalViewControllerAnimated:true];
    }
}


- (void) toggleShareMenu {
    
    CGSize sizes[5] = {
        IMAGE_SIZE_PLACEHOLDER,
        IMAGE_SIZE_EMAIL,
        IMAGE_SIZE_FACEBOOK,
        IMAGE_SIZE_PHOTOS,
        IMAGE_SIZE_PRINT
    };
    
    ImageItemProvider* imageProvider = [[ImageItemProvider alloc] initWithRenderer:_renderer imageSizes:sizes];
    
    NSArray* items = @[imageProvider];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    controller.excludedActivityTypes = @[
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
//                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact
                                         ];
    
    // IDIOM
    
    if (is_ipad) {
        _popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [_popover presentPopoverFromRect:IPAD_BUTTON_RECT inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:true];
    }
    else {
        [self.navigationController.parentViewController presentModalViewController:controller animated:true];
    }
    
    

}



- (void) recipeImageViewController:(RecipeImageViewController *)controller didPickRecipeImage:(UIImage *)image {
    
    _renderer.customImage = image;
    
    // IDIOM
    
    if (is_ipad) {
        [_popover dismissPopoverAnimated:true];
    }
    else {
        [self.navigationController.parentViewController dismissModalViewControllerAnimated:true];
    }

    largeImage.image = [_renderer renderForSize:_largeImageSize mode:InvitationCardRendererRenderModePreview];
}


- (void) invitationsCardFullScreenViewControllerDidRequestClosing:(InvitationsCardFullscreenViewController *)controller {

    if (is_ipad) {
        [self dismissViewControllerAnimated:true completion:nil];
    }
    else {
        [self.navigationController.parentViewController dismissModalViewControllerAnimated:true];
    }
}


- (BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    
    return true;
}


- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
}

@end















