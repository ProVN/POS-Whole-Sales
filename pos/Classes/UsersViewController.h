//
//  UsersViewController.h
//  pos
//
//  Created by Loc Tran on 2/11/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "DBManager.h"
#import "UserFormViewController.h"

@interface UsersViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, DBDelegate, UserFormViewControllerDelegate> {
    NSMutableArray *datasource;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL needToRefreshData;
@end
