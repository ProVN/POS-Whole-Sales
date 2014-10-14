//
//  UsersViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "UsersViewController.h"
#import "ContactFormViewController.h"
#import "GridTableViewCell.h"
#import "HeaderView.h"
#import "UserCollectionItemView.h"
#import "POSUser.h"

@interface UsersViewController ()

@end

@implementation UsersViewController {
    NSArray *colSpans;
    DBManager *dbManager;
    NSMutableArray *cells;
}
@synthesize needToRefreshData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Users";
        colSpans = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:3],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:1],
                    nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!dbManager)
        dbManager = [DBManager sharedInstant];
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAdd)];
    self.navigationItem.rightBarButtonItem = btnAdd;
    
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refesh)];
    self.navigationItem.leftBarButtonItem = btnRefresh;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerClass:[UserCollectionItemView class] forCellWithReuseIdentifier:@"UserCollectionItemView"];
    cells = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    datasource = [DBCaches sharedInstant].users;
    [self.tableView reloadData];
    [self setLayout];
}

-(void) showAdd
{
    UserFormViewController *form = [[UserFormViewController alloc] initWithNibName:@"UserFormViewController" bundle:nil];
    [form setTarget:self];
    [POSCommon showPopup:form from:self];
}

-(void)showEdit:(POSUser*) user
{
    UserFormViewController *form = [[UserFormViewController alloc] initWithNibName:@"UserFormViewController" bundle:nil];
    form.user = user;
    [form setTarget:self];
    [POSCommon showPopup:form from:self];
}

-(void) refesh
{
    [dbManager requestData:kDBUsers predicate:nil target:self];
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

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section
{
   return [datasource count];
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
    POSUser *user = [datasource objectAtIndex:indexPath.item];
    cell.person = user;
    cell.backgroundColor = [UIColor clearColor];
    [cell setNeedsDisplay];
    return cell;
}

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    POSUser *user = [datasource objectAtIndex:indexPath.item];
    [self showEdit:user];
}



#pragma mark
#pragma DBDelegate
- (void)requestDataCompleted:(NSMutableArray *)results
{
    datasource = [DBCaches sharedInstant].users;
    [self.tableView reloadData];
}

- (void)insertDataCompleted
{
    
}

- (void)requestFailed:(NSError *)message
{
    
}

#pragma mark - 
#pragma mark UserViewFormDelegate
- (void)userFormViewControllerCompleted
{
    datasource = [DBCaches sharedInstant].users;
    [self.tableView reloadData];
}
@end
