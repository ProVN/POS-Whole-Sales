//
//  ProductsViewController.m
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ProductsViewController.h"
#import "GridTableViewCell.h"
#import "HeaderView.h"
#import "DataTableViewController.h"
#import "DBCaches.h"
#import "POSProduct.h"
#import "POSProductHistory.h"
#import "POSPurchaseDetail.h"
#import "POSSaleInvoiceDetail.h"

@interface ProductsViewController ()

@end

@implementation ProductsViewController{
    NSArray *colSpans;
    NSArray *colTypes;
    DBCaches* dbCache;
    NSString* searchText;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        colSpans = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:4],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    nil];
        colTypes = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:GridCellValueName],
                    [NSNumber numberWithInt:GridCellValueNumber],
                    [NSNumber numberWithInt:GridCellValueNumber],
                    [NSNumber numberWithInt:GridCellValueNumber],
                    [NSNumber numberWithInt:GridCellValueNumber],
                    nil];
        dbCache = [DBCaches sharedInstant];
        searchText = @"";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAdd)];
    self.navigationItem.rightBarButtonItem = btnAdd;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.txtSearch.delegate = self;
    self.title = [NSString stringWithFormat:@"Sub produces of %@",self.category.Name];
    self.txtFilter.delegate = self;
    self.txtFilter.text = [[POSMeta sharedInstance].produceMonthStr objectAtIndex:self.filterDateIndex];
    self.txtFilter.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLayout];
    [self reloadData];
}

-(void) showAdd
{
    ProductFormViewController *form = [[ProductFormViewController alloc] initWithNibName:@"ProductFormViewController" bundle:nil];
    form.category = self.category;
    [form setTarget:self];
    [POSCommon showPopup:form from:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData
{
    datasource = dbCache.products;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CategoryId=%@",self.category.Id];
    datasource = [[datasource filteredArrayUsingPredicate:predicate] mutableCopy];
    
    if(searchText.length > 0){
        predicate = [NSPredicate predicateWithFormat:@"Name BEGINSWITH[c] %@",self.txtSearch.text];
        datasource = [[datasource filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    [self.tableView reloadData];
}
#pragma mark
#pragma UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    NSArray *values = [[NSArray alloc] initWithObjects:
                       @"Name",
                       @"Stock Purchased",
                       @"Stock Sold",
                       @"Est Stock Balance",
                       @"Stock On Hand",
                       nil];
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
    
    POSProduct *product = [datasource objectAtIndex:indexPath.row];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductID=%@",product.Id];
    
    NSMutableArray* sale_datasource = [[dbCache.saleInvoiceDetails filteredArrayUsingPredicate:predicate] mutableCopy];
    NSMutableArray* purchase_datasource = [[dbCache.purchaseDetail filteredArrayUsingPredicate:predicate] mutableCopy];
    NSMutableArray* history_datasource = [[dbCache.productHistories filteredArrayUsingPredicate:predicate] mutableCopy];

    
    NSInteger stock_purchased = 0;
    for (POSPurchaseDetail* item in purchase_datasource) {
        stock_purchased += [item.Quantity integerValue];
    }
    
    NSInteger stock_sold = 0;
    for(POSSaleInvoiceDetail* item in sale_datasource) {
        stock_sold += [item.Quantity integerValue];
    }
    
    NSInteger stock_on_hand = 0;
    for(POSProductHistory* item in history_datasource)
    {
        if(item.AddedTime < [[POSMeta sharedInstance].produceMonth objectAtIndex:self.filterDateIndex])
            stock_on_hand = [item.StockOnHand integerValue];
    }
    
    NSInteger est_stock_balance = stock_on_hand + stock_purchased - stock_sold;;
    
    NSArray *values = [[NSArray alloc] initWithObjects:
                       product.Name,
                       [NSNumber numberWithInteger:stock_purchased],
                       [NSNumber numberWithInteger:stock_sold],
                       [NSNumber numberWithInteger:est_stock_balance],
                       [NSNumber numberWithInteger:stock_on_hand],
                    nil];
    
    cell.values = values;
    cell.colSpans = colSpans;
    cell.colTypes = colTypes;
    cell.isEnable = product.Status;
    [cell drawCell:self.view.frame.size.width - 36];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductFormViewController *form = [[ProductFormViewController alloc] initWithNibName:@"ProductFormViewController" bundle:nil];
    form.category = self.category;
    POSProduct *product = [datasource objectAtIndex:indexPath.row];
    form.product = product;
    [form setTarget:self];
    [POSCommon showPopup:form from:self];
}

#pragma mark
#pragma UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.txtSearch) {
        searchText = [searchText stringByReplacingCharactersInRange:range withString:string];
        textField.text = searchText;
        [self reloadData];
        return NO;
    }
    return YES;
}

#pragma mark - 
#pragma mark ProductFormViewControllerDelegate
- (void)productFormViewControllerCompleted
{
    [self reloadData];
}
@end
