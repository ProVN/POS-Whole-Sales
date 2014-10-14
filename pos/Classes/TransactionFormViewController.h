//
//  SalesFormViewController.h
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "I3DragBetweenHelper.h"
#import "SaleInvoiceDetailsInput.h"
#import "LessTransportViewController.h"
#import "PaymentFormViewController.h"
#import "POSCommon.h"
#import "DateTimePickerViewController.h"


typedef enum
{
    TransactionFormStepTransaction,
    TransactionFormStepTransactionDetail,
    TransactionFormStepTransactionTransport,
    TransactionFormStepTransactionPayment,
    TransactionFormStepTransactionCompleted,
}TransactionFormStep;

@interface TransactionFormViewController : UIViewController<UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, I3DragBetweenDelegate, SaleInvoiceDetailsInputDelegate, LessTransportViewDelegate, PaymentInputViewDelegate, ContactSelectDelegate, DBDelegate, UIAlertViewDelegate, DateTimePickerDelegate> {
    TransactionType transactionType;
    
    //Datasource
    NSMutableArray *itemSource;
    NSMutableArray *lessTransportSource;
    NSMutableArray *paymentSource;
    NSMutableArray *productSource;
    NSMutableArray *subProductSource;
    
    //RemovedArray
    NSMutableArray *deletedLessTransports;
    NSMutableArray *deletedItems;
    NSMutableArray *deletedPayments;
    
    //Cells reusable for fix iOS7 problem
    NSMutableArray *paymentCells;
    NSMutableArray *productCells;
    NSMutableArray *subProductCells;
    
    //Collection View
    UICollectionView *paymentCollection;
    UICollectionView *productCollection;
    UICollectionView *subproductCollection;
    
    //Caches variable
    NSInteger fromIndex;
    NSInteger toIndex;
    NSInteger editingIndex;
    
    //Object properties;
    NSDate *issuedDate;
    POSObject* contact;
    POSObject* transaction;
    TransactionFormStep step;
}
//IBOutlet Properties
@property (strong, nonatomic) IBOutlet UITextField *txtCustomer;
@property (strong, nonatomic) IBOutlet UIButton *btnAddTransportPayment;
@property (strong, nonatomic) IBOutlet UIView *holderView;

- (IBAction)switchChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblPayment;
@property (strong, nonatomic) IBOutlet UILabel *lblBalance;
@property (strong, nonatomic) IBOutlet UITextField *txtDiscount;
@property (strong, nonatomic) IBOutlet UITextField *txtIssuedDate;
@property (strong, nonatomic) IBOutlet UISwitch *txtCreditService;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UISwitch *txtGst;
@property (strong, nonatomic) IBOutlet UILabel *txtGstValue;
@property (strong, nonatomic) IBOutlet UISwitch *printInvoice;

//Items View
@property (strong, nonatomic) IBOutlet UIView *itemView;
@property (strong, nonatomic) IBOutlet UIView *itemCartView;
@property (strong, nonatomic) IBOutlet UIView *productView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tabProducts;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tabItemPayMent;

//Payment View
@property (strong, nonatomic) IBOutlet UIView *paymentView;
@property (strong, nonatomic) IBOutlet UITableView *paymentCartView;

//IBAction
- (IBAction)tabItemPaymentChanged:(id)sender;
- (IBAction)tabProductsValueChanged:(id)sender;
- (IBAction)btnAddTransportPaymentTouched:(id)sender;

//User define Properties
@property (strong, nonatomic) I3DragBetweenHelper *helper;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionID;

//User define Functions
- (void)setTransaction:(POSObject*) transaction type:(TransactionType) type;
@end
