//
//  MenuTableViewCell.h
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface MenuTableViewCell : UITableViewCell {
    MenuItem *menuItem;    
}

- (void) setMenuItem:(MenuItem*) item;
- (UIViewController*) getViewController;

@end
