//
//  SalesViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "TransactionsViewController.h"
#import "TransactionFormViewController.h"
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
#import "POSSaleInvoicePayment.h"
#import "POSPurchasePayment.h"

@interface TransactionsViewController ()

@end

@implementation TransactionsViewController {
    NSArray *colSpans;
    NSArray *colTypes;
    DBCaches *dbCaches;
    BOOL unpadOnly;
    BOOL sortAcs;
    NSInteger sortByCol;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        colSpans = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:4],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:2],
                    nil];
        colTypes = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:GridCellValueTypeDate],
                    [NSNumber numberWithInt:GridCellValueName],
                    [NSNumber numberWithInt:GridCellValueName],
                    [NSNumber numberWithInt:GridCellValueId],
                    [NSNumber numberWithInt:GridCellValueMoney],
                    [NSNumber numberWithInt:GridCellValueMoney],
                    [NSNumber numberWithInt:GridCellValueMoney],
                    nil];
        dbCaches = [DBCaches sharedInstant];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAdd)];
    self.navigationItem.rightBarButtonItem = btnAdd;
    
    UIBarButtonItem *btnFilter = [[UIBarButtonItem alloc] initWithTitle:@"Unpaid & Paid" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    self.navigationItem.leftBarButtonItem = btnFilter;
    
    self.txtDateFrom.delegate = self;
    self.txtDateTo.delegate = self;
    self.txtDate.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.txtSortBy.delegate = self;
    self.txtSortType.delegate = self;
    self.txtSortBy.text = @"Issued Date";
    self.txtSortType.text = @"DESC";
    
    sortAcs = NO;
    
    searchFromDate = [POSCommon getMinTimeInCurrentMonth];
    searchToDate = [POSCommon getMaxTimeInCurrentMonth];
    [self loadDateToTextField];
    [self loadData];
    unpadOnly = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLayout];
    [self loadData];
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

-(void) showAdd
{
    TransactionFormViewController *form = [[TransactionFormViewController alloc] initWithNibName:@"TransactionFormViewController" bundle:nil];
    [form setTransaction:nil type:transactionType];
    [self.navigationController pushViewController:form animated:YES];
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
            self.title = @"Purchases";
            break;
        case TransactionTypeSale:
            self.title = @"Sales";
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
- (void)requestFailed:(NSError *)message
{
    
}

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
    else if(textField == self.txtSortBy)
    {
        NSMutableArray *ds;
        if(transactionType == TransactionTypeSale)
        {
            ds = [[NSMutableArray alloc] initWithObjects:
                      @"Issued Date",
                      @"Sale No",
                      @"Customer",
                      @"Credit Service",
                      @"Total",
                      @"Payment",
                      @"Balance",
                      nil];
        }
        else
        {
            ds = [[NSMutableArray alloc] initWithObjects:
                      @"Issued Date",
                      @"Purchase No",
                      @"Supplier",
                      @"Credit Service",
                      @"Total",
                      @"Payment",
                      @"Balance",
                      nil];
        }
        [POSCommon showChooserWithData:ds from:self withTag:2];
    }
    else if(textField == self.txtSortType)
    {
        NSMutableArray *ds = [[NSMutableArray alloc] initWithObjects:
                                  @"ASC",
                                  @"DESC", nil];
        [POSCommon showChooserWithData:ds from:self withTag:3];
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
            [self loadData];
            break;
        }
        case 2:
        {
            NSMutableArray *ds;
            if(transactionType == TransactionTypeSale)
            {
                ds = [[NSMutableArray alloc] initWithObjects:
                      @"Issued Date",
                      @"Sale No",
                      @"Credit Service",
                      @"Total",
                      @"Payment",
                      @"Balance",
                      nil];
            }
            else
            {
                ds = [[NSMutableArray alloc] initWithObjects:
                      @"Issued Date",
                      @"Purchase No",
                      @"Credit Service",
                      @"Total",
                      @"Payment",
                      @"Balance",
                      nil];
            }
            NSString* value = [ds objectAtIndex:indexPath.row];
            self.txtSortBy.text = value;
            sortByCol = indexPath.row;
            [self resortData];
            break;
        }
        case 3:
        {
            if(indexPath.row == 0)
                sortAcs = YES;
            else
                sortAcs = NO;
            [self resortData];
            
        }
        default:
            break;
    }
}

- (void) resortData;
{
    if(transactionType == TransactionTypeSale)
    {
        NSSortDescriptor* sortDes;
        switch (sortByCol) {
            case 0:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"IssuedTime" ascending:sortAcs];
                break;
            }
            case 1:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"SaleInvoiceRef" ascending:sortAcs];
                break;
            }
            case 2:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"CreditService" ascending:sortAcs];
                break;
            }
            case 3:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"TotalAmount" ascending:sortAcs];
                break;
            }
            case 4:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"TotalPayment" ascending:sortAcs];
                break;
            }
            case 5:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"Balance" ascending:sortAcs];
                break;
            }
            default:
                break;
        }
        [datasource sortUsingDescriptors:[NSArray arrayWithObject:sortDes]];
        [self.tableView reloadData];
    }
    else
    {
        NSSortDescriptor* sortDes;
        switch (sortByCol) {
            case 0:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"IssuedTime" ascending:sortAcs];
                break;
            }
            case 1:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"PurchaseRef" ascending:sortAcs];
                break;
            }
            case 2:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"CreditService" ascending:sortAcs];
                break;
            }
            case 3:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"TotalAmount" ascending:sortAcs];
                break;
            }
            case 4:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"TotalPayment" ascending:sortAcs];
                break;
            }
            case 5:
            {
                sortDes = [[NSSortDescriptor alloc] initWithKey:@"Balance" ascending:sortAcs];
                break;
            }
            default:
                break;
        }
        [datasource sortUsingDescriptors:[NSArray arrayWithObject:sortDes]];
        [self.tableView reloadData];

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
                       @"Credit Service",
                       @"Total",
                       @"Payment",
                       @"Balance",
                       nil];
    }
    else
    {
        values = [[NSArray alloc] initWithObjects:
                  @"Issued Date",
                  @"Purchase No",
                  @"Supplier",
                  @"Credit Service",
                  @"Total",
                  @"Payment",
                  @"Balance",
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
                           invoice.CreditService?@"Yes":@"No",
                           invoice.TotalAmount,
                           invoice.TotalPayment,
                           [NSNumber numberWithFloat:balance],
                           nil];

    }
    else
    {
        POSPurchase *purchase = [datasource objectAtIndex:indexPath.row];
        POSSupplier *supplier = [dbCaches getObjectInCaches:dbCaches.customers withId:purchase.SupplierID];
        NSString* companyName = @"SUPPLIER DELETED";
        if(supplier) companyName = supplier.CompanyName;
        
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
                  purchase.CreditService?@"Yes":@"No",
                  purchase.TotalAmount,
                  purchase.TotalPayment,
                  [NSNumber numberWithFloat:balance],
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
    TransactionFormViewController *form = [[TransactionFormViewController alloc] initWithNibName:@"TransactionFormViewController" bundle:nil];
    [form setTransaction:[datasource objectAtIndex:indexPath.row] type:transactionType];
    [self.navigationController pushViewController:form animated:YES];
}
@end
