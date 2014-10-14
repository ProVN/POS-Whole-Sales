//
//  TransactionPaymentsViewController.h
//  pos
//
//  Created by Loc Tran on 9/19/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "Define.h"
#import "DataTableViewController.h"
#import "CustomerSelectViewViewController.h"
#import "PaymentFormViewController.h"
#import "POSSaleInvoicePayment.h"
#import "POSPurchasePayment.h"

@interface TransactionPaymentsViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, DBDelegate, DateTimePickerDelegate, DataTableViewControllerDelegate, PaymentInputViewDelegate> {
    TransactionType transactionType;
    NSMutableArray* datasource;
    NSMutableArray* not_filtered_datasource;
    NSDate* searchFromDate;
    NSDate* searchToDate;
}
@property (strong, nonatomic) IBOutlet UITextField *txtDateFrom;
@property (strong, nonatomic) IBOutlet UITextField *txtDateTo;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomer;

-(void) setTransactionType:(TransactionType) type;
@end
