//
//  InvitationCardRenderer.m
//  Landmann
//
//  Created by Wang on 28.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "InvitationCardRenderer.h"


#define RELATIVE_IMAGE_SIZE CGSizeMake(253,357)

#define PREVIEW_SIZE_IPHONE     CGSizeMake(253,357)
#define PREVIEW_SIZE_IPAD       CGSizeMake(393,554)


float degreesToRadians(float degrees) {
    
    return (degrees / 360.0) * 2 * M_PI;
}


@implementation InvitationCardRenderer


@synthesize date, time, street, city, title, text, customImage, showOptionalImage;


- (id) initWithData:(NSDictionary*) data {
    
    if (self = [super init]) {
        
        _data = data;
        
        date = @"";
        time = @"";
        street = @"";
        city = @"";
        title = @"";
        text = @"";
        _backgroundImage = [UIImage imageNamed:[_data valueForKeyPath:@"Elements.BackgroundImage"]];
        _customImageDefault = [UIImage imageNamed:[_data valueForKeyPath:@"Elements.CustomImage.DefaultImage"]];
        _customImage = _customImageDefault;
        _optionalImage = [UIImage imageNamed:[_data valueForKeyPath:@"Elements.OptionalImage.Image"]];
        
        _backgroundImagePreview = [self createPreviewImageFromImage:_backgroundImage];
        _customImagePreview = [self createPreviewImageFromImage:_customImageDefault];
        _optionalImagePreview = [self createPreviewImageFromImage:_optionalImage];
    }
    
    return self;
}


- (void) setCustomImage:(UIImage *)p_customImage {
    
    if (!p_customImage) {
        _customImage = _customImageDefault;
    }
    else {
//        _customImage = p_customImage;
        _customImage = [self rotateImageIfNeeded:p_customImage];
//        _customImage = [UIImage imageWithCGImage:p_customImage.CGImage scale:p_customImage.scale orientation:UIImageOrientationUp];
//        _customImage = [self rotateImage:p_customImage];
    }
    
    _customImagePreview = [self createPreviewImageFromImage:_customImage];
    
//    [_customImage saveInDocumentsWithName:@"customImage"];
//    [_customImagePreview saveInDocumentsWithName:@"customImagePreview"];
    
//    [_customImageDefault saveInDocumentsWithName:@"customImage.png"];
}


