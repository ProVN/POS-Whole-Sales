//
//  AdvanceSearchViewController.h
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
@interface AdvanceSearchViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwitch *isSales;
@property (strong, nonatomic) IBOutlet UISwitch *isPurchase;
@property (strong, nonatomic) IBOutlet UISwitch *isPayment;
@property (strong, nonatomic) IBOutlet UITextField *contactName;
@property (strong, nonatomic) IBOutlet UISwitch *isAmount;
@property (strong, nonatomic) IBOutlet UISegmentedControl *amountType;
@property (strong, nonatomic) IBOutlet UITextField *amountValue;
@property (strong, nonatomic) IBOutlet UIDatePicker *fromDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *toDate;
@end
