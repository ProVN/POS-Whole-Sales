//
//  PaymentFormViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "PaymentFormViewController.h"
#import "POSPurchasePayment.h"
#import "POSSaleInvoicePayment.h"
#import "POSCommon.h"
#import "POSMeta.h"

@interface PaymentFormViewController () {
    POSPurchasePayment *purchasePayment;
    POSSaleInvoicePayment *saleInvoicePayment;
}

@end

@implementation PaymentFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New payment";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLayout];
    
    //Add navigation button
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doSave)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    for(NSInteger index = self.txtPaymentType.numberOfSegments -1; index >=0; index--)
    {
        [self.txtPaymentType removeSegmentAtIndex:index animated:NO];
    }
    NSMutableArray *paymentTypes = [[POSMeta sharedInstance] paymentTypes];
    for (NSInteger index = 0; index < paymentTypes.count; index++)
    {
        [self.txtPaymentType insertSegmentWithTitle:[paymentTypes objectAtIndex:index] atIndex:index animated:NO];
    }
    
    //Init variable
    if(transactionType == TransactionTypeSale && saleInvoicePayment == nil)
    {
        saleInvoicePayment = [[POSSaleInvoicePayment alloc] init];
        saleInvoicePayment.PaymentTime = [NSDate date];
        saleInvoicePayment.PaymentAmount = self.balance;
        
    }
    else if(transactionType == TransactionTypePurchase && purchasePayment == nil)
    {
        purchasePayment = [[POSPurchasePayment alloc] init];
        purchasePayment.PaymentTime = [NSDate date];
        purchasePayment.PaymentAmount = self.balance;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Add Delegate
    self.txtAmount.delegate = self;

    //Add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [self loadData];
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
}

#pragma mark -
#pragma mark User Defined Function
-(void) keyboardWillShow
{
    if([POSCommon isLandscapeMode])
    {
        CGSize size = self.scrollView.frame.size;
        CGPoint scrollPoint = CGPointMake(0, 150);
        size.height += 150;
        self.scrollView.contentSize = size;
        [self.scrollView setContentOffset:scrollPoint];
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

- (void)loadData
{
    switch (transactionType) {
        case TransactionTypeSale:
        {
            self.txtDate.date = saleInvoicePayment.PaymentTime;
            self.txtPaymentType.selectedSegmentIndex = [saleInvoicePayment.PaymentType intValue];
            self.txtDescription.text = saleInvoicePayment.Description;
            self.txtAmount.text = [saleInvoicePayment.PaymentAmount stringValue];
            break;
        }
        case TransactionTypePurchase:
        {
            self.txtDate.date = purchasePayment.PaymentTime;
            self.txtPaymentType.selectedSegmentIndex = [purchasePayment.PaymentType intValue];
            self.txtDescription.text = purchasePayment.Description;
            self.txtAmount.text = [purchasePayment.PaymentAmount stringValue];
            break;
        }
        default:
            break;
    }
}

-(void) doSave
{
    NSNumber *paymentAmount = [NSNumber numberWithFloat:[self.txtAmount.text floatValue]];
    if([paymentAmount floatValue] > [self.balance floatValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confimation" message:@"This payment is large than the balance. Are you sure to make this payment?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    else
    {
        [self save];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != [alertView cancelButtonIndex])
    {
        [self save];
    }
}

-(void) save
{
    switch (transactionType)
    {
        case TransactionTypeSale:
        {
            saleInvoicePayment.PaymentTime = self.txtDate.date;
            saleInvoicePayment.PaymentType = [NSNumber numberWithInteger:self.txtPaymentType.selectedSegmentIndex];
            saleInvoicePayment.Description = self.txtDescription.text;
            saleInvoicePayment.PaymentAmount = [NSNumber numberWithFloat:[self.txtAmount.text floatValue]];
            [_delegate paymentInputSaved:saleInvoicePayment];
            break;
        }
        case TransactionTypePurchase:
        {
            purchasePayment.PaymentTime = self.txtDate.date;
            purchasePayment.PaymentType = [NSNumber numberWithInteger:self.txtPaymentType.selectedSegmentIndex];
            purchasePayment.Description = self.txtDescription.text;
            purchasePayment.PaymentAmount = [NSNumber numberWithFloat:[self.txtAmount.text floatValue]];
            [_delegate paymentInputSaved:purchasePayment];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) doCancel
{
    [_delegate paymentInputCanceled];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPaymentItem:(id)item transactionType:(TransactionType)type target:(id)target
{
    transactionType = type;
    _delegate = target;
    switch (transactionType)
    {
        case TransactionTypeSale:
        {
            saleInvoicePayment = item;
            break;
        }
        case TransactionTypePurchase:
        {
            purchasePayment = item;
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([POSCommon isCurrencyCharacter:string])
        return YES;
    return NO;
}
@end
