//
//  LoginViewController.h
//  pos
//
//  Created by Loc Tran on 2/25/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "UIViewController+POSViewController.h"

typedef enum {
    kInitStepLogin,
    kInitStepLoadCustomers,
    kInitStepLoadSuppliers,
    kInitStepLoadUsers,
    kInitStepLoadProducts,
    kInitStepLoadCompleted
} InitStep;

@interface LoginViewController : UIViewController<DBDelegate, UIAlertViewDelegate> {
    InitStep initStep;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *dbIndex;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UISwitch *txtRemember;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UILabel *lblLoading;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic) IBOutlet UILabel *lblError;
- (IBAction)doLogin:(id)sender;
- (IBAction)doCancel:(id)sender;
- (IBAction)cancelLogin:(id)sender;

@end
