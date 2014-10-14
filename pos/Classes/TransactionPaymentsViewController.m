//
//  TransactionPaymentsViewController.m
//  pos
//
//  Created by Loc Tran on 9/19/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "TransactionPaymentsViewController.h"
#import "DateTimePickerViewController.h"
#import "DataTableViewController.h"
#import "HeaderView.h"
#import "GridTableViewCell.h"
#import "DBManager.h"
#import "POSSaleInvoice.h"
#import "POSPurchase.h"
#import "POSCustomer.h"
#import "POSSupplier.h"
#import "POSUser.h"
#import "POSMeta.h"

@interface TransactionPaymentsViewController ()

@end

@implementation TransactionPaymentsViewController {
    NSArray *colSpans;
    NSArray *colTypes;
    DBCaches *dbCaches;
    NSInteger sortByCol;
    BOOL unpadOnly;
    NSMutableArray *payments;
    int insertIndex;
    UIAlertView *alert;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        colSpans = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    nil];
        colTypes = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:GridCellValueTypeDate],
                    [NSNumber numberWithInt:GridCellValueName],
                    [NSNumber numberWithInt:GridCellValueName],
                    [NSNumber numberWithInt:GridCellValueMoney],
                    [NSNumber numberWithInt:GridCellValueMoney],
                    [NSNumber numberWithInt:GridCellValueMoney],
                    [NSNumber numberWithInt:GridCellValueMoney],
                    [NSNumber numberWithInt:GridCellValueName],
                    [NSNumber numberWithInt:GridCellValueTypeDate],
                    nil];
        dbCaches = [DBCaches sharedInstant];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *btnFilter = [[UIBarButtonItem alloc] initWithTitle:@"Unpaid & Paid" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:btnDone, btnFilter, nil];
    
    self.txtDateFrom.delegate = self;
    self.txtDateTo.delegate = self;
    self.txtDate.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    searchFromDate = [POSCommon getMinTimeInCurrentMonth];
    searchToDate = [POSCommon getMaxTimeInCurrentMonth];
    [self loadDateToTextField];
    [self loadData];
    unpadOnly = NO;
    payments = [[NSMutableArray alloc] init];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLayout];
    [self loadData];
}

- (void)done
{
    insertIndex = -1;
    alert = [[UIAlertView alloc] initWithTitle:@"Saving..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self insertPaymentItem];
}
- (void)requestFailed:(NSError *)message
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) insertPaymentItem
{
    insertIndex++;
    if(insertIndex >= [payments count]) {
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
        payments = [[NSMutableArray alloc] init];
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Completed" message:@"Data save completed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
        [self loadData];
        return;
    }
    
    if(transactionType == TransactionTypeSale)
    {
        POSSaleInvoicePayment* payment = [payments objectAtIndex:insertIndex];
        [[DBManager sharedInstant] saveData:kDbSaleInvoicePayments item:payment title:nil message:nil target:self];
    }
    else
    {
        POSSaleInvoicePayment* payment = [payments objectAtIndex:insertIndex];
        [[DBManager sharedInstant] saveData:kDbPurchasePayments item:payment title:nil message:nil target:self];
    }
}

-(void)loadData
{
    if(transactionType == TransactionTypeSale)
        not_filtered_datasource = [DBCaches sharedInstant].saleInvoices;
    else
        not_filtered_datasource = [DBCaches sharedInstant].purchases;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(IssuedTime >= %@) AND (IssuedTime<=%@)",searchFromDate, searchToDate];
    not_filtered_datasource = [[not_filtered_datasource filteredArrayUsingPredicate:predicate] mutableCopy];
    
    if(unpadOnly) {
        predicate = [NSPredicate predicateWithFormat:@"Balance > 0"];
        datasource = [[not_filtered_datasource filteredArrayUsingPredicate:predicate ] mutableCopy];
    }
    else {
        datasource = [not_filtered_datasource mutableCopy];
    }
    [self.tableView reloadData];
}

-(void) refresh
{
    unpadOnly = !unpadOnly;
    UIBarButtonItem *btnFilter = self.navigationItem.leftBarButtonItem;
    if(!unpadOnly)
        [btnFilter setTitle:@"Unpaid & Paid"];
    else
        [btnFilter setTitle:@"Unpaid Only"];
    [self loadData];
}

- (void)setTransactionType:(TransactionType)type {
    transactionType = type;
    switch (transactionType) {
        case TransactionTypePurchase:
            self.title = @"Payments for Suppliers";
            break;
        case TransactionTypeSale:
            self.title = @"Payments for Customers";
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView layoutSubviews];
    [self.tableView reloadData];
}

#pragma mark
#pragma mark DBDelegate
- (void)requestDataCompleted:(NSMutableArray *)results
{
    [self loadData];
}

