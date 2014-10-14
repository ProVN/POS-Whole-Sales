//
//  DataTableViewController.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "UIViewController+POSViewController.h"
@protocol DataTableViewControllerDelegate <NSObject>

@required
- (void) dataTableViewControllerSelected:(NSIndexPath*) indexPath withTag:(NSInteger) tag;;

@optional
- (void) dataTableViewController;

@end

@interface DataTableViewController : UITableViewController {
    id<DataTableViewControllerDelegate> _target;
        NSMutableArray *dataSource;
    NSInteger _tag;
}
- (void) setDataSource:(NSMutableArray*) ds;
- (void) setTarget:(id)target;
- (void) setTag:(NSInteger) tag
;
@end
