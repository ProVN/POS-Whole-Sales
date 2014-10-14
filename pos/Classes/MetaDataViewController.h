//
//  MetaDataViewController.h
//  pos
//
//  Created by Loc Tran on 2/11/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "POSMetaFormViewController.h"
#import "DBManager.h"
@interface MetaDataViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, POSMetaFormViewControllerDelegate, DBDelegate> {
    NSMutableArray *datasource;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
