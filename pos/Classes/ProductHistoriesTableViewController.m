//
//  ProductHistoriesTableViewController.m
//  pos
//
//  Created by Loc Tran on 9/1/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ProductHistoriesTableViewController.h"
#import "GridTableViewCell.h"
#import "POSProductHistory.h"
#import "HeaderView.h"

@interface ProductHistoriesTableViewController ()

@end

@implementation ProductHistoriesTableViewController {
    NSMutableArray *datasource;
    NSArray *colSpans;
    NSArray *colTypes;

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    colSpans = [[NSArray alloc] initWithObjects:
                [NSNumber numberWithInt:2],
                [NSNumber numberWithInt:1],
                nil];
    colTypes = [[NSArray alloc] initWithObjects:
                [NSNumber numberWithInt:GridCellValueTypeDateInline],
                [NSNumber numberWithInt:GridCellValueMoney],
                nil];
    
    CGRect frame = self.view.frame;
    frame.origin.y += 20;
    frame.origin.x += 20;
    frame.size.width = 500;
    self.view.frame = frame;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
    NSMutableArray *histories = [DBCaches sharedInstant].productHistories;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ProductID=%@",self.productId];
    datasource = [[histories filteredArrayUsingPredicate:predicate] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridTableViewCell *cell = [[GridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cells"];
    POSProductHistory *history = [datasource objectAtIndex:indexPath.row];
    NSArray *values = [[NSArray alloc] initWithObjects:history.AddedTime, history.StockOnHand , nil];
    cell.values = values;
    cell.colSpans = colSpans;
    cell.colTypes = colTypes;
    [cell drawCell:self.view.frame.size.width + 4];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    NSArray *values = [[NSArray alloc] initWithObjects:
                  @"Time",
                  @"StockOnHand",
                  nil];
    header.values = values;
    header.colSpans = colSpans;
    [header drawCell:self.view.frame.size.width];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
