//
//  ContactsViewController.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "DBManager.h"
#import "Define.h"
#import "ContactFormViewController.h"
#import "DataTableViewController.h"

@interface ContactsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, DBDelegate, ContactFormViewControllerDelegate, DataTableViewControllerDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate> {
    ContactType contactType;
    NSMutableArray *datasource;
}
-(void) setContactType:(ContactType) type;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UITextField *txtSortBy;
@property (strong, nonatomic) IBOutlet UITextField *txtSortType;

@end
