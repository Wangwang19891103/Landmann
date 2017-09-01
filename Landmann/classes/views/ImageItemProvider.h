//
//  ImageItemProvider.h
//  Landmann
//
//  Created by Stefan Ueter on 26.04.13.
//  Copyright (c) 2013 Stefan Ueter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitationCardRenderer.h"


@interface ImageItemProvider : UIActivityItemProvider {
    
    InvitationCardRenderer* _renderer;
    CGSize* _sizes;
    
}


- (id) initWithRenderer:(InvitationCardRenderer*) renderer imageSizes:(CGSize[5]) sizes;


@end
