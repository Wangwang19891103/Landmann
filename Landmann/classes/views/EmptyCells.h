//
//  EmptyCells.h
//  Landmann
//
//  Created by Wang on 23.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmptyRecipeCell : UITableViewCell {
    
    UIImage* _background;
    
}

@property (nonatomic, strong) IBOutlet UIImageView* background;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

+ (id) cell;


@end



@interface EmptyIngredientsCell : UITableViewCell {
    
}


+ (id) cell;


@end

