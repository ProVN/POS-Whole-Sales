//
//  UserDetailViewController.h
//  pos
//
//  Created by Loc Tran on 2/11/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSUser.h"

#define PopToUsersViewController @"poptousersviewcontroller"

@interface UserDetailViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) POSUser *user;

@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) IBOutlet UISegmentedControl *txtRole;
@property (strong, nonatomic) IBOutlet UITextField *txtFullname;
@property (strong, nonatomic) IBOutlet UITextField *txtInital;
@property (strong, nonatomic) IBOutlet UISegmentedControl *txtStatus;
+(UserDetailViewController *)userDetailInstance;
@end
