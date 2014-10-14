//
//  DateTimePickerViewController.h
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"

@protocol DateTimePickerDelegate <NSObject>

@required
- (void) dateTimePickerSaved:(NSDate*) date tag:(int)tag;
@end
@interface DateTimePickerViewController : UIViewController {
    id<DateTimePickerDelegate> _delegate;
    UITextField* textfield;
    int _tag;
}
@property(nonatomic, assign) NSDate *datetime;
@property (strong, nonatomic) IBOutlet UIDatePicker *datetimePicker;

- (void) setDelegate:(id) target;
- (void) setTag:(int)tag;
- (void) displayInTextField: (UITextField*) txtfield;
@end
