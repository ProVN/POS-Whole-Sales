//
//  MetaDataViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "MetaDataViewController.h"
#import "ContactFormViewController.h"
#import "GridTableViewCell.h"
#import "HeaderView.h"
#import "POSMetaData.h"

@interface MetaDataViewController ()

@end

@implementation MetaDataViewController {
    NSArray *colSpans;
    NSArray *colTypes;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"MetaData";
        colSpans = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:2],
                    nil];
        colTypes = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:GridCellValueId],
                    [NSNumber numberWithInt:GridCellValueId],
                    nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAdd)];
    self.navigationItem.rightBarButtonItem = btnAdd;
    
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reFresh)];
    self.navigationItem.leftBarButtonItem = btnRefresh;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLayout];
    [self loadData];
}

- (void) loadData
{
    datasource = [DBCaches sharedInstant].metaDatas;
    
    NSSortDescriptor* sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"Group" ascending:YES];
    NSSortDescriptor* sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"Group" ascending:YES];
    NSArray *sortDescs = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    datasource = [[datasource sortedArrayUsingDescriptors:sortDescs] mutableCopy];
    [self.tableView reloadData];
}

-(void) showAdd
{
    POSMetaFormViewController *form = [[POSMetaFormViewController alloc] initWithNibName:@"POSMetaFormViewController" bundle:nil];
    [form setTarget:self];
    [POSCommon showPopup:form from:self];
}

-(void) reFresh
{
    [[DBManager sharedInstant] requestData:kDbMetadatas predicate:nil target:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    NSArray *values = [[NSArray alloc] initWithObjects:
                       @"Group",
                       @"Values",
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
     POSMetadata *metaData = [datasource objectAtIndex:indexPath.row];
    [[DBManager sharedInstant] deleteData:kDbMetadatas item:metaData target:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridTableViewCell *cell = [[GridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    POSMetadata *metaData = [datasource objectAtIndex:indexPath.row];
    NSArray *values = [[NSArray alloc] initWithObjects:
                       metaData.Group,
                       metaData.Value,
                       nil];
    cell.values = values;
    cell.colSpans = colSpans;
    cell.colTypes = colTypes;
    [cell drawCell:self.view.frame.size.width - 36];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    POSMetadata *metaData = [datasource objectAtIndex:indexPath.row];
    POSMetaFormViewController *form = [[POSMetaFormViewController alloc] initWithNibName:@"POSMetaFormViewController" bundle:nil];
    [form setTarget:self];
    form.metaData = metaData;
    [POSCommon showPopup:form from:self];
}

-(void)POSMetaFormViewControllerCompleted
{
    [self loadData];
}

#pragma mark - 
#pragma mark DBDelegate
- (void)requestDataCompleted:(NSMutableArray *)results
{
    [self loadData];
}

- (void)deleteDataCompleted:(id)objectId
{
    [self loadData];
}

- (void)requestFailed:(NSError *)message
{
    
}
@end