- (void)insertDataCompleted:(POSObject *)insertedItem
{
    [self loadData];
}

- (void)updateDataCompleted:(POSObject *)updatedItem
{
    [self loadData];
}

- (void)deleteDataCompleted:(id)objectId
{
    [self loadData];
}

- (void)saveDataCompleted:(POSObject *)insertedItem
{
    [self insertPaymentItem];
}
#pragma mark
#pragma UITextFieldDelegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtDateFrom || textField == self.txtDateTo) {
        DateTimePickerViewController *vc = [[DateTimePickerViewController alloc] initWithNibName:@"DateTimePickerViewController" bundle:nil];
        if(textField == self.txtDateFrom) {
            [vc setTag:1];
            vc.datetime = searchFromDate;
        }
        else {
            [vc setTag:2];
            vc.datetime = searchToDate;
        }
        [vc setDelegate:self];
        [POSCommon showPopup:vc from:self];
    }
    else if(textField == self.txtDate) {
        
        NSMutableArray* dataSource =[POSMeta sharedInstance].timeListStr;
        [POSCommon showChooserWithData:dataSource from:self withTag:1];
        return NO;
    }
    return NO;
}

- (void)dateTimePickerSaved:(NSDate *)date tag:(int)tag
{
    switch (tag) {
        case 1:
            searchFromDate = [POSCommon getMinTimeInDay:date];
            if(searchToDate < searchFromDate)
                searchToDate = searchFromDate;
            break;
        case 2:
            searchToDate = [POSCommon getMaxTimeInDay:date];
            if(searchFromDate > searchToDate)
                searchFromDate = searchToDate;
            break;
        default:
            break;
    }
    
    [self loadDateToTextField];
    self.txtDate.text = @"Custom";
    [self loadData];
}

- (void)dataTableViewControllerSelected:(NSIndexPath *)indexPath withTag:(NSInteger)tag
{
    switch (tag) {
        case 1:
        {
            TimeObject* timeObject = [[POSMeta sharedInstance] getTimeObject:indexPath.row];
            NSString* val = [[POSMeta sharedInstance].timeListStr objectAtIndex:indexPath.row];
            searchFromDate = timeObject.minDate;
            searchToDate = timeObject.maxDate;
            self.txtDate.text = val;
            [self loadDateToTextField];
            break;
        }

        default:
            break;
    }
}
- (void) loadDateToTextField
{
    self.txtDateFrom.text = [POSCommon formatDateToString:searchFromDate];
    self.txtDateTo.text = [POSCommon formatDateToString:searchToDate];
}

