//
//  ContactAddtionalInfoViewController.h
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSCustomer.h"
#import "POSSupplier.h"
#import "POSCommon.h"
#import "DateTimePickerViewController.h"

@interface ContactAddtionalInfoViewController : UIViewController<UITextFieldDelegate, DateTimePickerDelegate> {

}
@property (nonatomic, strong) IBOutlet UITextField *txtAccountLimit;
@property (nonatomic, strong) IBOutlet UITextField *txtBSB;
@property (nonatomic, strong) IBOutlet UITextField *txtAccount;
@property (nonatomic, strong) IBOutlet UITextField *txtNotes;
@property (nonatomic, strong) IBOutlet UITextField *txtCreditCardNo;
@property (nonatomic, strong) IBOutlet UITextField *txtNameOnCard;
@property (nonatomic, strong) IBOutlet UITextField *txtExpire;

@property (nonatomic, strong) POSCustomer  *posCustomer;
@property (nonatomic, strong) POSSupplier *posSupplier;

@property (nonatomic, strong) NSDate* expired;

@end
