//
//  QuantitySelectViewController.h
//  pos
//
//  Created by Loc Tran on 2/27/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "POSProduct.h"
#import "POSSaleInvoiceDetail.h"

@protocol SaleInvoiceDetailsInputDelegate <NSObject>
- (void)saleInvoiceDetailsInputSaved: (POSObject*) saleInvoiceDetails;
- (void)saleInvoiceDetailsInputCanceled;
@end

@interface SaleInvoiceDetailsInput : UIViewController<UITextFieldDelegate> {
    id<SaleInvoiceDetailsInputDelegate> _delegate;
    POSObject* invoice;
    POSProduct *_product;
}
@property (strong, nonatomic) IBOutlet UITextField *txtNumber;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UITextField *txtTotalAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblMsg;
@property (assign, nonatomic) TransactionType transactionType;

- (void) setProduct: (POSProduct*) product target:(id) target;
- (void) setSaleInvoiceDetails: (POSObject*) invoices target:(id) target;
@end
