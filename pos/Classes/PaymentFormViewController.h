//
//  PaymentFormViewController.h
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "Define.h"

@protocol PaymentInputViewDelegate <NSObject>
- (void)paymentInputSaved: (id) paymentItem;
- (void)paymentInputCanceled;
@end

@interface PaymentFormViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
    id<PaymentInputViewDelegate> _delegate;
    TransactionType transactionType;
}

//IBOutLet
@property (strong, nonatomic) IBOutlet UIDatePicker *txtDate;
@property (strong, nonatomic) IBOutlet UISegmentedControl *txtPaymentType;
@property (strong, nonatomic) IBOutlet UITextField *txtDescription;
@property (strong, nonatomic) IBOutlet UITextField *txtAmount;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSNumber* balance;
//User defined function
-(void) setPaymentItem:(id) item transactionType:(TransactionType) type target:(id)target;
@end
