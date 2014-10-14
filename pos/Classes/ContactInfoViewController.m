//
//  ContactInfoViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ContactInfoViewController.h"

@interface ContactInfoViewController ()

@end

@implementation ContactInfoViewController
@synthesize posSupplier, posCustomer;
@synthesize txtCC,txtEmail,txtAltPhone,txtFax,txtPhone,txtABN,txtContactName,txtCompanyName,txtMemberCode,tvAddess,segStaturation;

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
             txtCompanyName.text = posCustomer.CompanyName;
             txtMemberCode.text = posCustomer.MemberCode;
             if([posCustomer.Title isEqualToString:@"Mr"])
                 segStaturation.selectedSegmentIndex = 0;
             else if([posCustomer.Title isEqualToString:@"Mrs"])
                 segStaturation.selectedSegmentIndex = 1;
             else
                 segStaturation.selectedSegmentIndex = 2;
             txtContactName.text = posCustomer.CompanyName;
             tvAddess.text = posCustomer.Address;
             txtABN.text = posCustomer.ABN;
             txtPhone.text = posCustomer.Phone;
             txtFax.text = posCustomer.Fax;
             txtAltPhone.text = posCustomer.AltPhone;
             txtEmail.text = posCustomer.Email;
             txtCC.text = posCustomer.CcEmail;
         }else if (posSupplier){
             txtCompanyName.text = posSupplier.CompanyName;
             txtMemberCode.text = posSupplier.MemberCode;
             if([posSupplier.Title isEqualToString:@"Mr"])
                 segStaturation.selectedSegmentIndex = 0;
             else if([posSupplier.Title isEqualToString:@"Mrs"])
                 segStaturation.selectedSegmentIndex = 1;
             else
                 segStaturation.selectedSegmentIndex = 2;
             txtContactName.text = posSupplier.ContactName;
             // Assigned like that cause: Confuse between Customer and ContactName
             tvAddess.text = posSupplier.Address;
             txtABN.text = posSupplier.ABN;
             txtPhone.text = posSupplier.Phone;
             txtFax.text = posSupplier.Fax;
             txtAltPhone.text = posSupplier.AltPhone;
             txtEmail.text = posSupplier.Email;
             txtCC.text = posSupplier.CcEmail;
         }
     }
    self.tvAddess.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tvAddess.layer.borderWidth = 0.5;
    self.tvAddess.layer.cornerRadius = 10;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setContactType:(ContactType)type {
    contactType = type;
    switch (type) {
        case ContactTypeCustomer:
            self.lblContactType.text = @"Customer";
            break;
        case ContactTypeSuppplier:
            self.lblContactType.text = @"Supplier";
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
