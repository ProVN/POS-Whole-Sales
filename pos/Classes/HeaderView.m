//
//  HeaderView.m
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView
@synthesize values,colSpans,isHeader;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawCell:(CGFloat) maxWith {
    NSInteger numberOfCols = self.values.count;
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
        NSString *value = values[i];
        CGFloat width = avgWith;
        if(colSpans){
            NSNumber *spans = colSpans[i];
            width = avgWith * [spans intValue];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(startX, 0, width, self.frame.size.height)];
        [label setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12]];
        [label setAdjustsFontSizeToFitWidth:YES];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 2;
        label.text = value;
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
        [self setBackgroundColor:[UIColor colorWithRed:0.4 green:0.6 blue:0.25 alpha:1]];
        startX += width + 10;
    }
    if(isHeader) {
        [self setBackgroundColor:[UIColor greenColor]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
