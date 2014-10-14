//
//  TransactionReportViewController.h
//  pos
//
//  Created by Loc Tran on 7/26/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "CustomerSelectViewViewController.h"

@interface TransactionReportViewController : UIViewController <UITextFieldDelegate, ContactSelectDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblCustomerSupplier;
@property (strong, nonatomic) IBOutlet UISwitch *isAmount;
@property (strong, nonatomic) IBOutlet UISegmentedControl *amountType;
@property (strong, nonatomic) IBOutlet UITextField *amountValue;
@property (strong, nonatomic) IBOutlet UISegmentedControl *filtertype;
@property (strong, nonatomic) IBOutlet UIDatePicker *fromDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *toDate;
@property (strong, nonatomic) IBOutlet UITextField *txtContact;
@property (assign, nonatomic) TransactionType transactionType;
- (IBAction)isAmountChange:(id)sender;
- (IBAction)removeContact:(id)sender;
@end
