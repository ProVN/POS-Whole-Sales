//
//  HeaderView.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property(nonatomic,assign) NSArray* values;
@property(nonatomic,assign) NSArray* colSpans;
@property(nonatomic, assign) BOOL isHeader;

-(void) drawCell:(CGFloat) maxWith;


@end
