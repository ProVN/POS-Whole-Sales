//
//  UpdateSOHViewController.m
//  pos
//
//  Created by Loc Tran on 7/17/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "UpdateSOHViewController.h"
#import "POSCategory.h"
#import "POSProduct.h"
#import "POSProductHistory.h"
#import "POSCommon.h"

@interface UpdateSOHViewController ()

@end

@implementation UpdateSOHViewController {
    NSMutableArray *categories;
    NSMutableArray* products;
    NSMutableArray* histories;
    NSMutableArray* updateQueue;
    NSInteger insertIndex;
    UIAlertView *alert;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Updating Stock On Hand";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    categories = [DBCaches sharedInstant].categories;
    products = [DBCaches sharedInstant].products;
    histories = [DBCaches sharedInstant].productHistories;
    
    UINib* nib = [UINib nibWithNibName:@"SOHTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cells"];
    updateQueue = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = btnDone;
    sohdate = [NSDate date];
    self.txtDate.text = [POSCommon formatDateToString:sohdate];
    self.txtDate.delegate = self;
}

- (void) done
{
    [self.view endEditing:YES];
    insertIndex = 0;
    [self insertItemWithIndex:insertIndex];
}

- (void) insertItemWithIndex:(NSInteger) index
{
    if(index < updateQueue.count) {
        NSString *msg = [NSString stringWithFormat:@"Saving data %d/%d",index+1, updateQueue.count];
        if(alert == nil) {
            alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            [alert show];
        }
        else {
            [alert setTitle:msg];
        }
        POSProductHistory* history = [updateQueue objectAtIndex:index];
        [[DBManager sharedInstant] saveData:kDbProductHistories item:history title:nil message:nil target:self];
    }
    else {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        alert = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return categories.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [(POSCategory*)[categories objectAtIndex:section] Name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    POSCategory* category = [categories objectAtIndex:section];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"CategoryId=%@",category.Id];
    NSMutableArray* result = [[products filteredArrayUsingPredicate:predicate] mutableCopy];
    return result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POSCategory* category = [categories objectAtIndex:indexPath.section];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"CategoryId=%@",category.Id];
    NSMutableArray* result = [[products filteredArrayUsingPredicate:predicate] mutableCopy];
    POSProduct* product = [result objectAtIndex:indexPath.row];
    NSPredicate* predicate2 = [NSPredicate predicateWithFormat:@"ProductID=%@",product.Id];
    NSMutableArray* historiesList = [[histories filteredArrayUsingPredicate:predicate2] mutableCopy];
    SOHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cells" forIndexPath:indexPath];
    [cell setTarget:self];
    if(historiesList.count) {
        POSProductHistory * history = [historiesList lastObject];
        [cell setProductName:product.Name withProductId: product.Id lastUpdated:history.AddedTime currentValue:history.StockOnHand];
    }
    else {
        [cell setProductName:product.Name withProductId: product.Id lastUpdated:nil currentValue:nil];
    }
    return cell;
}

#pragma mark -
#pragma mark SOHViewControllerDelegate
- (void)sohTableViewCellChanged:(POSProductHistory *)history
{
    if(updateQueue.count) {
        for (int i = 0; i < updateQueue.count; i++) {
            POSProductHistory *_history = [updateQueue objectAtIndex:i];
            if([_history.ProductID intValue] == [history.ProductID intValue]) {
                _history.StockOnHand = history.StockOnHand;
                return;
            }
        }
    }
    history.AddedTime = sohdate;
    [updateQueue addObject:history];
}

- (void)sohTableViewCellRemoved:(POSProductHistory *)history
{
    if(updateQueue.count) {
        POSProductHistory *removeItem = nil;
        for (int i = 0; i < updateQueue.count; i++) {
            POSProductHistory *_history = [updateQueue objectAtIndex:i];
            if([_history.ProductID intValue] == [history.ProductID intValue]) {
                removeItem = _history;
                break;
            }
        }
        [updateQueue removeObject:removeItem];
    }
}

#pragma mark -
#pragma mark DBDelegate
- (void)saveDataCompleted:(POSObject *)insertedItem
{
    insertIndex++;
    [self insertItemWithIndex:insertIndex];
}

- (void)requestFailed:(NSError *)message
{
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [POSCommon showDateTimePicker:self selectedDate:sohdate target:self];
    return NO;
}

- (void)dateTimePickerSaved:(NSDate *)date tag:(int)tag
{
    self.txtDate.text = [POSCommon formatDateToString:date];
    sohdate = date;
}
@end
