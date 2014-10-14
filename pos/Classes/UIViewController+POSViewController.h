//
//  UIViewController+POSViewController.h
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSCommon.h"

@interface UIViewController (POSViewController) <UISplitViewControllerDelegate>

@property(nonatomic,assign) BOOL isLayout;
@property(nonatomic, strong) UIPopoverController* popover;
-(void)setLayout;
- (UIColor*) mainColor;
@end
