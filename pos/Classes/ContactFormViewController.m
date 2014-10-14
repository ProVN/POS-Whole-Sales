//
//  CustomerFormViewController.m
//  pos
//
//  Created by ; Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ContactFormViewController.h"
#import "AppDelegate.h"
#import "DBManager.h"

@interface ContactFormViewController ()

@end

@implementation ContactFormViewController
@synthesize posSupplier, posCustomer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        contactInfoView = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
        contactAdditionalView = [[ContactAddtionalInfoViewController alloc] initWithNibName:@"ContactAddtionalInfoViewController" bundle:nil];
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadViewBySegment];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(insertUpdateContacts)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
    
    //Add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}


- (void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark User Defined

-(void) keyboardWillShow
{
    if([POSCommon isLandscapeMode])
    {
        CGSize size = self.scrollView.frame.size;
        size.height += 200;
        self.scrollView.contentSize = size;
    }
}
-(void) keyboardWillHide
{
    if([POSCommon isLandscapeMode])
    {
        CGSize size = self.scrollView.frame.size;
        self.scrollView.contentSize = size;
    }
}

-(void)setContactType:(ContactType)type {
    contactType = type;
    switch (contactType) {
        case ContactTypeCustomer:
            self.title = @"Customer's Information";
            break;
        case ContactTypeSuppplier:
            self.title = @"Supplier's Information";
            break;
        default:
            break;
    }
}

-(void) loadViewBySegment {
    contactInfoView.posCustomer = posCustomer;
    contactInfoView.posSupplier = posSupplier;
    contactAdditionalView.posCustomer = posCustomer;
    contactAdditionalView.posSupplier = posSupplier;
    [contactInfoView.view removeFromSuperview];
    [contactAdditionalView.view removeFromSuperview];
    if(self.segmentControl.selectedSegmentIndex == 0) {
        [self.scrollView addSubview:contactInfoView.view];
    }
    else if(self.segmentControl.selectedSegmentIndex == 1) {
        [self.scrollView addSubview:contactAdditionalView.view];
    }
}

- (IBAction)segmentValueChange:(id)sender {
    [self loadViewBySegment];
}

-(void)insertUpdateContacts{
    if (contactType == ContactTypeCustomer) {
        POSCustomer *customer = [[POSCustomer alloc] init];
        if (posCustomer.Id) {
            customer.Id = posCustomer.Id;
        }
        if (contactInfoView.txtCompanyName.text == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please fill in company name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else
            customer.CompanyName = contactInfoView.txtCompanyName.text;
        if (contactInfoView.txtABN.text == nil)
            customer.ABN = @" ";
        else
            customer.ABN = contactInfoView.txtABN.text;
        customer.Status = YES;
        if (contactInfoView.txtContactName.text == nil)
            customer.ContactName = @" ";
        else
            customer.ContactName = contactInfoView.txtContactName.text;
        if (contactInfoView.segStaturation.selectedSegmentIndex == 0)
            customer.Title = @"Mr";
        else if (contactInfoView.segStaturation.selectedSegmentIndex == 1)
            customer.Title = @"Mrs";
        else
            customer.Title = @"Mss";
        if (contactInfoView.tvAddess.text == nil)
            customer.Address = @" ";
        else
            customer.Address = contactInfoView.tvAddess.text;
        if (contactInfoView.txtPhone.text == nil)
            customer.Phone = @" ";
        else
            customer.Phone = contactInfoView.txtPhone.text;
        
        if (contactInfoView.txtFax.text == nil)
            customer.Fax = @" ";
        else
            customer.Fax = contactInfoView.txtFax.text;
        
        customer.AltPhone = contactInfoView.txtAltPhone.text;
        
        if (contactInfoView.txtEmail.text == nil)
            customer.Email = @" ";
        else
            customer.Email = contactInfoView.txtEmail.text;
        if (contactInfoView.txtCC.text == nil)
            customer.CcEmail = @" ";
        else
            customer.CcEmail = contactInfoView.txtCC.text;
        customer.CurrentOwning = @" ";
        customer.AddedTime = [NSDate date];
        customer.UpdatedTime = [NSDate date];
        customer.AccountLimit = [NSNumber numberWithInt:[contactAdditionalView.txtAccountLimit.text intValue]];
        customer.BankBSB = contactAdditionalView.txtBSB.text == nil ? @" " : contactAdditionalView.txtBSB.text;
        customer.BankAccount = contactAdditionalView.txtAccount.text == nil ? @" " : contactAdditionalView.txtAccount.text;
        customer.BankNotes = contactAdditionalView.txtNotes.text == nil ? @" " : contactAdditionalView.txtNotes.text;
        customer.CCNumber = contactAdditionalView.txtCreditCardNo.text == nil ? @" ": contactAdditionalView.txtCreditCardNo.text;
        customer.CCName = contactAdditionalView.txtNameOnCard.text == nil ? @" " : contactAdditionalView.txtNameOnCard.text;
        customer.MemberCode = contactInfoView.txtMemberCode.text;
        customer.CCExpire = contactAdditionalView.expired;
        
        NSDateFormatter *datef = [[NSDateFormatter alloc] init];
        [datef setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = contactAdditionalView.txtExpire.text;
        customer.CCExpire = contactAdditionalView.txtExpire.text == nil ? nil: [datef dateFromString:date];
        
        [[DBManager sharedInstant] saveData:kDbCustomers item:customer target:self];

    }
    else if (contactType == ContactTypeSuppplier){
        POSSupplier *supplier = [[POSSupplier alloc] init];
        if (posSupplier.Id) {
            supplier.Id = posSupplier.Id;
        }
        if (contactInfoView.txtCompanyName.text == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please fill in company name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else
            supplier.CompanyName = contactInfoView.txtCompanyName.text;
        if (contactInfoView.txtABN.text == nil)
            supplier.ABN = @" ";
        else
            supplier.ABN = contactInfoView.txtABN.text;
        supplier.Status = YES;
        if (contactInfoView.txtContactName.text == nil)
            supplier.ContactName = @" ";
        else
            supplier.ContactName = contactInfoView.txtContactName.text;
        if (contactInfoView.segStaturation.selectedSegmentIndex == 0)
            supplier.Title = @"Mr";
        else if (contactInfoView.segStaturation.selectedSegmentIndex == 1)
            supplier.Title = @"Mrs";
        else
            supplier.Title = @"Mss";
        if (contactInfoView.tvAddess.text == nil)
            supplier.Address = @" ";
        else
            supplier.Address = contactInfoView.tvAddess.text;
        if (contactInfoView.txtPhone.text == nil)
            supplier.Phone = @" ";
        else
            supplier.Phone = contactInfoView.txtPhone.text;
        if (contactInfoView.txtFax.text == nil)
            supplier.Fax = @" ";
        else
            supplier.Fax = contactInfoView.txtFax.text;
        if (contactInfoView.txtEmail.text == nil)
            supplier.Email = @" ";
        else
            supplier.Email = contactInfoView.txtEmail.text;
        if (contactInfoView.txtCC.text == nil)
            supplier.CcEmail = @" ";
        else
            supplier.CcEmail = contactInfoView.txtCC.text;
        supplier.AltPhone = contactInfoView.txtAltPhone.text;
        
        supplier.CurrentOwning = @" ";
        supplier.AddedTime = [NSDate date];
        supplier.UpdatedTime = [NSDate date];
        supplier.AccountLimit = [NSNumber numberWithInt:[contactAdditionalView.txtAccountLimit.text intValue]];
        supplier.BankBSB = contactAdditionalView.txtBSB.text == nil ? @" " : contactAdditionalView.txtBSB.text;
        supplier.BankAccount = contactAdditionalView.txtAccount.text == nil ? @" " : contactAdditionalView.txtAccount.text;
        supplier.BankNotes = contactAdditionalView.txtNotes.text == nil ? @" " : contactAdditionalView.txtNotes.text;
        supplier.CCNumber = contactAdditionalView.txtCreditCardNo.text == nil ? @" ": contactAdditionalView.txtCreditCardNo.text;
        supplier.CCName = contactAdditionalView.txtNameOnCard.text == nil ? @" " : contactAdditionalView.txtNameOnCard.text;
        NSDateFormatter *datef = [[NSDateFormatter alloc] init];
        [datef setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = contactAdditionalView.txtExpire.text;
        supplier.CCExpire = contactAdditionalView.txtExpire.text == nil ? nil: [datef dateFromString:date];
        supplier.CCExpire = contactAdditionalView.expired;
        
        [[DBManager sharedInstant] saveData:kDbSuppliers item:supplier target:self];
    }
    
}
- (void)setTarget:(id)target
{
    _target = target;
}

- (void)saveDataCompleted:(POSObject*)insertedItem{
    [_target contactFormViewControllerCompleted];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)requestFailed: (NSError*) message{
   
}
@end
