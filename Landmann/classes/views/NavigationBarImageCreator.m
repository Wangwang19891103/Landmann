//
//  NavigationBarImageCreator.m
//  Landmann
//
//  Created by Wang on 02.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "NavigationBarImageCreator.h"


#define IMAGE_SIZE_IPHONE   CGSizeMake(268, 44)
#define IMAGE_SIZE_IPAD     CGSizeMake(284, 44)
#define IMAGE_SIZE          ((is_ipad)?IMAGE_SIZE_IPAD:IMAGE_SIZE_IPHONE)
#define LEFT_MARGIN         52
#define ICON_RECT           CGRectMake(5,6,29,31)
#define ICON_MARGIN_RIGHT   5
#define RIGHT_MARGIN        10
#define FONT_NAME           @"HelveticaNeue-Bold"
#define FONT_SIZE           20.0
#define FONT_COLOR          [UIColor colorWithRed:75.0/255 green:87.0/255 blue:95.0/255 alpha:1.0]
#define BACKGROUND_PATH     @"Images.NavigationBar.Background"
#define ICON_PATH           @"Images.NavigationBar.FeuervogelImage"
#define NAV_BAR_WIDTH_IPHONE        320
#define NAV_BAR_WIDTH_IPAD          336
#define NAV_BAR_WIDTH               ((is_ipad)?NAV_BAR_WIDTH_IPAD:NAV_BAR_WIDTH_IPHONE)


@implementation NavigationBarImageCreator


// algorithmus für Icon direkt links neben dem Text (zusammen zentriert)

+ (UIImage*) createImageWithString:(NSString *)string {
    
    CGSize imageSize = IMAGE_SIZE;

    //IOS7
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        imageSize.height -= 1;  // navigation bar background image has a height offset of minus 1 for some reason
    }
    
    CGRect rect = {{0,0}, imageSize};
    
    //IOS7
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        rect.origin.y -= 1;
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw
    
    // background
    UIImage* bgImage = [resource(BACKGROUND_PATH) resizableImageWithCapInsets:UIEdgeInsetsZero];
    [bgImage drawInRect:rect];
    
//    // icon
//    UIImage* iconImage = resource(ICON_PATH);
//    [iconImage drawInRect:ICON_RECT];
    
    // text
    
    NSDictionary* titleAttributes = [[UINavigationBar appearance] titleTextAttributes];
    NSLog(@"%@", titleAttributes);
    
    UIFont* font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = UITextAlignmentLeft;
    paragraph.lineBreakMode = UILineBreakModeTailTruncation;
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowOffset = CGSizeMake(0, -1);
    //    shadow.shadowBlurRadius = [[UINavigationBar appearance] shadowBlurRadius];
    
    NSLog(@"titleAttributes: %@", titleAttributes);
    
    //TODO: iOS7
    NSDictionary* attributes = nil;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {

        attributes = @{
                                 NSFontAttributeName: [titleAttributes objectForKey:@"Font"],
                                 NSForegroundColorAttributeName: [titleAttributes objectForKey:@"TextColor"],
                                 NSShadowAttributeName: shadow,
                                 NSParagraphStyleAttributeName: paragraph
                                 };
    }
    else {
        
        attributes = @{
                                 NSFontAttributeName: [titleAttributes objectForKey:@"NSFont"],
                                 NSForegroundColorAttributeName: [titleAttributes objectForKey:@"NSColor"],
                                 NSShadowAttributeName: shadow,
                                 NSParagraphStyleAttributeName: paragraph
                                 };
    }

    
