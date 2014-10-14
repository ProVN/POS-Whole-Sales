//
//  TableViewController.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController {
    NSMutableArray *dataSource;
}

- (void) setDataSource:(NSMutableArray*) ds;
@property(nonatomic,assign) UITextField *textField;
@end
