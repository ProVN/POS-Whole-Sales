//
//  SOHTableViewCell.m
//  pos
//
//  Created by Loc Tran on 7/17/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "SOHTableViewCell.h"
#import "POSCommon.h"

@implementation SOHTableViewCell {
    NSNumber* _productId;
    NSNumber* _value;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProductName:(NSString *)productName withProductId:(NSNumber *)productId lastUpdated:(NSDate *)lastUpdated currentValue:(NSNumber *)currentValue
{
    self.currentValue.delegate = self;
    _productId = productId;
    self.productName.text = productName;
    if(lastUpdated)
        self.lastUpdated.text = [POSCommon formatDateToString:lastUpdated];
    else
        self.lastUpdated.text = @"Not yet updated";
    self.currentValue.placeholder = [NSString stringWithFormat:@"%d", currentValue.intValue];
    _value = currentValue;
}

- (IBAction)valueChanged:(id)sender {
    
}

- (void)setTarget:(id)target
{
    _target = target;
}

- (IBAction)endEditing:(id)sender {
    if([self.currentValue.text intValue] == [_value intValue]) return;
    POSProductHistory* history = [[POSProductHistory alloc] init];
    history.ProductID = _productId;
    history.AddedTime = [NSDate date];
    history.StockOnHand = [NSNumber numberWithInt:[self.currentValue.text intValue]];
    [_target sohTableViewCellChanged:history];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSRange textFieldRange = NSMakeRange(0, [textField.text length]);
    if (NSEqualRanges(range, textFieldRange) && [string length] == 0) {
        POSProductHistory* history = [[POSProductHistory alloc] init];
        history.ProductID = _productId;
        history.AddedTime = [NSDate date];
        history.StockOnHand = [NSNumber numberWithInt:0];
        [_target sohTableViewCellRemoved:history];
    }
    return YES;
}

- (IBAction)editingChanged:(id)sender{
    }
@end
