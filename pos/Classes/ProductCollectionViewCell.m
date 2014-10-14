//
//  ProductCollectionViewCell.m
//  pos
//
//  Created by Loc Tran on 2/11/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ProductCollectionViewCell.h"
#import "POSCommon.h"

@implementation ProductCollectionViewCell {
    NSString *imageName;
}
@synthesize displayname;

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
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.layer.borderWidth = 0.5;
    [view.layer setBorderColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.2 alpha:1].CGColor];
    view.layer.cornerRadius = 5;
    [view setBackgroundColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.2 alpha:0.3]];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, rect.size.width - 10, rect.size.width - 10)];
    [avatarView setBackgroundColor:[UIColor clearColor]];
    [avatarView setImage:[UIImage imageNamed:imageName]];
    [view addSubview:avatarView];
    
    UILabel *displayName = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.size.width - 15, rect.size.width, 60)];
    displayName.text = displayname;
    displayName.numberOfLines = 2;
    [displayName setFont:[UIFont fontWithName:@"Arial" size:12]];
    displayName.textAlignment = NSTextAlignmentCenter;
    [displayName setTextColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.2 alpha:1]];
    [view addSubview:displayName];
    [self addSubview:view];
    if(self.cornerText) {
        
        CGRect quantityRect = CGRectMake(rect.size.width - 15, -5 , 30, 30);
        UIView *quantityView = [[UIView alloc] initWithFrame:quantityRect];
        [quantityView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:quantityRect];
        [imageView setImage:[UIImage imageNamed:@"badgebg.png"]];
        [self addSubview:imageView];
        
        UILabel *lblquantity = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        lblquantity.text = self.cornerText;
        lblquantity.numberOfLines = 2;
        [lblquantity setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        lblquantity.textColor = [UIColor whiteColor];
        lblquantity.textAlignment = NSTextAlignmentCenter;
        [quantityView addSubview:lblquantity];
        [self addSubview:quantityView];
        [self bringSubviewToFront:quantityView];
    }

    if(self.price)
    {
        UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, rect.size.width - 10, 30)];
        lblPrice.text = [POSCommon formatCurrencyFromNumber:self.price];
        lblPrice.textAlignment = NSTextAlignmentCenter;
        [lblPrice setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [lblPrice setTextColor:[UIColor yellowColor]];
        [self addSubview:lblPrice];
    }
    
    if(self.amount)
    {
        CGRect rect = CGRectMake(0, view.frame.size.height + 3, view.frame.size.width, 20);
        UIView* balanceView = [[UIView alloc] initWithFrame:rect];
        [balanceView.layer setBorderColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.2 alpha:1].CGColor];
        balanceView.layer.borderWidth = 0.5;
        balanceView.layer.cornerRadius = 5;
        balanceView.tag = 1002;
        
        UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, rect.size.width - 6, 20)];
        [balanceLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        balanceLabel.text = [NSString stringWithFormat:@"%@", [POSCommon formatCurrencyFromNumber:self.amount]];
        [balanceLabel setTextAlignment:NSTextAlignmentCenter];
        [balanceLabel setTextColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.2 alpha:1]];
        [balanceView addSubview:balanceLabel];
        UIView* preView = [self.contentView viewWithTag:1002];
        [preView removeFromSuperview];
        [self addSubview:balanceView];

    }
}

- (void)applyProductSkin
{
    imageName = @"products_icon";
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)applyTransportSkin
{
    imageName = @"lorrygreen";
    [self setBackgroundColor:[UIColor clearColor]];
    
}
- (void)prepareForReuse
{
    [self clearsContextBeforeDrawing];
}

@end
