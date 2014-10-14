//
//  MenuItem.h
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (strong, nonatomic) NSString* imageName;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) UIViewController *controller;
- (MenuItem*) initWithTitle:(NSString*) _title controller:(UIViewController*) _controller imageName:(NSString*) _imageName;


@end
