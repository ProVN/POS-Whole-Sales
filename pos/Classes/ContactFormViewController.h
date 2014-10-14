//
//  CustomerFormViewController.h
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactInfoViewController.h"
#import "ContactAddtionalInfoViewController.h"
#import "UIViewController+POSViewController.h"

@protocol ContactFormViewControllerDelegate
@required
- (void)contactFormViewControllerCompleted;
@end

@interface ContactFormViewController : UIViewController {
    ContactType contactType;
    ContactInfoViewController *contactInfoView;
    ContactAddtionalInfoViewController *contactAdditionalView;
    id<ContactFormViewControllerDelegate> _target;
}

@property (nonatomic, strong) POSCustomer  *posCustomer;
@property (nonatomic, strong) POSSupplier *posSupplier;

-(void) setContactType:(ContactType) type;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (void) setTarget:(id)target;

@end
