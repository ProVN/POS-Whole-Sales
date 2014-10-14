//
//  ProductDetailViewController.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSProduct.h"
#import "UIViewController+POSViewController.h"
#import "DataTableViewController.h"

@interface ProductDetailViewController : UIViewController<UITextFieldDelegate, DataTableViewControllerDelegate> {
    POSProduct *_product;
}
@property (strong, nonatomic) IBOutlet UITextField *subProductOf;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtPackingType;
@property (strong, nonatomic) IBOutlet UITextField *txtSize;
@property (strong, nonatomic) IBOutlet UITextField *txtOtherSize;
@property (strong, nonatomic) IBOutlet UITextField *txtLevies;
@property (strong, nonatomic) IBOutlet UISegmentedControl *txtStatus;

- (void) setData: (POSProduct*) product;
- (POSProduct*) getData;
- (BOOL) isValidData;
@end
