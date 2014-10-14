//
//  LessTransportViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "LessTransportViewController.h"
#import "POSCommon.h"

@interface LessTransportViewController ()

@end

@implementation LessTransportViewController{
    NSInteger quantity;
    float price;
    float amount;
    NSString *priceStr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Less Transport";
        lessTransport = [[POSLessTransport alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 650, 350);
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doSave)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    self.navigationItem.leftBarButtonItem = btnCancel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
    self.lblMessage.hidden = YES;
    self.txPrice.delegate = self;
    quantity = [lessTransport.Quantity intValue];
    price = [lessTransport.TransportPrice floatValue];
    amount = quantity * price;
    [self loadData];
}

-(void) loadData
{
    self.stepper.minimumValue = 1;
    self.stepper.value = quantity;
    self.txtQuantity.text = [NSString stringWithFormat:@"%d",(int)self.stepper.value];
    if(price > 0)
    {
        NSNumber* nsPrice = [NSNumber numberWithFloat:price];
        self.txPrice.text = [POSCommon formatNumberToString:nsPrice];
    }
    if(amount > 0)
    {
        NSNumber* nsAmount = [NSNumber numberWithFloat:amount];
        self.txtSubTotal.text = [POSCommon formatCurrencyFromNumber:nsAmount];
    }
    priceStr = self.txPrice.text;
}


-(void) doSave
{
    if(price == 0)
    {
        self.lblMessage.text = @"Please provide the price for this less transport";
        self.lblMessage.hidden = NO;
        [self.txPrice becomeFirstResponder];
    }
    else
    {
        lessTransport.Quantity = [NSNumber numberWithInteger:quantity];
        lessTransport.TransportPrice = [NSNumber numberWithFloat:price];
        lessTransport.TotalTransport = [NSNumber numberWithFloat:amount];
        [_delegate lessTransportViewControllerSaved:lessTransport];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setLessTransport:(POSLessTransport *)obj target:(id)target
{
    _delegate = target;
    if(obj)
        lessTransport = obj;
}

-(void) doCancel
{
    [_delegate lessTransportViewControllerCanceled];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepperValueChanged:(id)sender {
    UIStepper *stepper = (UIStepper*) sender;
    self.txtQuantity.text = [NSString stringWithFormat:@"%d",(int)stepper.value];
    [self calculateAmount];
}
- (void) calculateAmount
{
    quantity = self.stepper.value;
    price = [priceStr floatValue];
    amount = price * quantity;
    NSNumber* nsAmount = [NSNumber numberWithFloat:amount];
    self.txtSubTotal.text = [POSCommon formatCurrencyFromNumber:nsAmount];
    price = 0 - price;
    amount = 0 - amount;
}

#pragma mark
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([POSCommon isCurrencyCharacter:string])
    {
        priceStr = [priceStr stringByReplacingCharactersInRange:range withString:string];
        self.txPrice.text = priceStr;
        [self calculateAmount];
    }
    return NO;
}
@end
