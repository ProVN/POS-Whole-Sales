//
//  MasterViewController.m
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MenuItem.h"
#import "MenuTableViewCell.h"
#import "AdvanceSearchViewController.h"
#import "TransactionsViewController.h"
#import "ContactsViewController.h"
#import "CategoryViewController.h"
#import "PaymentMenuViewController.h"
#import "UsersViewController.h"
#import "MetaDataViewController.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ReportResultViewController.h"
#import "TransactionReportViewController.h"


@interface MasterViewController () {
    NSMutableArray *_objects;
    UISplitViewController *splitView;
    DetailViewController *detailView;
    MenuItem *targetMenuItem;
    UILabel *labelleft;
    UILabel *labelright;
}
@end

MasterViewController *masterView = nil;

@implementation MasterViewController

+ (MasterViewController *)masterView {
    return masterView;
}

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    masterView = self;
    [self initMenuItems];
    self.rightViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject]
                                                        topViewController];
    
    detailView = (DetailViewController *)[[self.splitViewController.viewControllers lastObject]
                                          topViewController];
    
    splitView = [(AppDelegate*)[UIApplication sharedApplication].delegate rootView];
    [splitView setValue:[NSNumber numberWithFloat:270.0] forKey:@"_masterColumnWidth"];
    splitView.delegate = self;
    self.navigationController.toolbarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"mainlogo"] forBarMetrics:UIBarMetricsDefault];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnHome = [[UIButton alloc] initWithFrame:CGRectMake(50, -20, 170, 60)];
    [btnHome addTarget:self action:@selector(showHome) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.navigationBar addSubview:btnHome];
    
    labelleft = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 100, 30)];
    labelleft.text = @"MELB";
    labelleft.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:labelleft];
    
    labelright = [[UILabel alloc] initWithFrame:CGRectMake(215, 15, 100, 30)];
    labelright.text = @"MELB";
    labelright.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:labelright];
    
    self.title = nil;
    [self loginCompleted];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCompleted) name:@"LoginCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushForm:) name:@"PushForm" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    splitView = [(AppDelegate*)[UIApplication sharedApplication].delegate rootView];
    [splitView setValue:[NSNumber numberWithFloat:270.0] forKey:@"_masterColumnWidth"];
}

- (void) loginCompleted
{
    [self showHome];
    self.txtUsername.title = [DBManager sharedInstant].currentUser.FullName;
    [labelleft removeFromSuperview];
    [labelright removeFromSuperview];
    if([DBManager sharedInstant].dbIndex == 0)
    {
        
        labelleft = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 100, 30)];
        labelleft.text = @"SYD";
        labelleft.textColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:labelleft];
        
        labelright = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 15, 100, 30)];
        labelright.text = @"SYD";
        labelright.textColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:labelright];
    }
    else
    {
        
        labelleft = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 100, 30)];
        labelleft.text = @"MELB";
        labelleft.textColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:labelleft];
        
        labelright = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 15, 100, 30)];
        labelright.text = @"MELB";
        labelright.textColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:labelright];
    }
}

