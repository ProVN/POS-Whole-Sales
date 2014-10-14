//
//  ContactAddtionalInfoViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ContactAddtionalInfoViewController.h"

@interface ContactAddtionalInfoViewController ()

@end

@implementation ContactAddtionalInfoViewController
@synthesize txtAccount,txtAccountLimit,txtBSB,txtCreditCardNo,txtExpire,txtNameOnCard,txtNotes;
@synthesize posCustomer, posSupplier;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     @synchronized (self){
         if (posCustomer) {
             txtAccountLimit.text = [NSString stringWithFormat:@"%d",[posCustomer.AccountLimit intValue]];
             txtBSB.text = posCustomer.BankBSB;
             txtAccount.text = posCustomer.BankAccount;
             txtNotes.text = posCustomer.BankNotes;
             txtCreditCardNo.text = posCustomer.CCNumber;
             txtNameOnCard.text = posCustomer.CCName;
             txtExpire.text = [POSCommon formatDateToString:posCustomer.CCExpire];
             self.expired = posCustomer.CCExpire;
         }else if (posSupplier){
             txtAccountLimit.text = [NSString stringWithFormat:@"%d",[posSupplier.AccountLimit intValue]];
             txtBSB.text = posSupplier.BankBSB;
             txtAccount.text = posSupplier.BankAccount;
             txtNotes.text = posSupplier.BankNotes;
             txtCreditCardNo.text = posSupplier.CCNumber;
             txtNameOnCard.text = posSupplier.CCName;
             txtExpire.text = [POSCommon formatDateToString:posSupplier.CCExpire];
             self.expired = posSupplier.CCExpire;
         }
     }
    self.txtExpire.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 -(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtExpire)
    {
        [POSCommon showDateTimePicker:self selectedDate:self.expired target:self];
        return NO;
    }
    return YES;
}
- (void)dateTimePickerSaved:(NSDate *)date tag:(int)tag
{
    self.expired = date;
    txtExpire.text = [POSCommon formatDateToString:date];
}

@end
