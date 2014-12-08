//
//  CustomerSelectViewViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "CustomerSelectViewViewController.h"
#import "ContactFormViewController.h"
#import "GridTableViewCell.h"
#import "HeaderView.h"
#import "UserFormViewController.h"
#import "UserCollectionItemView.h"
#import "POSCustomer.h"
#import "POSSupplier.h"
#import "POSCommon.h"
#import "POSSaleInvoice.h"
#import "POSPurchase.h"

@interface CustomerSelectViewViewController () {
    NSMutableArray* cells;
}

@end

@implementation CustomerSelectViewViewController {
    NSArray *colSpans;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        colSpans = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:3],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:1],
                    nil];
        cells = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerClass:[UserCollectionItemView class] forCellWithReuseIdentifier:@"UserCollectionItemView"];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    if(self.allowSelectAll)
    {
        UIBarButtonItem *btnSelectAll = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStylePlain target:self action:@selector(doSelectAll)];
        self.navigationItem.rightBarButtonItem = btnSelectAll;
    }
    
    switch (self.contactType) {
        case ContactTypeCustomer:
        {
            datasource = [DBCaches sharedInstant].customers;
            self.title = @"Select a customer";
            break;
        }
        case ContactTypeSuppplier:
        {
            datasource = [DBCaches sharedInstant].suppliers;
            self.title = @"Select a supplier";
            break;
        }
        default:
            break;
    }
    NSPredicate *predidate = [NSPredicate predicateWithFormat:@"Status=%@",[NSNumber numberWithBool:YES]];
    datasource = [[datasource filteredArrayUsingPredicate:predidate] mutableCopy];

    [self setContentSize:[POSCommon isLandscapeMode]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLayout];
    self.navigationController.toolbarHidden = YES;
}

-(void) doCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) showAdd
{
    UserFormViewController *form = [[UserFormViewController alloc] initWithNibName:@"UserFormViewController" bundle:nil];
    [self.navigationController pushViewController:form animated:YES];
}

-(void) showFilter
{
    
}

- (void) doSelectAll
{
    [_delegate contactSelectChanged:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) setContentSize:(BOOL) landscapeMode
{
    if(landscapeMode)
         self.navigationController.view.superview.bounds = CGRectMake(0, 0, 800, 560);
    else
        self.navigationController.view.superview.bounds = CGRectMake(0, 0, 600, 880);
}

- (void)setDelegate:(id)target
{
    _delegate = target;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setContentSize:UIDeviceOrientationIsLandscape(toInterfaceOrientation)];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma UICollectionDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [datasource count];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cells addObject:cell];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserCollectionItemView *cell;
//    
//    if([cells count])
//    {
//        cell = [cells lastObject];
//        [cells removeLastObject];
//    }
//    else
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionItemView" forIndexPath:indexPath];
    switch (self.contactType) {
              case ContactTypeSuppplier:
        {
            POSSupplier *supplier = [datasource objectAtIndex:indexPath.item];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SupplierID=%@",supplier.Id];
            NSMutableArray* purchase = [[[DBCaches sharedInstant].purchases filteredArrayUsingPredicate:predicate] mutableCopy];
            float balance = 0;
            for (POSPurchase *invoice in purchase) {
                balance +=  [invoice.Balance floatValue];
            }
            supplier.CurrentBalance = [NSNumber numberWithFloat:balance];
            
            cell.person = supplier;

        }
        default:
        case ContactTypeCustomer:
        {
            POSCustomer *customer = [datasource objectAtIndex:indexPath.item];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CustID=%@",customer.Id];
            NSMutableArray* saleInvoices = [[[DBCaches sharedInstant].saleInvoices filteredArrayUsingPredicate:predicate] mutableCopy];
            float balance = 0;
            for (POSSaleInvoice *invoice in saleInvoices) {
                balance +=  [invoice.Balance floatValue];
            }
            customer.CurrentBalance = [NSNumber numberWithFloat:balance];
            cell.person = customer;
            break;
        }

    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.contactType) {
        case ContactTypeCustomer:
        {
            POSCustomer *customer = [datasource objectAtIndex:indexPath.item];
            [_delegate contactSelectChanged:customer];
            break;
        }
        case ContactTypeSuppplier:
        {
            POSSupplier *supplier = [datasource objectAtIndex:indexPath.item];
            [_delegate contactSelectChanged:supplier];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
