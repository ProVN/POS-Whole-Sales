//
//  LessTransportViewController.h
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "POSLessTransport.h"

@protocol LessTransportViewDelegate

- (void)lessTransportViewControllerSaved:(POSLessTransport*) lessTransport;
- (void)lessTransportViewControllerCanceled;
@end

@interface LessTransportViewController : UIViewController<UITextFieldDelegate> {
    id<LessTransportViewDelegate> _delegate;
    POSLessTransport* lessTransport;
}
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UITextField *txtSubTotal;
@property (strong, nonatomic) IBOutlet UITextField *txPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtQuantity;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;
- (IBAction)stepperValueChanged:(id)sender;
- (void) setLessTransport: (POSLessTransport*) obj target:(id) target;
@end
