//
//  UserCollectionViewCell.h
//  pos
//
//  Created by Loc Tran on 2/11/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSCustomer.h"
#import "POSSupplier.h"
#import "POSUser.h"
@interface UserCollectionItemView : UICollectionViewCell {
    CGRect currentRect;
    BOOL status;
}
@property (strong, nonatomic) POSObject* person;

@end
