//
//  SearchResultViewController.h
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(assign, nonatomic) BOOL isSales;
@property(assign, nonatomic) BOOL isPurchases;
@property(assign, nonatomic) BOOL isPayment;
@property(strong, nonatomic) NSString* contactName;
@property(assign, nonatomic) BOOL isAmount;
@property(assign, nonatomic) NSInteger amountType;
@property(strong, nonatomic) NSNumber* amountValue;
@property(strong, nonatomic) NSDate* fromDate;
@property(strong, nonatomic) NSDate* toDate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
