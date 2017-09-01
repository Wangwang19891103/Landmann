//
//  InvitationCardRenderer.h
//  Landmann
//
//  Created by Wang on 28.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    
    InvitationCardRendererRenderModePreview,
    InvitationCardRendererRenderModeFull
    
} InvitationCardRendererRenderMode;


@interface InvitationCardRenderer : NSObject {
    
    NSDictionary* _data;
    
    UIImage* _backgroundImage;
    UIImage* _customImageDefault;
    UIImage* _customImage;
    UIImage* _optionalImage;

    UIImage* _backgroundImagePreview;
    UIImage* _customImagePreview;
    UIImage* _optionalImagePreview;

}

@property (nonatomic, copy) NSString* date;

@property (nonatomic, copy) NSString* time;

@property (nonatomic, copy) NSString* street;

@property (nonatomic, copy) NSString* city;

@property (nonatomic, copy) NSString* title;

@property (nonatomic, copy) NSString* text;

@property (nonatomic, strong) UIImage* customImage;

@property (nonatomic, assign) BOOL showOptionalImage;


- (id) initWithData:(NSDictionary*) data;

- (UIImage*) renderForSize:(CGSize) size mode:(InvitationCardRendererRenderMode) mode;

@end
