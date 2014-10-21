//
//  QuantitySelectViewController.m
//  pos
//
//  Created by Loc Tran on 2/27/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "SaleInvoiceDetailsInput.h"
#import "POSPurchaseDetail.h"
#import "POSCommon.h"

@interface SaleInvoiceDetailsInput () {
    NSInteger quantity;
    float price;
    float amount;
    NSString *priceStr;
}

@end

@implementation SaleInvoiceDetailsInput

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtNumber.delegate = self;
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 650, 350);
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doSave)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    self.navigationItem.leftBarButtonItem = btnCancel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
    self.lblMsg.hidden = YES;
    self.txtPrice.delegate = self;
    if(self.transactionType == TransactionTypeSale)
    {
        if(invoice == nil)
            invoice = [[POSSaleInvoiceDetail alloc] init];
        POSSaleInvoiceDetail* obj = (POSSaleInvoiceDetail*)invoice;
        quantity = [obj.Quantity intValue];
        price = [obj.SalePrice floatValue];   
    }
    else
    {
        if(invoice == nil)
            invoice = [[POSPurchaseDetail alloc] init];
        POSPurchaseDetail* obj = (POSPurchaseDetail*)invoice;
        quantity = [obj.Quantity intValue];
        price = [obj.PurchasePrice floatValue];
    }
    amount = quantity * price;
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) loadData
{
    self.stepper.minimumValue = 1;
    self.stepper.value = quantity;
    self.txtNumber.text = [NSString stringWithFormat:@"%d",(int)self.stepper.value];
    if(price > 0)
    {
        NSNumber* nsPrice = [NSNumber numberWithFloat:price];
        self.txtPrice.text = [POSCommon formatNumberToString:nsPrice];
    }
    if(amount > 0)
    {
        NSNumber* nsAmount = [NSNumber numberWithFloat:amount];
        self.txtTotalAmount.text = [POSCommon formatCurrencyFromNumber:nsAmount];
    }
    priceStr = self.txtPrice.text;
}

-(void) doSave
{
    if(price == 0)
    {
        self.lblMsg.text = @"Please provide the price for this invoice";
        self.lblMsg.hidden = NO;
        [self.txtPrice becomeFirstResponder];
    }
    else
    {
        if(self.transactionType == TransactionTypeSale) {
            POSSaleInvoiceDetail* obj = (POSSaleInvoiceDetail*)invoice;
            if(obj.ProductID == nil)
                obj.ProductID = _product.Id;
            obj.Quantity = [NSNumber numberWithInteger:quantity];
            obj.SalePrice = [NSNumber numberWithFloat:price];
            obj.TotalAmount = [NSNumber numberWithFloat:amount];
            obj.SaleLevy = [NSNumber numberWithInteger:quantity];
            invoice = obj;
            [_delegate saleInvoiceDetailsInputSaved:invoice];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            POSPurchaseDetail* obj = (POSPurchaseDetail*)invoice;
            if(obj.ProductID == nil)
                obj.ProductID = _product.Id;
            obj.Quantity = [NSNumber numberWithInteger:quantity];
            obj.PurchasePrice = [NSNumber numberWithFloat:price];
            obj.TotalAmount = [NSNumber numberWithFloat:amount];
            obj.PurchaseLevy = [NSNumber numberWithInteger:quantity];
            invoice = obj;
            [_delegate saleInvoiceDetailsInputSaved:invoice];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (IBAction)stepperValueChanged:(id)sender {
    UIStepper *stepper = (UIStepper*) sender;
    self.txtNumber.text = [NSString stringWithFormat:@"%d",(int)stepper.value];
    [self calculateAmount];
}

-(void)doCancel
{
    [_delegate saleInvoiceDetailsInputCanceled];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setProduct:(POSProduct *)product target:(id)target
{
    _delegate = target;
    self.stepper.minimumValue = 1;
    _product = product;
    self.txtNumber.text = [NSString stringWithFormat:@"%d",(int)self.stepper.value];
    if(self.transactionType == TransactionTypeSale) {
        POSSaleInvoiceDetail* obj = (POSSaleInvoiceDetail*)invoice;
        if(obj == nil) obj = [[POSSaleInvoiceDetail alloc] init];
        obj.ProductID = _product.Id;
        invoice = obj;
    }
    else {
        POSPurchaseDetail* obj = (POSPurchaseDetail*)invoice;
        if(obj == nil) obj = [[POSPurchaseDetail alloc] init];
        obj.ProductID = _product.Id;
        invoice = obj;
    }
}

- (void)setSaleInvoiceDetails:(POSObject *)invoices target:(id)target
{
    _delegate = target;
    invoice = invoices;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) calculateAmount
{
    quantity = self.stepper.value;
    price = [priceStr floatValue];
    amount = price * quantity;
    NSNumber* nsAmount = [NSNumber numberWithFloat:amount];
    self.txtTotalAmount.text = [POSCommon formatCurrencyFromNumber:nsAmount];
}

#pragma mark
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.txtPrice) {
    if([POSCommon isCurrencyCharacter:string])
    {
        priceStr = [priceStr stringByReplacingCharactersInRange:range withString:string];
        self.txtPrice.text = priceStr;
        [self calculateAmount];
    }
    return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.txtNumber)
    {
        double value = [textField.text doubleValue];
        if(value > self.stepper.maximumValue) {
            value = self.stepper.maximumValue;
            textField.text = [NSString stringWithFormat:@"%f",value];
        }
        self.stepper.value = value;
        [self calculateAmount];
    }
}
@end
