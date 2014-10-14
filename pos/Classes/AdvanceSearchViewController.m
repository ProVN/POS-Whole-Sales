//
//  AdvanceSearchViewController.m
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "AdvanceSearchViewController.h"
#import "SearchResultViewController.h"

@interface AdvanceSearchViewController ()

@end

@implementation AdvanceSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Advance Search";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *btnFind = [[UIBarButtonItem alloc] initWithTitle:@"Find" style:UIBarButtonItemStyleBordered target:self action:@selector(doFind)];
    self.navigationItem.rightBarButtonItem = btnFind;
    
    UIBarButtonItem *btnClear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(doClear)];
    self.navigationItem.leftBarButtonItem = btnClear;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLayout];
}

- (void)doFind {
    SearchResultViewController *searchView = [[SearchResultViewController alloc] initWithNibName:@"SearchResultViewController" bundle:nil];
    searchView.isSales = self.isSales.on;
    searchView.isPurchases = self.isPurchase.on;
    searchView.isPayment = self.isPayment.on;
    searchView.contactName = self.contactName.text;
    searchView.isAmount = self.isAmount.on;
    searchView.amountType = self.amountType.selectedSegmentIndex;
    searchView.amountValue = [NSNumber numberWithFloat:[self.amountValue.text floatValue]];
    searchView.fromDate = self.fromDate.date;
    searchView.toDate = self.toDate.date;
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)doClear {
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
