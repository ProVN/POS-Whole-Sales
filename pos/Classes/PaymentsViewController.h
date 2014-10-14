//
//  PaymentsViewController.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "Define.h"
#import "DataTableViewController.h"
#import "CustomerSelectViewViewController.h"

@interface PaymentsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DataTableViewControllerDelegate, DateTimePickerDelegate, ContactSelectDelegate> {
    ContactType contactType;
    NSMutableArray* datasource;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property (assign, nonatomic) TransactionType transactionType;
@property (strong, nonatomic) IBOutlet UITextField *txtDateFrom;
@property (strong, nonatomic) IBOutlet UITextField *txtDateTo;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomer;

- (void)setContactType:(ContactType) type;
@end
