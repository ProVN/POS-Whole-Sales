//
//  PaymentMenuViewController.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "TransactionPaymentsViewController.h"
#import "Define.h"

@interface PaymentMenuViewController : UIViewController {
    TransactionPaymentsViewController *customerView;
    TransactionPaymentsViewController *supplierView;
}
- (IBAction)btnCustomerTouchDown:(id)sender;
- (IBAction)btnSupplierTouchDown:(id)sender;

@end
