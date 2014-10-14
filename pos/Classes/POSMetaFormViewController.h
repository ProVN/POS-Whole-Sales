//
//  POSMetaFormViewController.h
//  pos
//
//  Created by Loc Tran on 7/14/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSMetadata.h"
#import "DBManager.h"
#import "UIViewController+POSViewController.h"

@protocol POSMetaFormViewControllerDelegate
@required
- (void)POSMetaFormViewControllerCompleted;
@end

@interface POSMetaFormViewController : UIViewController<DBDelegate>{
    id<POSMetaFormViewControllerDelegate> _target;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *txtType;
@property (weak, nonatomic) IBOutlet UITextField *txtValue;
@property (strong, nonatomic) POSMetadata *metaData;
-(void) setTarget:(id)target;
@end
