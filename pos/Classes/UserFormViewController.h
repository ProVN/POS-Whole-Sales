//
//  UserFormViewController.h
//  pos
//
//  Created by Loc Tran on 2/11/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetailViewController.h"
#import "POSUser.h"
#import "DBManager.h"
#import "UIViewController+POSViewController.h"

@protocol UserFormViewControllerDelegate
@required
- (void)userFormViewControllerCompleted;
@end


@interface UserFormViewController : UIViewController {
    UserDetailViewController *userDetailView;
    id<UserFormViewControllerDelegate> _target;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) POSUser* user;

- (IBAction)segmentValueChanged:(id)sender;
- (void) setTarget:(id) target;
@end
