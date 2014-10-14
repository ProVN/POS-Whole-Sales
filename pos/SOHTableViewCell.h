//
//  SOHTableViewCell.h
//  pos
//
//  Created by Loc Tran on 7/17/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSProductHistory.h"
@protocol SOHTableViewCellDelegate
@required
- (void)sohTableViewCellChanged :(POSProductHistory*) history;
- (void)sohTableViewCellRemoved :(POSProductHistory*) history;
@end

@interface SOHTableViewCell : UITableViewCell<UITextFieldDelegate> {
    id<SOHTableViewCellDelegate> _target;
}
@property (strong, nonatomic) IBOutlet UILabel *lastUpdated;
@property (strong, nonatomic) IBOutlet UITextField *currentValue;
- (IBAction)valueChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *productName;
- (void) setProductName:(NSString*) productName withProductId:(NSNumber*) productId lastUpdated:(NSDate*) lastUpdated currentValue:(NSNumber*) currentValue;
- (void) setTarget:(id)target;
- (IBAction)endEditing:(id)sender;
- (IBAction)editingChanged:(id)sender;

@end
