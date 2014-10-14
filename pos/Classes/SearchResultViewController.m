//
//  SearchResultViewController.m
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "SearchResultViewController.h"
#import "UIViewController+POSViewController.h"
#import "GridTableViewCell.h"
#import "HeaderView.h"
#import "POSSaleInvoice.h"
#import "POSPurchase.h"
#import "POSSaleInvoicePayment.h"
#import "POSPurchasePayment.h"
#import "POSCustomer.h"
#import "POSSupplier.h"
#import "POSMeta.h"
#import "TransactionFormViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController {
    NSMutableArray* sales;
    NSMutableArray* salePayments;
    NSMutableArray* purchases;
    NSMutableArray* purchasePayments;
    NSArray *colTypes1;
    NSArray *colTypes2;
    NSArray *colSpan1;
    NSArray *colSpan2;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"Advance Search Results";
        sales = [[NSMutableArray alloc] init];
        salePayments = [[NSMutableArray alloc] init];
        purchases = [[NSMutableArray alloc] init];
        purchasePayments = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Init the data
    if(self.isSales)
        sales = [DBCaches sharedInstant].saleInvoices;
    if(self.isPurchases)
        purchases = [DBCaches sharedInstant].purchases;
    if(self.isPurchases){
        salePayments = [DBCaches sharedInstant].saleInvoicePayments;
        purchasePayments = [DBCaches sharedInstant].purchasePayments;
    }
    
    //Filter by time
    NSPredicate* timePredicate = [NSPredicate predicateWithFormat:@"AddedTime>=%@ && AddedTime<=%@",self.fromDate,self.toDate];
    if(self.isSales)
        sales = [[sales filteredArrayUsingPredicate:timePredicate] mutableCopy];
    if(self.isPurchases)
    purchases = [[purchases filteredArrayUsingPredicate:timePredicate] mutableCopy];
    if(self.isPayment) {
        timePredicate = [NSPredicate predicateWithFormat:@"PaymentTime>=%@ && PaymentTime<=%@",self.fromDate,self.toDate];
        salePayments = [[salePayments filteredArrayUsingPredicate:timePredicate] mutableCopy];
        purchasePayments = [[purchasePayments filteredArrayUsingPredicate:timePredicate] mutableCopy];
    }
    
    if(self.isAmount && [self.amountValue floatValue] > 0) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"TotalAmount=%@",self.amountValue];
        if(self.amountType == 0) predicate = [NSPredicate predicateWithFormat:@"TotalAmount<=%@",self.amountValue];
        else if(self.amountType == 2) predicate = [NSPredicate predicateWithFormat:@"TotalAmount>=%@",self.amountValue];
        if(self.isSales)
            sales = [[sales filteredArrayUsingPredicate:predicate] mutableCopy];
        if(self.isPurchases)
            purchases = [[purchases filteredArrayUsingPredicate:predicate] mutableCopy];
        
        if(self.isPayment){
            predicate = [NSPredicate predicateWithFormat:@"PaymentAmount=%@",self.amountValue];
            if(self.amountType == 0) predicate = [NSPredicate predicateWithFormat:@"PaymentAmount<=%@",self.amountValue];
            else if(self.amountType == 2) predicate = [NSPredicate predicateWithFormat:@"PaymentAmount>=%@",self.amountValue];
            salePayments = [[salePayments filteredArrayUsingPredicate:predicate] mutableCopy];
            purchasePayments = [[purchasePayments filteredArrayUsingPredicate:predicate] mutableCopy];
        }
    }
    
    colTypes1 = [[NSArray alloc] initWithObjects:
                [NSNumber numberWithInt:GridCellValueTypeDate],
                [NSNumber numberWithInt:GridCellValueName],
                [NSNumber numberWithInt:GridCellValueName],
                [NSNumber numberWithInt:GridCellValueBoolean],
                [NSNumber numberWithInt:GridCellValueMoney],
                [NSNumber numberWithInt:GridCellValueMoney],
                [NSNumber numberWithInt:GridCellValueMoney],
                nil];
    colTypes2 = [[NSArray alloc] initWithObjects:
                         [NSNumber numberWithInt:GridCellValueTypeDate],
                            [NSNumber numberWithInt:GridCellValueId],
                            [NSNumber numberWithInt:GridCellValueName],
                            [NSNumber numberWithInt:GridCellValueId],
                            [NSNumber numberWithInt:GridCellValueMoney],
                            nil];
    
    colSpan1 = [[NSArray alloc] initWithObjects:
                [NSNumber numberWithInt:2],
                [NSNumber numberWithInt:2],
                [NSNumber numberWithInt:4],
                [NSNumber numberWithInt:1],
                [NSNumber numberWithInt:2],
                [NSNumber numberWithInt:2],
                [NSNumber numberWithInt:2],
                nil];
    
    colSpan2 = [[NSArray alloc] initWithObjects:
                [NSNumber numberWithInt:1],
                [NSNumber numberWithInt:1],
                [NSNumber numberWithInt:2],
                [NSNumber numberWithInt:1],
                [NSNumber numberWithInt:1],
                nil];

    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numOfRows = 0;
    switch (section) {
        case 0:
        {
            numOfRows = sales.count;
            break;
        }
        case 1:
        {
            numOfRows = purchases.count;
            break;
        }
        case 2:
        {
            numOfRows = salePayments.count;
            break;
        }
        case 3:
        {
            numOfRows = purchasePayments.count;
            break;
        }
        default:
            break;
    }
    if(numOfRows > 0) return numOfRows + 1;
    else return numOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return @"Sale Invoices";
            break;
        }
        case 1:
        {
            return @"Purchase Invoices";
            break;
        }
        case 2:
        {
            return @"Sale Payments";
            break;
        }
        case 3:
        {
            return @"Purchases Payments";
            break;
        }
        default:
            return @"";
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridTableViewCell *cell = [[GridTableViewCell alloc] init];
    //Header for rows
    if(indexPath.row == 0)
    {
        cell.isHeader = YES;
        switch (indexPath.section) {
            case 0:
            {
                NSArray* values = [[NSArray alloc] initWithObjects:
                          @"Issued Date",
                          @"Sale No",
                          @"Customer",
                          @"Credit Service",
                          @"Total",
                          @"Payment",
                          @"Balance",
                          nil];
                cell.values = values;
                cell.colSpans = colSpan1;
                cell.colTypes = colTypes1;
                break;
            }
            case 1:
            {
                NSArray* values = [[NSArray alloc] initWithObjects:
                          @"Issued Date",
                          @"Purchase No",
                          @"Supplier",
                          @"Credit Service",
                          @"Total",
                          @"Payment",
                          @"Balance",
                          nil];
                cell.values = values;
                cell.colSpans = colSpan1;
                cell.colTypes = colTypes1;
                break;
            }
            case 2:
            {
                NSArray*  values  = [[NSArray alloc] initWithObjects:
                           @"Issued Date",
                           @"Sale No",
                           @"Customer",
                           @"Type",
                           @"Amount",
                           nil];
                cell.values = values;
                cell.colSpans = colSpan2;
                cell.colTypes = colTypes2;

                break;
            }
            case 3:
            {
                NSArray*  values  = [[NSArray alloc] initWithObjects:
                                     @"Issued Date",
                                     @"Purchase No",
                                     @"Supplier",
                                     @"Type",
                                     @"Amount",
                                     nil];
                cell.values = values;
                cell.colSpans = colSpan2;
                cell.colTypes = colTypes2;
                break;
            }
            default:
                break;
        }
    }
    else
    {
        cell.isHeader = NO;
        switch (indexPath.section) {
            case 0:
            {
                POSSaleInvoice *invoice = [sales objectAtIndex:indexPath.row -1];
                POSCustomer *customer = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].customers withId:invoice.CustID];
                NSString* companyName = @"CUSTOMER DELETED";
                if(customer) companyName = customer.CompanyName;
                NSArray* values = [[NSArray alloc] initWithObjects:
                          invoice.IssuedTime,
                          invoice.SaleInvoiceRef,
                          companyName,
                          invoice.CreditService?@"Yes":@"No",
                          invoice.TotalAmount,
                          invoice.TotalPayment,
                          invoice.Balance,
                          nil];
                cell.values = values;
                cell.colSpans = colSpan1;
                cell.colTypes = colTypes1;
                break;
            }
            case 1:
            {
                POSPurchase *purchase = [purchases objectAtIndex:indexPath.row - 1];
                POSSupplier *supplier = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].customers withId:purchase.SupplierID];
                NSString* companyName = @"SUPPLIER DELETED";
                if(supplier) companyName = supplier.CompanyName;
                NSArray* values = [[NSArray alloc] initWithObjects:
                          purchase.IssuedTime,
                          purchase.PurchaseRef,
                          companyName,
                          purchase.CreditService?@"Yes":@"No",
                          purchase.TotalAmount,
                          purchase.TotalPayment,
                          purchase.Balance,
                          nil];
                cell.values = values;
                cell.colTypes = colTypes1;
                break;
            }
            case 2:
            {
                POSSaleInvoicePayment *payment = [salePayments objectAtIndex:indexPath.row - 1];
                NSString *invoiceNo = @"";
                NSString *cusName = @"";
                POSSaleInvoice *invoice = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].saleInvoices withId:payment.SaleInvoiceID];
                if(invoice){
                    invoiceNo = [NSString stringWithFormat:@"MS%05ld",(long)[invoice.Id integerValue]];
                    POSCustomer *customer =  [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].customers withId:invoice.CustID];
                    if(customer)
                        cusName = customer.CompanyName;
                }
                NSArray* values = [[NSArray alloc] initWithObjects:
                          payment.PaymentTime,
                          invoiceNo,
                          cusName,
                          [[POSMeta sharedInstance] getPaymentName:[payment.PaymentType integerValue]],
                          payment.PaymentAmount,
                          nil];

                cell.values = values;
                cell.colSpans = colSpan2;
                cell.colTypes = colTypes2;
                break;
            }
            case 3:
            {
                POSPurchasePayment *payment = [purchasePayments objectAtIndex:indexPath.row -1];
                NSString *invoiceNo = @"";
                NSString *supName = @"";
                POSPurchase *invoice = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].purchases withId:payment.PurchaseID];
                if(invoice){
                    invoiceNo = [NSString stringWithFormat:@"PT%05ld",(long)[invoice.Id integerValue]];
                    POSSupplier *supplier =  [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].suppliers withId:invoice.SupplierID];
                    if(supplier)
                        supName = supplier.CompanyName;
                }
                NSArray* values = [[NSArray alloc] initWithObjects:
                          payment.PaymentTime,
                          invoiceNo,
                          supName,
                          [[POSMeta sharedInstance] getPaymentName:[payment.PaymentType integerValue]],
                          payment.PaymentAmount,
                          nil];

                cell.values = values;
                cell.colSpans = colSpan2;
                cell.colTypes = colTypes2;
                break;
            }
            default:
                break;
        }
    }
    [cell drawCell:self.view.frame.size.width -36];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else
    {
        switch (indexPath.section) {
            case 0:
            {
                TransactionFormViewController *form = [[TransactionFormViewController alloc] initWithNibName:@"TransactionFormViewController" bundle:nil];
                [form setTransaction:[sales objectAtIndex:indexPath.row-1] type:TransactionTypeSale];
                [self.navigationController pushViewController:form animated:YES];
                break;
            }
            case 1:
            {
                TransactionFormViewController *form = [[TransactionFormViewController alloc] initWithNibName:@"TransactionFormViewController" bundle:nil];
                [form setTransaction:[purchases objectAtIndex:indexPath.row-1] type:TransactionTypePurchase];
                [self.navigationController pushViewController:form animated:YES];
                break;
            }
            default:
            {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                break;
            }
        }
    }
}
@end
