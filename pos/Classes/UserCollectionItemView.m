//
//  UserCollectionViewCell.m
//  pos
//
//  Created by Loc Tran on 2/11/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "UserCollectionItemView.h"
#import "POSCommon.h"

@implementation UserCollectionItemView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    NSString* displayname = @"";
    NSString* balance = nil;
    BOOL highlight = false;
    BOOL enable = true;
    CGRect frame = self.contentView.frame;
    if([self.person isKindOfClass:[POSCustomer class]]) {
        displayname = [(POSCustomer*)self.person CompanyName];
        balance = [POSCommon formatCurrencyFromNumber: [(POSCustomer*)self.person CurrentBalance]];
        frame.size.height -= 20;
        NSString *memberCode = [(POSCustomer*)self.person MemberCode];
        if(memberCode && memberCode.length > 0) {
            highlight = true;
        }
        enable = [(POSCustomer*)self.person Status];
    }
    else if([self.person isKindOfClass:[POSSupplier class]]) {
        displayname = [(POSSupplier*)self.person CompanyName];
        balance = [POSCommon formatCurrencyFromNumber: [(POSSupplier*)self.person CurrentBalance]];
        frame.size.height -= 20;
        NSString *memberCode = [(POSSupplier*)self.person MemberCode];
        if(memberCode && memberCode.length > 0) {
            highlight = true;
        }
        enable = [(POSCustomer*)self.person Status];
    }
    else {
        displayname = [(POSUser*)self.person FullName];
        enable = [(POSUser*)self.person Status];
    }

    UIColor *mainBorderColor = [UIColor colorWithRed:0.3 green:0.6 blue:0.2 alpha:1];
    UIColor *mainBGColor = [UIColor colorWithRed:0.3 green:0.6 blue:0.2 alpha:0.3];
    if(!enable)
    {
        mainBGColor = [UIColor lightGrayColor];
    }
    else if(highlight){
        mainBGColor = [UIColor colorWithRed:0.0 green:0.5 blue:1 alpha:0.3];
        mainBorderColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.tag = 1001;
    view.layer.borderWidth = 0.5;
    [view.layer setBorderColor:mainBorderColor.CGColor];
    view.layer.cornerRadius = 5;
    [view setBackgroundColor:mainBGColor];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, rect.size.width)];
    [avatarView setBackgroundColor:[UIColor clearColor]];
    [avatarView setImage:[UIImage imageNamed:@"users_icon"]];
    [view addSubview:avatarView];
    
    UILabel *displayName = [[UILabel alloc] initWithFrame:CGRectMake(3, frame.size.width - 10, rect.size.width - 6, 50)];
    displayName.numberOfLines = 2;
    displayName.text = displayname;
    [displayName setFont:[UIFont fontWithName:@"Arial" size:12]];
    displayName.textAlignment = NSTextAlignmentCenter;
    [displayName setTextColor:mainBorderColor];
    [view addSubview:displayName];
    
    UIView *preView = [self.contentView viewWithTag:1001];
    [preView removeFromSuperview];
    [self.contentView addSubview:view];
    
    if(balance)
    {
        CGRect rect = CGRectMake(0, view.frame.size.height + 3, view.frame.size.width, 20);
        UIView* balanceView = [[UIView alloc] initWithFrame:rect];
        balanceView.layer.borderWidth = 0.5;
        [balanceView.layer setBorderColor:mainBorderColor.CGColor];
        balanceView.layer.cornerRadius = 5;
        balanceView.tag = 1002;
        
        UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, rect.size.width - 6, 20)];
        [balanceLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        balanceLabel.text = balance;
        [balanceLabel setTextAlignment:NSTextAlignmentCenter];
        [balanceLabel setTextColor:mainBorderColor];
        [balanceView addSubview:balanceLabel];
        preView = [self.contentView viewWithTag:1002];
        [preView removeFromSuperview];
        [self.contentView addSubview:balanceView];
    }
}

@end