#pragma mark
#pragma UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    NSArray *values;
    if(transactionType == TransactionTypeSale)
    {
        values = [[NSArray alloc] initWithObjects:
                  @"Issued Date",
                  @"Sale No",
                  @"Customer",
                  @"Total",
                  @"Payment",
                  @"Balance",
                  @"Amount to Pay",
                  @"Payment type",
                  @"Payment date",
                  nil];
    }
    else
    {
        values = [[NSArray alloc] initWithObjects:
                  @"Issued Date",
                  @"Purchase No",
                  @"Supplier",
                  @"Total",
                  @"Payment",
                  @"Balance",
                  @"Amount to Pay",
                  @"Payment type",
                  @"Payment date",
                  nil];
    }
    header.values = values;
    header.colSpans = colSpans;
    [header drawCell:self.view.frame.size.width - 36];
    return header;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(transactionType == TransactionTypeSale)
    {
        POSSaleInvoice *invoice = [datasource objectAtIndex:indexPath.row];
        [[DBManager sharedInstant] deleteData:kDbSaleInvoices item:invoice target:self];
    }
    else
    {
        POSPurchase *invoice = [datasource objectAtIndex:indexPath.row];
        [[DBManager sharedInstant] deleteData:kDbPurchases item:invoice target:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridTableViewCell *cell = [[GridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSArray* values;
    
    if(transactionType == TransactionTypeSale)
    {
        POSSaleInvoice *invoice = [datasource objectAtIndex:indexPath.row];
        POSCustomer *customer = [dbCaches getObjectInCaches:dbCaches.customers withId:invoice.CustID];
        NSString* companyName = @"CUSTOMER DELETED";
        if(customer) companyName = customer.CompanyName;
        
        POSSaleInvoicePayment *payment;
        for (POSSaleInvoicePayment *obj in payments) {
            if([obj.SaleInvoiceID intValue] == [invoice.Id intValue]){
                payment = obj;
                break;
            }
        }
        
        float balance = [invoice.TotalAmount floatValue];
        NSPredicate *predidate = [NSPredicate predicateWithFormat:@"SaleInvoiceID=%@",invoice.Id];
        NSMutableArray *pl = [DBCaches sharedInstant].saleInvoicePayments;
        pl = [[pl filteredArrayUsingPredicate:predidate] mutableCopy];
        
        for (POSPurchasePayment *obj in pl) {
            balance -= [obj.PaymentAmount floatValue];
        }
        
        values = [[NSArray alloc] initWithObjects:
                  invoice.IssuedTime,
                  invoice.SaleInvoiceRef,
                  companyName,
                  invoice.TotalAmount,
                  invoice.TotalPayment,
                  [NSNumber numberWithFloat:balance],
                  payment? payment.PaymentAmount: nil,
                  payment? [[POSMeta sharedInstance] getPaymentName:[payment.PaymentType integerValue]]: nil,
                  payment? payment.PaymentTime : nil,
                  nil];
        
    }
    else
    {
        POSPurchase *purchase = [datasource objectAtIndex:indexPath.row];
        POSSupplier *supplier = [dbCaches getObjectInCaches:dbCaches.customers withId:purchase.SupplierID];
        NSString* companyName = @"SUPPLIER DELETED";
        if(supplier) companyName = supplier.CompanyName;
        
        POSPurchasePayment *payment;
        
        for (POSPurchasePayment *obj in payments) {
            if([obj.PurchaseID intValue] == [purchase.Id intValue]){
                payment = obj;
                break;
            }
        }
        
        float balance = [purchase.TotalAmount floatValue];
        NSPredicate *predidate = [NSPredicate predicateWithFormat:@"PurchaseID=%@",purchase.Id];
        NSMutableArray *pl = [DBCaches sharedInstant].saleInvoicePayments;
        pl = [[pl filteredArrayUsingPredicate:predidate] mutableCopy];
        
        for (POSPurchasePayment *obj in pl) {
            balance -= [obj.PaymentAmount floatValue];
        }

        
        values = [[NSArray alloc] initWithObjects:
                  purchase.IssuedTime,
                  purchase.PurchaseRef,
                  companyName,
                  purchase.TotalAmount,
                  purchase.TotalPayment,
                  [NSNumber numberWithFloat:balance],
                  payment? payment.PaymentAmount: nil,
                  payment? [[POSMeta sharedInstance] getPaymentName:[payment.PaymentType integerValue]]: nil,
                  payment? payment.PaymentTime : nil,
                  nil];
        
    }
    cell.isEnable = YES;
    cell.values = values;
    cell.colSpans = colSpans;
    cell.colTypes = colTypes;
    [cell drawCell:self.view.frame.size.width - 36];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    float balance = 0;
    id item;
    if(transactionType == TransactionTypeSale)
    {
        POSSaleInvoicePayment* paymentItem;
        POSSaleInvoice *invoice = [datasource objectAtIndex:indexPath.row];
        balance = [invoice.Balance floatValue];
        for (POSSaleInvoicePayment *obj in payments) {
            if([obj.SaleInvoiceID intValue] == [invoice.Id intValue]){
                paymentItem = obj;
                break;
            }
        }
        if(paymentItem == nil)
        {
            paymentItem = [[POSSaleInvoicePayment alloc] init];
            paymentItem.PaymentTime = [NSDate date];
            paymentItem.PaymentType = [NSNumber numberWithInt:1];
            paymentItem.PaymentAmount = invoice.Balance;
        }
        paymentItem.SaleInvoiceID = invoice.Id;
        item = paymentItem;
    }
    else
    {
        POSPurchasePayment* paymentItem = [[POSPurchasePayment alloc] init];
        POSPurchase *purchase = [datasource objectAtIndex:indexPath.row];
        balance = [purchase.Balance floatValue];
        
        for (POSPurchasePayment *obj in payments) {
            if([obj.PurchaseID intValue] == [purchase.Id intValue]){
                paymentItem = obj;
                break;
            }
        }
        if(paymentItem == nil)
        {
            paymentItem = [[POSPurchasePayment alloc] init];
            paymentItem.PurchaseID = purchase.Id;
            paymentItem.PaymentTime = [NSDate date];
            paymentItem.PaymentType = [NSNumber numberWithInt:1];
            paymentItem.PaymentAmount = purchase.Balance;
        }
        paymentItem.PurchaseID = purchase.Id;
        item = paymentItem;
    }
    
    PaymentFormViewController *payment = [[PaymentFormViewController alloc] initWithNibName:@"PaymentFormViewController" bundle:nil];
    [payment setPaymentItem:item transactionType:transactionType target:self];
    payment.balance = [NSNumber numberWithFloat:balance];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payment];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)paymentInputSaved:(id)paymentItem
{
    [payments addObject:paymentItem];
    [self.tableView reloadData];
}
- (void)paymentInputCanceled
{
    
}
@end
