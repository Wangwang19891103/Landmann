//
//  RecipeMenuCell.h
//  Landmann
//
//  Created by Wang on 18.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeMenuCell : UITableViewCell {
    
    UIImage* _background;
    UIImage* _backgorundSelected;
    uint _difficulty;
}

@property (nonatomic, strong) IBOutlet UIImageView* background;

@property (nonatomic, strong) IBOutlet UIImageView* image;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@property (nonatomic, strong) IBOutlet UIImageView* difficultyImage;



+ (id) cell;

- (void) setDifficulty:(uint) difficulty;

- (void) setRed:(BOOL) red;

@end
