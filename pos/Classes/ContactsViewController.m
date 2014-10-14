//
//  ContactsViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ContactsViewController.h"
#import "GridTableViewCell.h"
#import "HeaderView.h"
#import "POSCustomer.h"
#import "POSSupplier.h"
#import "POSSaleInvoice.h"
#import "POSPurchase.h"
#import "UserCollectionItemView.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController {
//    NSArray *colSpans;
    DBManager *dbManager;
    NSMutableArray *cells;
    NSString* searchText;
    BOOL sortAcs;
    NSInteger sortBy;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        searchText = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(!dbManager)
        dbManager = [DBManager sharedInstant];
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAdd)];
    self.navigationItem.rightBarButtonItem = btnAdd;
    
    UIBarButtonItem *btnRefesh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.leftBarButtonItem = btnRefesh;
    [[DBManager sharedInstant] setDelegate:self];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerClass:[UserCollectionItemView class] forCellWithReuseIdentifier:@"UserCollectionItemView"];
    cells = [[NSMutableArray alloc] init];
    self.txtSearch.delegate = self;
    self.txtSortBy.delegate = self;
    self.txtSortType.delegate = self;
    self.txtSortBy.text = @"Name";
    self.txtSortType.text = @"ASC";
    sortAcs = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLayout];
    [self reloadData];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(doSelect)];
    self.navigationController.toolbarItems = [NSArray arrayWithObject:item];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .5;
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
}
- (void) handleLongPress:(UILongPressGestureRecognizer*) gestureReconizer
{
    if(gestureReconizer.state != UIGestureRecognizerStateEnded) return;
    
    CGPoint p = [gestureReconizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if(indexPath == nil) return;
    else {
        
        if(contactType == ContactTypeCustomer) {
            POSCustomer * customer = [datasource objectAtIndex:indexPath.row];
            NSString *msg = [NSString stringWithFormat:@"Please choose the action for customer '%@'",customer.CompanyName];

            NSString *enableStr = customer.Status ? @"Disable": @"Enable";
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Action" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:enableStr, @"Delete", nil];
            alert.tag = indexPath.row;
            [alert show];
        }
        else {
            POSSupplier * supplier = [datasource objectAtIndex:indexPath.row];
            NSString *msg = [NSString stringWithFormat:@"Please choose the action for supplier '%@'",supplier.CompanyName];
            NSString *enableStr = supplier.Status ? @"Disable": @"Enable";
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Action" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:enableStr, @"Delete", nil];
            alert.tag = indexPath.row;
            [alert show];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex]) return;
    if(buttonIndex == 2)
    {
        if(contactType == ContactTypeCustomer) {
            POSCustomer * customer = [datasource objectAtIndex:alertView.tag];
            [[DBManager sharedInstant] deleteData:kDbCustomers item:customer target:self];
        }
        else {
            POSSupplier * supplier = [datasource objectAtIndex:alertView.tag];
            [[DBManager sharedInstant] deleteData:kDbSuppliers item:supplier target:self];
        }
    }
    else {
        if(contactType == ContactTypeCustomer) {
            POSCustomer * customer = [datasource objectAtIndex:alertView.tag];
            customer.Status = !customer.Status;
            [[DBManager sharedInstant] saveData:kDbCustomers item:customer target:self];
        }
        else {
            POSSupplier * customer = [datasource objectAtIndex:alertView.tag];
            customer.Status = !customer.Status;
            [[DBManager sharedInstant] saveData:kDbSuppliers item:customer target:self];

        }
    }
}

-(void)saveDataCompleted:(POSObject *)insertedItem
{
    [self reloadData];

}

- (void)deleteDataCompleted:(id)objectId
{
    [self reloadData];
}

- (void) doSelect
{
    
}

- (void) reloadData
{
    if (contactType == ContactTypeCustomer)
        datasource = [DBCaches sharedInstant].customers;
    else
        datasource = [DBCaches sharedInstant].suppliers;
    if(searchText.length > 0) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"CompanyName BEGINSWITH[c] %@",searchText];
        datasource = [[datasource filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    [self.collectionView reloadData];
}

- (void)refresh
{
    if(contactType == ContactTypeCustomer)
        [[DBManager sharedInstant] requestData:kDbCustomers predicate:nil target:self];
    else
        [[DBManager sharedInstant] requestData:kDbSuppliers predicate:nil target:self];
}

-(void) showAdd
{
    ContactFormViewController *form = [[ContactFormViewController alloc] initWithNibName:@"ContactFormViewController" bundle:nil];
    [form setTarget:self];
    [form setContactType:contactType];
    [POSCommon showPopup:form from:self];
}

-(void) showFilter
{
    
}

-(void) setContactType:(ContactType)type {
    contactType = type;
    switch (contactType) {
        case ContactTypeCustomer:
            self.title = @"Customers";
            break;
        case ContactTypeSuppplier:
            self.title = @"Suppliers";
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ContactFormViewControllerDelegate
- (void)contactFormViewControllerCompleted
{
    [self reloadData];
}

#pragma mark
#pragma UICollectionDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section
{
    return [datasource count];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cells addObject:cell];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserCollectionItemView *cell;
    
//    if([cells count])
//    {
//        cell = [cells lastObject];
//        [cells removeLastObject];
//    }
//    else
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"UserCollectionItemView" forIndexPath:indexPath];
    if (contactType == ContactTypeCustomer) {
        POSCustomer *customer = [datasource objectAtIndex:indexPath.item];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CustID=%@",customer.Id];
        NSMutableArray* saleInvoices = [[[DBCaches sharedInstant].saleInvoices filteredArrayUsingPredicate:predicate] mutableCopy];
        float balance = 0;
        for (POSSaleInvoice *invoice in saleInvoices) {
            balance +=  [invoice.Balance floatValue];
        }
        customer.CurrentBalance = [NSNumber numberWithFloat:balance];
        [datasource setObject:customer atIndexedSubscript:indexPath.row];
        cell.person = customer;
    }
    else if (contactType == ContactTypeSuppplier){
        POSSupplier *supplier = [datasource objectAtIndex:indexPath.item];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SupplierID=%@",supplier.Id];
        NSMutableArray* purchase = [[[DBCaches sharedInstant].purchases filteredArrayUsingPredicate:predicate] mutableCopy];
        float balance = 0;
        for (POSPurchase *invoice in purchase) {
            balance +=  [invoice.Balance floatValue];
        }
        supplier.CurrentBalance = [NSNumber numberWithFloat:balance];
        [datasource setObject:supplier atIndexedSubscript:indexPath.row];
        cell.person = supplier;
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell setNeedsDisplay];
    return cell;
}

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    dbManager.synchronized = YES;
    if (contactType == ContactTypeCustomer) {
        POSCustomer *customers = [datasource objectAtIndex:indexPath.item];
        [self showEditCustomer:customers];
    }
    else if (contactType == ContactTypeSuppplier){
        POSSupplier *suppliers = [datasource objectAtIndex:indexPath.item];
        [self showEditSupplier:suppliers];
    }
    
}

-(void)showEditCustomer:(POSCustomer *)customer{
    ContactFormViewController *form = [[ContactFormViewController alloc] initWithNibName:@"ContactFormViewController" bundle:nil];
    [form setContactType:ContactTypeCustomer];
    [form setTarget:self];
    form.posCustomer = customer;
    [POSCommon showPopup:form from:self];
}

-(void)showEditSupplier:(POSSupplier *)supplier{
    ContactFormViewController *form = [[ContactFormViewController alloc] initWithNibName:@"ContactFormViewController" bundle:nil];
    [form setContactType:ContactTypeSuppplier];
    form.posSupplier = supplier;
    [form setTarget:self];
    [POSCommon showPopup:form from:self];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.txtSortBy)
    {
        NSMutableArray* ds = [[NSMutableArray alloc] initWithObjects:
                              @"Name",
                              @"Balance",
                              @"Status",
                              nil];
        [POSCommon showChooserWithData:ds from:self withTag:1];
    }
    else if(textField == self.txtSortType)
    {
        NSMutableArray *ds = [[NSMutableArray alloc] initWithObjects:
                              @"ASC",
                              @"DESC", nil];
        [POSCommon showChooserWithData:ds from:self withTag:2];
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.txtSearch){
        searchText = [searchText stringByReplacingCharactersInRange:range withString:string];
        textField.text = searchText;
        [self reloadData];
        return NO;
    }
    return YES;
}

