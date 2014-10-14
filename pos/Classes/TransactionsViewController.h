//
//  SalesViewController.h
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "DBManager.h"
#import "DateTimePickerViewController.h"
#import "DataTableViewController.h"

@interface TransactionsViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, DBDelegate, DateTimePickerDelegate, DataTableViewControllerDelegate>{
    TransactionType transactionType;
    NSMutableArray* datasource;
    NSMutableArray* not_filtered_datasource;
    NSDate* searchFromDate;
    NSDate* searchToDate;
}

@property (strong, nonatomic) IBOutlet UITextField *txtDateFrom;
@property (strong, nonatomic) IBOutlet UITextField *txtDateTo;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property (strong, nonatomic) IBOutlet UITextField *txtSortBy;
@property (strong, nonatomic) IBOutlet UITextField *txtSortType;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(void) setTransactionType:(TransactionType) type;
@end
