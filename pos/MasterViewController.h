//
//  MasterViewController.h
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController<UISplitViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
    NSMutableArray* menuItems;
}
+(MasterViewController*) masterView;

@property (strong, nonatomic) UIViewController *rightViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *txtUsername;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *txtSetting;
- (IBAction)showSetting:(id)sender;

@property (strong, nonatomic) UIPopoverController *popover;
@end
