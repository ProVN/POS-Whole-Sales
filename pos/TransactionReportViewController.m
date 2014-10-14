//
//  TransactionReportViewController.m
//  pos
//
//  Created by Loc Tran on 7/26/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "TransactionReportViewController.h"
#import "POSCustomer.h"
#import "POSSupplier.h"
#import "POSSaleInvoice.h"
#import "POSPurchase.h"
#import "ReportResultViewController.h"

@interface TransactionReportViewController ()

@end

@implementation TransactionReportViewController {
    POSObject* _contact;
}

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
    UIBarButtonItem *btnExport = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStyleBordered target:self action:@selector(doExport)];
    self.navigationItem.rightBarButtonItem = btnExport;
    self.txtContact.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
    if(self.transactionType == TransactionTypeSale){
        self.title = @"Sale Invoices Report";
        self.lblCustomerSupplier.text = @"Customer";
    }
    else {
         self.title = @"Purchases Report";
        self.lblCustomerSupplier.text = @"Suppliers";
    }
}

- (IBAction)isAmountChange:(id)sender {
    self.amountType.enabled = self.isAmount.on;
    self.amountValue.enabled = self.isAmount.on;
}

- (IBAction)removeContact:(id)sender {
    _contact = nil;
    self.txtContact.text = @"";
}

- (void) doExport
{
    NSMutableArray* data = nil;
    if(self.transactionType == TransactionTypeSale)
        data = [DBCaches sharedInstant].saleInvoices;
    else
        data = [DBCaches sharedInstant].purchases;
    
    NSPredicate* timePredicate = [NSPredicate predicateWithFormat:@"AddedTime>=%@ && AddedTime<=%@",self.fromDate.date,self.toDate.date];
    data = [[data filteredArrayUsingPredicate:timePredicate] mutableCopy];
    
    if(self.isAmount.on)
    {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"TotalAmount=%@",self.amountValue];
        if(self.amountType.selectedSegmentIndex == 0) predicate = [NSPredicate predicateWithFormat:@"TotalAmount<=%@",self.amountValue];
        else if(self.amountType.selectedSegmentIndex == 2) predicate = [NSPredicate predicateWithFormat:@"TotalAmount>=%@",self.amountValue];
        data = [[data filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    
    if(_contact) {
        if(self.transactionType == TransactionTypeSale)
        {
            NSPredicate *contactPredidate = [NSPredicate predicateWithFormat:@"CustID=%@",[(POSCustomer*)_contact Id]];
            data = [[data filteredArrayUsingPredicate:contactPredidate] mutableCopy];
        }
        else
        {
            NSPredicate *contactPredidate = [NSPredicate predicateWithFormat:@"SupplierID=%@",[(POSSupplier*)_contact Id]];
            data = [[data filteredArrayUsingPredicate:contactPredidate] mutableCopy];
        }
    }
    
    if(self.filtertype.selectedSegmentIndex == 1) {
        data = [[data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Balance > 0"] ] mutableCopy];
    }
   
    NSString *reportTile = @"";
    NSMutableArray *reportHeader;
    NSMutableArray *reportContents = [[NSMutableArray alloc] init];
    if(self.transactionType == TransactionTypeSale)
    {
        reportTile = @"Sale Invoices Report";
        reportHeader = [[NSMutableArray alloc] initWithObjects:
                  @"Issued Date",
                  @"Sale No",
                  @"Customer",
                  @"Credit Service",
                  @"Total",
                  @"Payment",
                  @"Balance",
                  nil];
        for (POSSaleInvoice *invoice in data) {
            POSCustomer *customer = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].customers withId:invoice.CustID];
            NSString* companyName = @"CUSTOMER DELETED";
            NSString* saleNo = [NSString stringWithFormat:@"MS%05d",[invoice.Id intValue]];
            if(customer) companyName = customer.CompanyName;
            NSMutableArray * item = [[NSMutableArray alloc] initWithObjects:
                      [POSCommon formatDateTimeToString:invoice.IssuedTime],
                      saleNo,
                      companyName,
                      invoice.CreditService?@"Yes":@"No",
                      [POSCommon formatCurrencyFromNumber:invoice.TotalAmount],
                      [POSCommon formatCurrencyFromNumber:invoice.TotalPayment],
                      [POSCommon formatCurrencyFromNumber:invoice.Balance],
                      nil];
            [reportContents addObject:item];
        }
    }
    else
    {
        reportTile = @"Purchases Report";
        reportHeader = [[NSMutableArray alloc] initWithObjects:
                  @"Issued Date",
                  @"Purchase No",
                  @"Supplier",
                  @"Credit Service",
                  @"Total",
                  @"Payment",
                  @"Balance",
                  nil];
        for (POSPurchase *purchase in data) {
            POSSupplier *supplier = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].suppliers withId:purchase.SupplierID];
            NSString* companyName = @"CUSTOMER DELETED";
            NSString* saleNo = [NSString stringWithFormat:@"MS%05d",[purchase.Id intValue]];
            if(supplier) companyName = supplier.CompanyName;
            NSMutableArray * item = [[NSMutableArray alloc] initWithObjects:
                                     [POSCommon formatDateTimeToString:purchase.IssuedTime],
                                     saleNo,
                                     companyName,
                                     purchase.CreditService?@"Yes":@"No",
                                     [POSCommon formatCurrencyFromNumber:purchase.TotalAmount],
                                     [POSCommon formatCurrencyFromNumber:purchase.TotalPayment],
                                     [POSCommon formatCurrencyFromNumber:purchase.Balance],
                                     nil];
            [reportContents addObject:item];
        }
        
    }
    
    ReportResultViewController *reportResultVC = [[ReportResultViewController alloc] initWithNibName:@"ReportResultViewController" bundle:nil];
    reportResultVC.reportTitle = reportTile;
    reportResultVC.reportHeader = reportHeader;
    reportResultVC.reportContents = reportContents;
    [self.navigationController pushViewController:reportResultVC animated:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtContact) {
        if(self.transactionType == TransactionTypeSale)
            [POSCommon showContactPicker:self contactType:ContactTypeCustomer allowSelectAll:NO target:self];
        else if(self.transactionType == TransactionTypePurchase)
            [POSCommon showContactPicker:self contactType:ContactTypeSuppplier allowSelectAll:NO target:self];
        return NO;
    }
    return YES;
}

- (void)contactSelectChanged:(id)contact
{
    _contact = contact;
    if(self.transactionType == TransactionTypeSale)
        self.txtContact.text = [(POSCustomer*)_contact CompanyName];
    else
        self.txtContact.text = [(POSSupplier*)_contact CompanyName];

}

@end
