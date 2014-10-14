//
//  ProductHistoriesTableViewController.h
//  pos
//
//  Created by Loc Tran on 9/1/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "POSCommon.h"
#import "DBManager.h"

@interface ProductHistoriesTableViewController : UITableViewController

@property (nonatomic, strong) NSNumber* productId;

@end
