//
//  GridTableViewCell.m
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "GridTableViewCell.h"

@implementation GridTableViewCell {
   
}
@synthesize values,colSpans,isHeader, colTypes;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.isEnable = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}


- (void)drawCell:(CGFloat) maxWith {
    int numberOfCols = self.values.count;
    CGFloat avgWith = maxWith/numberOfCols;
    if(colSpans) {
        int numberOfSpans = 0;
        for(NSNumber *number in colSpans) {
            numberOfSpans += [number intValue];
        }
        maxWith = maxWith - (colSpans.count*10);
        avgWith = maxWith/numberOfSpans;
    }
    
    CGFloat startX = 0;
    for (int i = 0; i <= numberOfCols-1; i++) {
        NSString *value;
        if(isHeader)
            value = [self.values objectAtIndex:i];
        else
            value = [self getStringFromObject:i];
        CGFloat width = avgWith;
        if(colSpans){
            NSNumber *spans = colSpans[i];
            width = avgWith * [spans intValue];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(startX, 0, width, self.frame.size.height)];
        [label setFont:[UIFont fontWithName:@"Arial" size:14]];
        [label setAdjustsFontSizeToFitWidth:YES];
        
        kGridCellValueType cellType = [(NSNumber*)colTypes[i] integerValue];
        if(cellType == GridCellValueName || cellType == GridCellValueTypeDate)
            label.numberOfLines = 2;
        else
            label.numberOfLines = 1;
        if(value)
            label.text = value;
        else
            label.text = @"";
        [label setTextAlignment:[self getTextAlignmentOfIndex:i]];
        if(i == 0)
        {
            CALayer *leftBorder = [CALayer layer];
            leftBorder.frame = CGRectMake(startX, 0, 0.5f, self.frame.size.height);
            leftBorder.backgroundColor = [UIColor grayColor].CGColor;
            [self.layer addSublayer:leftBorder];
        }
        CALayer *rightBorder = [CALayer layer];
        startX = startX + width;
        rightBorder.frame = CGRectMake(startX + 5, 0, 0.5f, self.frame.size.height);
        rightBorder.backgroundColor = [UIColor grayColor].CGColor;
        [self.contentView.layer addSublayer:rightBorder];
        label.numberOfLines = 2;
        [self.contentView addSubview:label];
        startX += 10;
        if(isHeader) {
            label.textColor = [UIColor whiteColor];
        }
    }
    if(isHeader) {
        [self setBackgroundColor:[UIColor colorWithRed:0.4 green:0.6 blue:0.25 alpha:1]];
    }
    if(!self.isEnable)
    {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
}

-(NSString*) getStringFromObject:(int)index;
{
    kGridCellValueType cellType = [(NSNumber*)colTypes[index] integerValue];
    NSString* value;
    id object = values[index];
    if(object == nil) return  nil;
    if(cellType == GridCellValueTypeDate)
    {
        NSDate* date = (NSDate*) object;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"dd/MM/yyyy\nHH:mm"];
        value = [dateFormater stringFromDate:date];
    }
    else if(cellType == GridCellValueTypeDateInline)
    {
        NSDate* date = (NSDate*) object;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"dd/MM/yyyy - HH:mm"];
        value = [dateFormater stringFromDate:date];
    }
    else if(cellType == GridCellValueMoney)
    {
        NSNumber *number = (NSNumber*) object;
        if([(NSNumber*)colTypes[index] intValue] == GridCellValueMoney)
        {
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            [fmt setCurrencySymbol:@"$"];
            [fmt setNumberStyle:NSNumberFormatterCurrencyStyle];
            value = [fmt stringFromNumber:number];
        }
        else
            value = [number stringValue];
    }
    else if(cellType == GridCellValueBoolean)
    {
        if(object)
            value = @"Yes";
        else
            value = @"No";
    }
    else if(cellType == GridCellValueId || cellType == GridCellValueName)
    {
        value = object;
    }
    else if(cellType == GridCellValueNumber)
    {
        NSNumber *number = (NSNumber*) object;
        value = [number stringValue];
    }
    else
    {
         value = @"object";
    }
    return value;
}

-(NSTextAlignment) getTextAlignmentOfIndex:(int) index;
{
    kGridCellValueType cellType = [(NSNumber*)colTypes[index] integerValue];
    switch (cellType) {
        case GridCellValueBoolean:
        case GridCellValueTypeDate:
        case GridCellValueTypeDateInline:
        case GridCellValueId:
            return NSTextAlignmentCenter;
        case GridCellValueNumber:
        case GridCellValueMoney:
            return NSTextAlignmentRight;
        default:
            return NSTextAlignmentLeft;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