#pragma mark
#pragma DBDelegate
- (void)dataTableViewControllerSelected:(NSIndexPath *)indexPath withTag:(NSInteger)tag
{
    switch (tag) {
        case 1:
        {
            NSMutableArray* ds = [[NSMutableArray alloc] initWithObjects:
                                  @"Name",
                                  @"Balance",
                                  @"Status",
                                  nil];
            NSString* value = [ds objectAtIndex:indexPath.row];
            self.txtSortBy.text = value;
            sortBy = indexPath.row;
            [self resortData];
            break;
        }
        case 2:
        {
            if(indexPath.row == 0)
                sortAcs = YES;
            else
                sortAcs = NO;
            [self resortData];
            break;
        }
        default:
            break;
    }
}
- (void)requestDataCompleted:(NSMutableArray *)results
{
    [self reloadData];
}

- (void)requestFailed:(NSError *)message{
    
}

- (void) resortData
{
    NSSortDescriptor* sortDes;
    switch (sortBy) {
        case 0:
        {
            sortDes = [[NSSortDescriptor alloc] initWithKey:@"CompanyName" ascending:sortAcs];
            break;
        }
        case 1:
        {
            sortDes = [[NSSortDescriptor alloc] initWithKey:@"CurrentBalance" ascending:sortAcs];
            break;
        }
        case 2:
        {
            sortDes = [[NSSortDescriptor alloc] initWithKey:@"Status" ascending:sortAcs];
            break;
        }
        default:
            break;
    }
    [datasource sortUsingDescriptors:[NSArray arrayWithObject:sortDes]];
    [self.collectionView reloadData];
}
@end
