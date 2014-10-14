//
//  PaymentsViewController.m
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "PaymentsViewController.h"
#import "GridTableViewCell.h"
#import "HeaderView.h"
#import "DateTimePickerViewController.h"
#import "DataTableViewController.h"
#import "POSSaleInvoicePayment.h"
#import "POSPurchasePayment.h"
#import "POSSaleInvoice.h"
#import "POSPurchase.h"
#import "POSCustomer.h"
#import "POSSupplier.h"
#import "POSMeta.h"

@interface PaymentsViewController ()

@end

@implementation PaymentsViewController {
    NSArray *colSpans;
    NSArray *colTypes;
    NSDate* searchFromDate;
    NSDate* searchToDate;
    POSObject *currentContact;
}
@synthesize txtDate, txtDateFrom,txtDateTo;
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

                             nil];
        colTypes = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:GridCellValueTypeDate],
                    [NSNumber numberWithInt:GridCellValueId],
                    [NSNumber numberWithInt:GridCellValueName],
                    [NSNumber numberWithInt:GridCellValueId],
                    [NSNumber numberWithInt:GridCellValueMoney],
                    nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtDate.delegate = self;
    txtDateFrom.delegate = self;
    txtDateTo.delegate = self;
   
    
    searchFromDate = [POSCommon getMinTimeInCurrentMonth];
    searchToDate = [POSCommon getMaxTimeInCurrentMonth];
    [self loadDateToTextField];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLayout];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.txtCustomer.delegate = self;
    [self loadData];
    
    if(contactType == ContactTypeCustomer)
        self.txtCustomer.text = @"All customers";
    else
        self.txtCustomer.text = @"All suppliers";
}

-(void)setContactType:(ContactType)type {
    contactType = type;
    switch (contactType) {
        case ContactTypeCustomer:
            self.title = @"Payments - from Customers";
            break;
        case ContactTypeSuppplier:
            self.title = @"Payments - from Suppliers";
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

- (void)loadData
{
    if(contactType == ContactTypeCustomer)
        datasource = [DBCaches sharedInstant].saleInvoicePayments;
    else
        datasource = [DBCaches sharedInstant].purchasePayments;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(PaymentTime >= %@) AND (PaymentTime<=%@)",searchFromDate, searchToDate];
    datasource = [[datasource filteredArrayUsingPredicate:predicate] mutableCopy];
    
    if(currentContact)
    {
        NSMutableArray *datasource_filtered = [[NSMutableArray alloc] init];
        if(contactType == ContactTypeCustomer){
            for (POSSaleInvoicePayment *payment in datasource) {
                POSSaleInvoice* saleInvoice = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].saleInvoices withId:payment.SaleInvoiceID];
                if([saleInvoice.CustID intValue] == [[(POSCustomer*)currentContact Id] intValue])
                    [datasource_filtered addObject:payment];
            }
        }
        else
        {
            for (POSPurchasePayment *payment in datasource) {
                POSPurchase* purchase = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].purchases withId:payment.PurchaseID];
                if([purchase.SupplierID intValue] == [[(POSSupplier*)currentContact Id] intValue])
                    [datasource_filtered addObject:payment];
            }
        }
        datasource = [datasource_filtered mutableCopy];
    }
    [self.tableView reloadData];
}

#pragma mark
#pragma UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];

    NSArray *values;
    if(contactType == ContactTypeCustomer)
    {
       values  = [[NSArray alloc] initWithObjects:
           @"Issued Date",
           @"Sale No",
           @"Customer",
           @"Type",
           @"Amount to Pay",
           nil];
    }
    else {
        values  = [[NSArray alloc] initWithObjects:
                   @"Issued Date",
                   @"Purchase No",
                   @"Supplier",
                   @"Type",
                   @"Amount to Pay",
                   nil];
    }
    header.values = values;
    header.colSpans = colSpans;
    [header drawCell:self.view.frame.size.width - 36];
    return header;
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
    
    
    
    NSArray *values;
    if(contactType == ContactTypeCustomer)
    {
        POSSaleInvoicePayment *payment = [datasource objectAtIndex:indexPath.row];
        NSString *invoiceNo = @"";
        NSString *cusName = @"";
        POSSaleInvoice *invoice = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].saleInvoices withId:payment.SaleInvoiceID];
        if(invoice){
            invoiceNo = [NSString stringWithFormat:@"MS%05ld",(long)[invoice.Id integerValue]];
            POSCustomer *customer =  [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].customers withId:invoice.CustID];
            if(customer)
                cusName = customer.CompanyName;
        }
        values = [[NSArray alloc] initWithObjects:
                  payment.PaymentTime,
                  invoiceNo,
                  cusName,
                  [[POSMeta sharedInstance] getPaymentName:[payment.PaymentType integerValue]],
                  payment.PaymentAmount,
                  nil];
    }
    else
    {
        POSPurchasePayment *payment = [datasource objectAtIndex:indexPath.row];
        NSString *invoiceNo = @"";
        NSString *supName = @"";
        POSPurchase *invoice = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].purchases withId:payment.PurchaseID];
        if(invoice){
            invoiceNo = [NSString stringWithFormat:@"PT%05ld",(long)[invoice.Id integerValue]];
            POSSupplier *supplier =  [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].suppliers withId:invoice.SupplierID];
            if(supplier)
                supName = supplier.CompanyName;
        }
        values = [[NSArray alloc] initWithObjects:
                  payment.PaymentTime,
                  invoiceNo,
                  supName,
                  [[POSMeta sharedInstance] getPaymentName:[payment.PaymentType integerValue]],
                  payment.PaymentAmount,
                  nil];
    }
    cell.values = values;
    cell.colSpans = colSpans;
    cell.colTypes = colTypes;
    [cell drawCell:self.view.frame.size.width - 36];
    return cell;
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
    else if(textField == txtDate) {
        [POSCommon showChooserWithData:[POSMeta sharedInstance].timeListStr from:self withTag:1];
        return NO;
    }
    else if(textField == self.txtCustomer)
    {
        [POSCommon showContactPicker:self contactType:contactType allowSelectAll:YES target:self];
        return NO;
    }
    return YES;
}

#pragma mark
#pragma mark ContactSelectDelegate
- (void)contactSelectChanged:(id)contact
{
    currentContact = contact;
    if(contactType == ContactTypeCustomer)
    {
        if(currentContact == nil)
            self.txtCustomer.text = @"All customers";
        else {
            POSCustomer * customer = (POSCustomer*) currentContact;
            self.txtCustomer.text = customer.CompanyName;
        }
    }
    else
    {
        if(currentContact == nil)
            self.txtCustomer.text = @"All suppliers";
        else {
            POSCustomer * supplier = (POSCustomer*) currentContact;
            self.txtCustomer.text = supplier.CompanyName;
        }
    }
    [self loadData];
}

#pragma mark
#pragma mark DataTableViewControllerDelegate


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

- (void) loadDateToTextField
{
    self.txtDateFrom.text = [POSCommon formatDateToString:searchFromDate];
    self.txtDateTo.text = [POSCommon formatDateToString:searchToDate];
}
- (void)dataTableViewControllerSelected:(NSIndexPath *)indexPath withTag:(NSInteger)tag
{
    TimeObject* timeObject = [[POSMeta sharedInstance] getTimeObject:indexPath.row];
    NSString* val = [[POSMeta sharedInstance].timeListStr objectAtIndex:indexPath.row];
    searchFromDate = timeObject.minDate;
    searchToDate = timeObject.maxDate;
    self.txtDate.text = val;
    [self loadDateToTextField];
    [self loadData];
}
@end