- (UIImage*) rotateImageIfNeeded:(UIImage*) image {
    
    if (!image) return nil;
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    
    //    CGSize targetSize = RELATIVE_IMAGE_SIZE;
//    CGSize targetSize = image.size;
    
    // scaling ratio
//    float ratio = targetSize.width / image.size.width;
//    CGAffineTransform transformScale =  CGAffineTransformMakeScale(ratio, ratio);
    
//    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
//    rect = CGRectApplyAffineTransform(rect, transformScale);
    
    
    UIGraphicsBeginImageContextWithOptions(image.size, FALSE, 1.0f);
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw
    
    
    [image drawAtPoint:CGPointZero];
    
    
    // /draw
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //    [image saveInDocumentsWithName:@"temp.png"];
    
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage*) createPreviewImageFromImage:(UIImage*) image {
    
    if (!image) return nil;
    
    
//    CGSize targetSize = RELATIVE_IMAGE_SIZE;
    CGSize targetSize = (is_ipad) ? PREVIEW_SIZE_IPAD : PREVIEW_SIZE_IPHONE;
    
    // scaling ratio
    float ratio = targetSize.width / image.size.width;
    CGAffineTransform transformScale =  CGAffineTransformMakeScale(ratio, ratio);

    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    rect = CGRectApplyAffineTransform(rect, transformScale);

    
    UIGraphicsBeginImageContextWithOptions(rect.size, FALSE, 1.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // draw
    
    
    [image drawInRect:rect];
    
    
    // /draw
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
//    [image saveInDocumentsWithName:@"temp.png"];

    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage*) renderForSize:(CGSize) size mode:(InvitationCardRendererRenderMode) mode {
    
    // handle mode
    
    UIImage* backgroundImage = (mode == InvitationCardRendererRenderModePreview) ? _backgroundImagePreview : _backgroundImage;
    UIImage* localCustomImage = (mode == InvitationCardRendererRenderModePreview) ? _customImagePreview : _customImage;
    UIImage* optionalImage = (mode == InvitationCardRendererRenderModePreview) ? _optionalImagePreview : _optionalImage;
    
    
    NSLog(@"[InvitationCardRenderer] rendering for size: %@", NSStringFromCGSize(size));
    
    
    static float __relativeAspectRatio = 0;
    if (__relativeAspectRatio == 0) __relativeAspectRatio = RELATIVE_IMAGE_SIZE.width / RELATIVE_IMAGE_SIZE.height;
    
    float aspectRatio = size.width / size.height;
    
    
    if (aspectRatio - __relativeAspectRatio > 0.001) {
        
//        alert(@"InvitationCardRenderer error: trying to render with a size that doesnt have the proper aspect ratio");
    }

    
    // scaling ratio
    float ratio = size.width / RELATIVE_IMAGE_SIZE.width;
    CGAffineTransform transformScale =  CGAffineTransformMakeScale(ratio, ratio);
    
    
    UIGraphicsBeginImageContextWithOptions(size, FALSE, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // draw

    UIImage* image = nil;
    NSString* string = nil;
    CGRect rect;
    UIFont* font = nil;
    UIColor* color = nil;
    UITextAlignment alignment;
    CGSize textSize;
    NSLineBreakMode lineBreakMode;
    
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // 1. Custom Image ---------------------------------

    image = localCustomImage;
    
//    [image saveInDocumentsWithName:@"localcustomimage.png"];
    
//    if (!customImage) {
//        
//        image = _customImage;
//
//    }
//    else {
//
//        image = customImage;
//    }

    rect = CGRectFromString([_data valueForKeyPath:@"Elements.CustomImage.Rect"]);
    
    float finalRatio = rect.size.width / rect.size.height;
    float customRatio;
    
//    alert(@"orientation: %d, width: %f, height: %f", image.imageOrientation, image.size.width, image.size.height);
    
    /*
    if (image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationDown) {
    
        customRatio = image.size.width / image.size.height;
    }
    else {
        
        customRatio = image.size.height / image.size.width;
    }
     */
    
    customRatio = image.size.width / image.size.height;

    
    NSLog(@"finalratio: %f", finalRatio);
    NSLog(@"customratio: %f", customRatio);
    
    if (customRatio > finalRatio) {  // custom image WIDTH is too large
        
        // resize to HEIGHT / cut off left and right
        
        NSLog(@"resize to height");
        
        float newWidth = finalRatio * image.size.height;
        float newX = floor((image.size.width - newWidth) * 0.5);
        CGRect cropRect = CGRectMake(newX, 0, newWidth, image.size.height);
        NSLog(@"croping from size %@ to rect %@", NSStringFromCGSize(image.size), NSStringFromCGRect(cropRect));
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, cropRect) scale:0.0f orientation:image.imageOrientation];
    }
    else if (customRatio < finalRatio) {  // custom image HEIGHT is too large
        
        // resize to WIDTH / cut off top and bottom
        
        NSLog(@"resize to width");
        
        float newHeight = image.size.width / finalRatio;
        float newY = floor((image.size.height - newHeight) * 0.5);
        CGRect cropRect = CGRectMake(0, newY, image.size.width, newHeight);
        NSLog(@"croping from size %@ to rect %@", NSStringFromCGSize(image.size), NSStringFromCGRect(cropRect));
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, cropRect) scale:0.0f orientation:image.imageOrientation];
    }
    
    

    rect = CGRectApplyAffineTransform(rect, transformScale);

    
    
//    image = resizedImage(image, rect);

//    [image saveInDocumentsWithName:@"BG"];
    
//    NSLog(@"customImage: %@ (size: %f, %f, scale: %f, orientation: %f)", image, image.size.width, image.size.height, image.scale, image.imageOrientation);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));

    // needs code to resize and center the custom image to proper rect
    
