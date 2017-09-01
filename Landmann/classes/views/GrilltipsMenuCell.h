//
//  GrilltipsMenuCell.h
//  Landmann
//
//  Created by Wang on 17.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrilltipsMenuCell : UITableViewCell  {
    
    UIImage* _background;
    UIImage* _backgorundSelected;
}

@property (nonatomic, strong) IBOutlet UIImageView* background;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;


+ (id) cell;

@end
