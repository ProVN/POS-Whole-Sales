//
//  MenuTableViewCell.m
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMenuItem:(MenuItem *)item {
    menuItem = item;
    self.textLabel.text = [menuItem title];
    self.imageView.image = [UIImage imageNamed:[menuItem imageName]];
}

- (UIViewController *)getViewController {
    if(menuItem)
        return [menuItem controller];
    return nil;
}

@end