//    alert(@"custom image rect: %@ (ratio: %f)", NSStringFromCGRect(rect), (rect.size.width / rect.size.height));
    
//    alert(@"customRatio: %f", customRatio);
    
    
    [image drawInRect:rect];

    
    
    
    // 2. Background Image --------------------------------
    
    image = backgroundImage;
    rect = CGRectMake(0, 0, size.width, size.height);
//    rect = CGRectApplyAffineTransform(rect, transformScale);
    
    [image drawInRect:rect];
    
    
    // 2.1. Optional Image --------------------------------
    
    if (showOptionalImage) {
        
        image = optionalImage;
        
        rect = CGRectFromString([_data valueForKeyPath:@"Elements.OptionalImage.Rect"]);
        rect = CGRectApplyAffineTransform(rect, transformScale);
        
        [image drawInRect:rect];
    }
    
    
    // 3. Title -------------------------------------------

    if ([_data valueForKeyPath:@"Elements.Title"]) {

    [self drawText:title inContext:context withData:[_data valueForKeyPath:@"Elements.Title"] scaleRatio:ratio];
    }
    
    // 4. Text --------------------------------------------
    
    if ([_data valueForKeyPath:@"Elements.Text"]) {
    
        [self drawText:text inContext:context withData:[_data valueForKeyPath:@"Elements.Text"] scaleRatio:ratio];
    }
    
    // 5. Date & TIme
    
    if ([_data valueForKeyPath:@"Elements.DateAndTime"]) {
        
        if (date.length == 0 || time.length == 0) {
            
            string = [NSString stringWithFormat:@"%@%@", date, time];
        }
        else {
        
            string = [NSString stringWithFormat:@"%@ %@ %@", date, [_data valueForKeyPath:@"Elements.DateAndTime.SeparatorChar"], time];
        }
        
        [self drawText:string inContext:context withData:[_data valueForKeyPath:@"Elements.DateAndTime"] scaleRatio:ratio];
    }
    else if ([_data valueForKeyPath:@"Elements.Date"] && [_data valueForKeyPath:@"Elements.Time"]) {
        
        [self drawText:date inContext:context withData:[_data valueForKeyPath:@"Elements.Date"] scaleRatio:ratio];
        [self drawText:time inContext:context withData:[_data valueForKeyPath:@"Elements.Time"] scaleRatio:ratio];
    }
    
    
    // 6. Location
    
    if ([_data valueForKeyPath:@"Elements.Location"]) {

        if (street.length == 0 || city.length == 0) {
            
            string = [NSString stringWithFormat:@"%@%@", street, city];
        }
        else {
            
            string = [NSString stringWithFormat:@"%@ %@ %@", street, [_data valueForKeyPath:@"Elements.Location.SeparatorChar"], city];
        }
        
        [self drawText:string inContext:context withData:[_data valueForKeyPath:@"Elements.Location"] scaleRatio:ratio];
    }
    else if ([_data valueForKeyPath:@"Elements.Street"] && [_data valueForKeyPath:@"Elements.City"]) {
        
        [self drawText:street inContext:context withData:[_data valueForKeyPath:@"Elements.Street"] scaleRatio:ratio];
        [self drawText:city inContext:context withData:[_data valueForKeyPath:@"Elements.City"] scaleRatio:ratio];
    }
    
    
    
    
    // /draw
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