- (void) showHome
{
    UINavigationController *currentNav= [splitView.viewControllers lastObject];
    UIViewController *currentVC = currentNav.viewControllers[0];
    DetailViewController *vc = detailView;
    if(currentVC != vc) {
        UINavigationController *newNavigation = [[UINavigationController alloc] initWithRootViewController:vc];
        NSArray *newVCs = [NSArray arrayWithObjects:self.navigationController,newNavigation,nil];
        splitView.viewControllers = newVCs;
        splitView.delegate = vc;
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void) pushForm:(NSNotification*) notification {
    NSNumber *number = [notification object];
    [self showForm:[number integerValue]];
}

- (void) showForm:(int)index {
    MenuItem *item = [menuItems objectAtIndex:index];
    if(item && [item controller]) {
        [DBManager sharedInstant].synchronized = NO;
        UINavigationController *currentNav= [splitView.viewControllers lastObject];
        UIViewController *currentVC = currentNav.viewControllers[0];
        UIViewController *lastVC = currentNav.viewControllers.lastObject;
        if(currentVC != [item controller]) {
            targetMenuItem = item;
            if([lastVC.title rangeOfString:@"information"].location != NSNotFound)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"All unsaved data will be lost. Are you sure want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alert show];
            }
            else {
                [self loadForm];
            }
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This feature is temporary disable to intergrate with AirPrint" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}


- (void) loadForm
{
    UINavigationController *newNavigation = [[UINavigationController alloc] initWithRootViewController:[targetMenuItem controller]];
    NSArray *newVCs = [NSArray arrayWithObjects:self.navigationController,newNavigation,nil];
    splitView.viewControllers = newVCs;
    splitView.delegate = [targetMenuItem controller];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != [alertView cancelButtonIndex])
    {
        [self loadForm];
    }
}

/*!
 Generate the menu items for POS
 */
- (void) initMenuItems
{
    menuItems = [[NSMutableArray alloc] init];
    AdvanceSearchViewController *advanceSearch = [[AdvanceSearchViewController alloc] initWithNibName:@"AdvanceSearchViewController" bundle:nil];
    MenuItem *searchMenuItem = [[MenuItem alloc] initWithTitle:@"Search" controller:advanceSearch imageName:@"search_icon"];
    
    TransactionsViewController *salesView = [[TransactionsViewController alloc] initWithNibName:@"TransactionsViewController" bundle:nil];
    [salesView setTransactionType:TransactionTypeSale];
    MenuItem *salesMenuItem = [[MenuItem alloc] initWithTitle:@"Sales" controller:salesView imageName:@"sales_icon"];
    
    ContactsViewController *customersView = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
    [customersView setContactType:ContactTypeCustomer];
    MenuItem *customersMenuItem = [[MenuItem alloc] initWithTitle:@"Customers" controller:customersView imageName:@"customers_icon"];
    
    CategoryViewController *productsView = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
    MenuItem *productsMenuItem = [[MenuItem alloc] initWithTitle:@"Produces" controller:productsView imageName:@"products_icon"];
    
    TransactionsViewController *purchasesView = [[TransactionsViewController alloc] initWithNibName:@"TransactionsViewController" bundle:nil];
    [purchasesView setTransactionType:TransactionTypePurchase];
    MenuItem *purchaseMenuItem = [[MenuItem alloc] initWithTitle:@"Purchases" controller:purchasesView imageName:@"purchases_icon"];
    
    ContactsViewController *suppliersView = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
    [suppliersView setContactType:ContactTypeSuppplier];
    MenuItem *suppliersMenuItem = [[MenuItem alloc] initWithTitle:@"Suppliers" controller:suppliersView imageName:@"suppliers_icon"];
    
    PaymentMenuViewController *paymentsView = [[PaymentMenuViewController alloc] initWithNibName:@"PaymentMenuViewController" bundle:nil];
    MenuItem *paymentsMenuItem = [[MenuItem alloc] initWithTitle:@"Payments" controller:paymentsView imageName:@"payments_icon"];
    
    MenuItem *reportsMenuItem = [[MenuItem alloc] initWithTitle:@"Reports" controller:nil imageName:@"reports_icon"];
    
    UsersViewController *usersView = [[UsersViewController alloc] initWithNibName:@"UsersViewController" bundle:nil];
    MenuItem *usersMenuItem = [[MenuItem alloc] initWithTitle:@"Users" controller:usersView imageName:@"users_icon"];
    
    MetaDataViewController *metaDataView = [[MetaDataViewController alloc] initWithNibName:@"MetaDataViewController" bundle:nil];
    MenuItem *metadataMenuItem = [[MenuItem alloc] initWithTitle:@"Metadata" controller:metaDataView imageName:@"metadata_icon"];
    
    [menuItems addObject:searchMenuItem];
    [menuItems addObject:salesMenuItem];
    [menuItems addObject:customersMenuItem];
    [menuItems addObject:productsMenuItem];
    [menuItems addObject:purchaseMenuItem];
    [menuItems addObject:suppliersMenuItem];
    [menuItems addObject:paymentsMenuItem];
    [menuItems addObject:reportsMenuItem];
    [menuItems addObject:usersMenuItem];
    [menuItems addObject:metadataMenuItem];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    [cell setMenuItem:[menuItems objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *item = [menuItems objectAtIndex:indexPath.row];
    if([item controller])
        [self showForm:indexPath.row];
    else
    {
        UIActionSheet *reportList = [[UIActionSheet alloc] initWithTitle:@"Choose an report" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sale Invoices", @"Purchases", nil];
        reportList.tag = 2;
        CGRect rect= [tableView rectForRowAtIndexPath:indexPath];
        if([POSCommon isPortraitMode])
            [reportList showFromRect:rect inView:self.view animated:YES];
        else
            [reportList showFromRect:rect inView:self.view animated:YES];
    }
}

- (IBAction)showSetting:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = @"Choose an action";
    actionSheet.tag = 1;
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:@"Logout"];
    [actionSheet showFromBarButtonItem:self.txtSetting animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [actionSheet cancelButtonIndex]) return;
    if(actionSheet.tag == 1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"kUsername"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"kPassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:loginView animated:NO completion:nil];
    }
    else
    {
        TransactionReportViewController *view  = [[TransactionReportViewController alloc] initWithNibName:@"TransactionReportViewController" bundle:nil];
        if(buttonIndex == 0)
            view.transactionType = TransactionTypeSale;
        else
            view.transactionType = TransactionTypePurchase;
        UINavigationController *newNavigation = [[UINavigationController alloc] initWithRootViewController:view];
        NSArray *newVCs = [NSArray arrayWithObjects:self.navigationController,newNavigation,nil];
        splitView.viewControllers = newVCs;
        splitView.delegate = view;
    }
}
@end
