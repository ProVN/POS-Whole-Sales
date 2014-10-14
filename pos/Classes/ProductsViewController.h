//
//  ProductsViewController.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "POSCategory.h"
#import "POSProduct.h"
#import "ProductFormViewController.h"
#import "POSMeta.h"

@interface ProductsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ProductFormViewControllerDelegate> {
    NSMutableArray* datasource;
}
@property (strong, nonatomic) POSCategory* category;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UITextField *txtFilter;
@property (assign, nonatomic) NSInteger filterDateIndex;

@end