- (void) drawText:(NSString*) string inContext:(CGContextRef) context withData:(NSDictionary*) data scaleRatio:(float) ratio {

    UIFont* font = [UIFont fontWithName:[data valueForKeyPath:@"Font.Name"]
                           size:[[data valueForKeyPath:@"Font.Size"] floatValue] * ratio];
    UIColor* color = [UIColor colorFromString:[data valueForKeyPath:@"Font.Color"]];
    UITextAlignment alignment = [self alignmentFromString:[data valueForKeyPath:@"Paragraph.HAlignment"]];
    NSString* valignment = [data valueForKeyPath:@"Paragraph.VAlignment"];
    CGRect rect = CGRectFromString([data valueForKeyPath:@"Rect"]);
    rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(ratio, ratio));
    NSLineBreakMode lineBreakMode = [self lineBreakModeFromNumberOfLines:[[data valueForKeyPath:@"Paragraph.NumberOfLines"] intValue]];
    float lineSpacing = [[data valueForKeyPath:@"Paragraph.LineSpacing"] floatValue] * ratio;
    float lineHeight = [[data valueForKeyPath:@"Paragraph.LineHeight"] floatValue] * ratio;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = alignment;
    paragraph.lineBreakMode = lineBreakMode;

    
    // Line Spacing and Line Height
    
    if (lineSpacing != 0) {
        paragraph.lineSpacing = lineSpacing;
    }
    if (lineHeight != 0) {
        paragraph.minimumLineHeight = lineHeight;
        paragraph.maximumLineHeight = lineHeight;
    }

    
    // VAlignment
    
    CGSize textSize = [string sizeWithFont:font constrainedToSize:rect.size lineBreakMode:lineBreakMode];

    if ([valignment isEqualToString:@"middle"]) {
        rect = CGRectMake(rect.origin.x, rect.origin.y + round((rect.size.height - textSize.height) * 0.5), rect.size.width, textSize.height);
    }
    else if ([valignment isEqualToString:@"bottom"]) {
        rect = CGRectMake(rect.origin.x, rect.origin.y + round(rect.size.height - textSize.height), rect.size.width, textSize.height);
    }
    
    
    // Attributes
    
    NSDictionary* attributes = @{
                                 NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: color,
                                 NSParagraphStyleAttributeName: paragraph
                                 };
    
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributes];

    
//    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if ([data valueForKeyPath:@"Rotation"]) {
        
        float angle = [[data valueForKeyPath:@"Rotation"] floatValue];
        CGAffineTransform translation1 = CGAffineTransformMakeTranslation(-rect.origin.x, -rect.origin.y);
        CGAffineTransform rotation = CGAffineTransformMakeRotation(degreesToRadians(angle));
        CGAffineTransform translation2 = CGAffineTransformMakeTranslation(rect.origin.x, rect.origin.y);
        transform = CGAffineTransformConcat(translation1, rotation);
        transform = CGAffineTransformConcat(transform, translation2);
    }
    
    CGContextSaveGState(context);
    CGContextConcatCTM(context, transform);

//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextFillRect(context, rect);
    
    [attributedString drawInRect:rect];
    
    CGContextRestoreGState(context);
}





- (UITextAlignment) alignmentFromString:(NSString*) string {
    
    if ([string isEqualToString:@"left"]) {
        return UITextAlignmentLeft;
    }
    else if ([string isEqualToString:@"center"]) {
        return UITextAlignmentCenter;
    }
    else if ([string isEqualToString:@"right"]) {
        return UITextAlignmentRight;
    }
    else {
        return UITextAlignmentLeft;
    }
}


- (NSLineBreakMode) lineBreakModeFromNumberOfLines:(uint) number {
    
    if (number != 0) return NSLineBreakByWordWrapping;
    else return NSLineBreakByTruncatingTail;
}




UIImage* resizedImage(UIImage *inImage, CGRect thumbRect)
{
	CGImageRef			imageRef = [inImage CGImage];
	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	// There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
	// see Supported Pixel Formats in the Quartz 2D Programming Guide
	// Creating a Bitmap Graphics Context section
	// only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
	// and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
	// The images on input here are likely to be png or jpeg files
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
    
	// Build a bitmap context that's the size of the thumbRect
	CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                thumbRect.size.width,		// width
                                                thumbRect.size.height,		// height
                                                CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
                                                4 * thumbRect.size.width,	// rowbytes
                                                CGImageGetColorSpace(imageRef),
                                                alphaInfo
                                                );
    
	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, thumbRect, imageRef);
    
	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];
    
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
    
	return result;
}


@end
