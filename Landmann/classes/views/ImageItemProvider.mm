//
//  ImageItemProvider.m
//  Landmann
//
//  Created by Wang on 26.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "ImageItemProvider.h"


#define IMAGE_SIZE_INDEX_PLACEHOLDER 0
#define IMAGE_SIZE_INDEX_EMAIL 1
#define IMAGE_SIZE_INDEX_FACEBOOK 2
#define IMAGE_SIZE_INDEX_PHOTOS 3
#define IMAGE_SIZE_INDEX_PRINT 4


@implementation ImageItemProvider


- (id) initWithRenderer:(InvitationCardRenderer *)renderer imageSizes:(CGSize[5])sizes {
    
//    UIImage* placeholderImage = [self createPlaceholderImageWithSize:sizes[IMAGE_SIZE_INDEX_PLACEHOLDER]];
    
    UIImage* placeholderImage = [renderer renderForSize:sizes[IMAGE_SIZE_INDEX_PLACEHOLDER] mode:InvitationCardRendererRenderModePreview];
    
    if (self = [super initWithPlaceholderItem:placeholderImage]) {
        
        _renderer = renderer;
        _sizes = new CGSize[5] {
            sizes[0],
            sizes[1],
            sizes[2],
            sizes[3],
            sizes[4]
        };
        
    }
    
    return self;
}


- (id) item {
    
    NSLog(@"- (id) item");
    
    CGSize size;
    
    if ([self.activityType isEqualToString:UIActivityTypeMail]) {
        
        size = _sizes[IMAGE_SIZE_INDEX_EMAIL];
    }
    else if ([self.activityType isEqualToString:UIActivityTypePostToFacebook]) {
     
        size = _sizes[IMAGE_SIZE_INDEX_FACEBOOK];
    }
    else if ([self.activityType isEqualToString:UIActivityTypeSaveToCameraRoll]) {
    
        size = _sizes[IMAGE_SIZE_INDEX_PHOTOS];
    }
    else if ([self.activityType isEqualToString:UIActivityTypePrint]) {
        
        size = _sizes[IMAGE_SIZE_INDEX_PRINT];
    }
    else {
        
        size = _sizes[IMAGE_SIZE_INDEX_EMAIL];
    }
    
    UIImage* image = [_renderer renderForSize:size mode:InvitationCardRendererRenderModeFull];
    
    return image;
}


- (UIImage*) createPlaceholderImageWithSize:(CGSize) size {

    UIGraphicsBeginImageContextWithOptions(size, true, 1.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextFillRect(context, (CGRect){{0,0},size});
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
