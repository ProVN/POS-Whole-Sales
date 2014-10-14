//
//  ProductFormViewController.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailViewController.h"
#import "UIViewController+POSViewController.h"
#import "POSProduct.h"
#import "POSCategory.h"
#import "DBManager.h"
#import "ProductHistoriesTableViewController.h"

@protocol ProductFormViewControllerDelegate
@required
- (void)productFormViewControllerCompleted;
@end

@interface ProductFormViewController : UIViewController<DBDelegate> {
    id<ProductFormViewControllerDelegate> _target;
    ProductDetailViewController* detailView;
    ProductHistoriesTableViewController *historyView;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) POSProduct* product;
@property (strong, nonatomic) POSCategory* category;
- (IBAction)segmentValueChanged:(id)sender;
- (void) setTarget:(id)target;
@end
