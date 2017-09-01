//
//  RecipeMenuViewController.h
//  Landmann
//
//  Created by Wang on 15.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentDataManager.h"
#import "RecipeMenuCell.h"


@interface RecipeMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSString* _category;
    NSArray* _keywords;
    RecipeDifficulty _difficulty;
    NSArray* _sectionData;
    
    NSIndexPath* _selectedIndexPath;
    
    SEL _loadDataSelector;
    id _loadDataObject;
    
    BOOL _didDisappear;
    
    UIImageView* _overlayView;
    
    BOOL _showButtons;
}


- (id) initWithCategory:(NSString*) category;


- (id) initWithKeywords:(NSArray*) keywords;

- (id) initWithRecommendations;


@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) IBOutlet UIView* buttonsView;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray* buttons;

@property (nonatomic, strong) Recipe* preselectedRecipe;


- (IBAction) actionHat:(id) sender;


@end
