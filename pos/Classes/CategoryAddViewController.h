//
//  CategoryAddViewController.h
//  pos
//
//  Created by Loc Tran on 7/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "UIViewController+POSViewController.h"
#import "POSCategory.h"

@protocol CategoryAddViewControllerDelegate
@required
- (void)categoryAddViewControllerCompleted;
@end

@interface CategoryAddViewController : UIViewController<DBDelegate>
{
    id<CategoryAddViewControllerDelegate> _target;
}
@property (strong, nonatomic) IBOutlet UITextField *txtCategoryName;
@property (strong, nonatomic) POSCategory* category;
@property (strong, nonatomic) IBOutlet UILabel *errorMsg;
-(void) setTarget:(id)target;

@end
