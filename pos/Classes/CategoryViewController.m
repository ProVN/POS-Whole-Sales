//
//  CategoryViewController.m
//  pos
//
//  Created by Loc Tran on 7/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "CategoryViewController.h"
#import "GridTableViewCell.h"
#import "POSCategory.h"
#import "DBCaches.h"
#import "HeaderView.h"
#import "ProductsViewController.h"
#import "UpdateSOHViewController.h"

@interface CategoryViewController () {
    NSString *searchText;
}

@end

@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Produces";
        searchText = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.txtFilter.text = [[POSMeta sharedInstance].produceMonthStr lastObject];
    filterDateIndex = [[POSMeta sharedInstance].produceMonth count] -1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
    self.txtSearch.delegate = self;
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAdd)];
    self.navigationItem.rightBarButtonItem = btnAdd;

    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.leftBarButtonItem = btnRefresh;
    
    UIBarButtonItem *btnStockOnHand = [[UIBarButtonItem alloc] initWithTitle:@"Update Stock On Hand" style:UIBarButtonItemStylePlain target:self action:@selector(showSOH:)];
    
    self.toolbarItems = [[NSArray alloc] initWithObjects:btnStockOnHand , nil];
    self.txtFilter.delegate = self;
    
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma User Defined
-(void) refresh
{
    [[DBManager sharedInstant] requestData:kDbCategories predicate:nil target:self];
}

- (void) showAdd
{
    CategoryAddViewController *vc = [[CategoryAddViewController alloc] initWithNibName:@"CategoryAddViewController" bundle:nil];
    [vc setTarget:self];
    [POSCommon showPopup:vc from:self];
}

- (void) reloadData
{
    datasource = [[DBCaches sharedInstant] categories];
    if(searchText.length > 0){
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Name BEGINSWITH[c] %@",searchText];
        datasource = [[datasource filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    [self.tableView reloadData];

}
#pragma mark -
#pragma mark DBDelegate

- (void)deleteDataCompleted:(id)objectId
{
    [self reloadData];
}

-(void)requestDataCompleted:(NSMutableArray *)results
{
    [self reloadData];
}

- (void) requestFailed:(NSError *)message
{
    
}

#pragma mark -
#pragma mark CategoryAddViewControllerDelegate
- (void)categoryAddViewControllerCompleted
{
    [self reloadData];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtFilter)
    {
        NSMutableArray *ds = [POSMeta sharedInstance].produceMonthStr;
        [POSCommon showChooserWithData:ds from:self withTag:1];
        return NO;
    }
    return YES;
}


- (void)dataTableViewControllerSelected:(NSIndexPath *)indexPath withTag:(NSInteger)tag
{
    NSMutableArray *ds = [POSMeta sharedInstance].produceMonthStr;
    filterDateIndex = indexPath.row;
    self.txtFilter.text = [ds objectAtIndex:filterDateIndex];
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

#pragma mark -
#pragma mark UITableViewDelegate
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
    POSCategory* category = [datasource objectAtIndex:indexPath.row];
    [[DBManager sharedInstant] deleteData:kDbCategories item:category target:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    NSArray *values = [[NSArray alloc] initWithObjects:
                  @"",
                  @"Show sub produces",
                  nil];
    header.values = values;
    NSArray* colSpans = [[NSArray alloc] initWithObjects:
                         [NSNumber numberWithInt:5],
                         [NSNumber numberWithInt:1],
                         nil];
    header.colSpans = colSpans;
    [header drawCell:self.view.frame.size.width - 36];
    return header;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cells"];
    POSCategory* category = [datasource objectAtIndex:indexPath.row];
    cell.textLabel.text = category.Name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryAddViewController *vc = [[CategoryAddViewController alloc] initWithNibName:@"CategoryAddViewController" bundle:nil];
    vc.category = [datasource objectAtIndex:indexPath.row];
    [vc setTarget:self];
    [POSCommon showPopup:vc from:self];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ProductsViewController *vc = [[ProductsViewController alloc] initWithNibName:@"ProductsViewController" bundle:nil];
    vc.filterDateIndex = filterDateIndex;
    vc.category = [datasource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)showSOH:(id)sender {
    UpdateSOHViewController *form = [[UpdateSOHViewController alloc] initWithNibName:@"UpdateSOHViewController" bundle:nil];
    [self.navigationController pushViewController:form animated:YES];
}
@end
