//
//  PaymentMenuViewController.m
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "PaymentMenuViewController.h"

@interface PaymentMenuViewController ()

@end

@implementation PaymentMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Payments";
        customerView = [[TransactionPaymentsViewController alloc] initWithNibName:@"TransactionPaymentsViewController" bundle:nil];
        [customerView setTransactionType:TransactionTypeSale];
        supplierView = [[TransactionPaymentsViewController alloc] initWithNibName:@"TransactionPaymentsViewController" bundle:nil];
        [supplierView setTransactionType:TransactionTypePurchase];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBAction
- (IBAction)btnCustomerTouchDown:(id)sender {
    [self.navigationController pushViewController:customerView animated:YES];
}

- (IBAction)btnSupplierTouchDown:(id)sender {
    [self.navigationController pushViewController:supplierView animated:YES];
}

@end
