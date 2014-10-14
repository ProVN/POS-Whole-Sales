//
//  UpdateSOHViewController.h
//  pos
//
//  Created by Loc Tran on 7/17/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "SOHTableViewCell.h"
#import "DateTimePickerViewController.h"

@interface UpdateSOHViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,  SOHTableViewCellDelegate,DBDelegate, UITextFieldDelegate, DateTimePickerDelegate>
{
    NSDate *sohdate;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;

@end
