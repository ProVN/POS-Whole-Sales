//
//  MenuItem.m
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

@synthesize imageName, title, controller;

- (MenuItem*)initWithTitle:(NSString *)_title controller:(UIViewController *)_controller imageName:(NSString *)_imageName {
    self.title = _title;
    self.controller = _controller;
    self.imageName = _imageName;
    return self;
}
@end
