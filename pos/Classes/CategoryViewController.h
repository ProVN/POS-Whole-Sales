//
//  CategoryViewController.h
//  pos
//
//  Created by Loc Tran on 7/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "DBManager.h"
#import "CategoryAddViewController.h"
#import "POSMeta.h"
#import "DataTableViewController.h"

@interface CategoryViewController : UIViewController<DBDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, CategoryAddViewControllerDelegate, DataTableViewControllerDelegate> {
    NSMutableArray *datasource;
    NSInteger filterDateIndex;
}
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *txtFilter;
- (IBAction)showSOH:(id)sender;
@end
