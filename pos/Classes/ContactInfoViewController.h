//
//  ContactInfoViewController.h
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "POSSupplier.h"
#import "POSCustomer.h"

@interface ContactInfoViewController : UIViewController {
    ContactType contactType;
}
@property (strong, nonatomic) IBOutlet UITextField *txtCompanyName;
@property (strong, nonatomic) IBOutlet UITextField *txtMemberCode;
@property (strong, nonatomic) IBOutlet UITextField *txtContactName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segStaturation;
@property (strong, nonatomic) IBOutlet UITextView *tvAddess;
@property (strong, nonatomic) IBOutlet UITextField *txtABN;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtFax;
@property (strong, nonatomic) IBOutlet UITextField *txtAltPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtCC;


@property (strong, nonatomic) IBOutlet UILabel *lblContactType;
@property (nonatomic, strong) POSCustomer  *posCustomer;
@property (nonatomic, strong) POSSupplier *posSupplier;

-(void) setContactType:(ContactType) type;
@end