//    float iconRightX = ICON_RECT.origin.x + ICON_RECT.size.width;
//    float textMaxWidth = rect.size.width - iconRightX - ICON_MARGIN_RIGHT - RIGHT_MARGIN;
//    CGSize textMaxSize = CGSizeMake(textMaxWidth, rect.size.height);
//    CGSize textSize = [string sizeWithFont:font constrainedToSize:textMaxSize lineBreakMode:paragraph.lineBreakMode];
//    //    float relativeCenterX = 160 - iconRightX;
//    
//    float posX;
//    float posY = (rect.size.height - textSize.height) * 0.5;
//
//    NSLog(@"text width: %f (max: %f)", textSize.width, textMaxSize.width);
//    
//    // case 1: text can be centered
//    if (textSize.width * 0.5 <= 160 - LEFT_MARGIN - iconRightX - ICON_MARGIN_RIGHT) {
//        
//        //        alert(@"CAN be centered");
//        
//        posX = 160 - LEFT_MARGIN - textSize.width * 0.5;
//    }
//    else {
//        
//        //        alert(@"CANT be cantered");
//        
//        posX = iconRightX + ICON_MARGIN_RIGHT;
//    }
//    
//    CGRect textRect = {{posX, posY}, textSize};
//
//    
//    
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
//
//    [attributedString drawInRect:textRect];
    
    
    float textMaxWidth = imageSize.width - ICON_RECT.origin.x - ICON_RECT.size.width - ICON_MARGIN_RIGHT - RIGHT_MARGIN;
    CGSize textMaxSize = CGSizeMake(textMaxWidth, rect.size.height);
    CGSize textSize = [string sizeWithFont:font constrainedToSize:textMaxSize lineBreakMode:paragraph.lineBreakMode];
    
    float posX = (NAV_BAR_WIDTH - textSize.width) * 0.5 - LEFT_MARGIN - (ICON_RECT.origin.x + ICON_RECT.size.width + ICON_MARGIN_RIGHT);
    posX = MAX(posX, ICON_RECT.origin.x);
    float posY = (rect.size.height - textSize.height) * 0.5;
    
    UIImage* iconImage = resource(ICON_PATH);
    [iconImage drawAtPoint:CGPointMake(posX, posY)];

    posX += ICON_RECT.origin.x + ICON_RECT.size.width + ICON_MARGIN_RIGHT;

    CGRect textRect = {{posX, posY}, textSize};

    [attributedString drawInRect:textRect];
    
    
    // /draw
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


// Algorithmus für linksbündiges Icon

//+ (UIImage*) createImageWithString:(NSString *)string {
//    
//    CGRect rect = {{0,0}, IMAGE_SIZE};
//    
//    UIGraphicsBeginImageContextWithOptions(IMAGE_SIZE, false, 0.0f);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // draw
//    
//    // background
//    UIImage* bgImage = [resource(BACKGROUND_PATH) resizableImageWithCapInsets:UIEdgeInsetsZero];
//    [bgImage drawInRect:rect];
//    
//    // icon
//    UIImage* iconImage = resource(ICON_PATH);
//    [iconImage drawInRect:ICON_RECT];
//    
//    // text
//    
//    NSDictionary* titleAttributes = [[UINavigationBar appearance] titleTextAttributes];
//    NSLog(@"%@", titleAttributes);
//    
//    UIFont* font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
//
//    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
//    paragraph.alignment = UITextAlignmentLeft;
//    paragraph.lineBreakMode = UILineBreakModeTailTruncation;
//    
//    NSShadow* shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor darkGrayColor];
//    shadow.shadowOffset = CGSizeMake(0, -1);
////    shadow.shadowBlurRadius = [[UINavigationBar appearance] shadowBlurRadius];
//    
//    NSDictionary* attributes = @{
//                                 NSFontAttributeName: [titleAttributes objectForKey:@"Font"],
//                                 NSForegroundColorAttributeName: [titleAttributes objectForKey:@"TextColor"],
//                                 NSShadowAttributeName: shadow,
//                                 NSParagraphStyleAttributeName: paragraph
//                                 };
//    
//    float iconRightX = ICON_RECT.origin.x + ICON_RECT.size.width;
//    float textMaxWidth = rect.size.width - iconRightX - ICON_MARGIN_RIGHT - RIGHT_MARGIN;
//    CGSize textMaxSize = CGSizeMake(textMaxWidth, rect.size.height);
//    CGSize textSize = [string sizeWithFont:font constrainedToSize:textMaxSize lineBreakMode:paragraph.lineBreakMode];
////    float relativeCenterX = 160 - iconRightX;
//    
//    float posX;
//    float posY = (rect.size.height - textSize.height) * 0.5;
//    
//    NSLog(@"text width: %f (max: %f)", textSize.width, textMaxSize.width);
//    
//    // case 1: text can be centered
//    if (textSize.width * 0.5 <= 160 - LEFT_MARGIN - iconRightX - ICON_MARGIN_RIGHT) {
//        
////        alert(@"CAN be centered");
//        
//        posX = 160 - LEFT_MARGIN - textSize.width * 0.5;
//    }
//    else {
//        
////        alert(@"CANT be cantered");
//        
//        posX = iconRightX + ICON_MARGIN_RIGHT;
//    }
//    
//    CGRect textRect = {{posX, posY}, textSize};
//    
//    
//    
//    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
//
//    [attributedString drawInRect:textRect];
//
//    
//    // /draw
//    
//    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return image;
//}


@end
