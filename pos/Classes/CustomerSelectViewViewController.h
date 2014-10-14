//
//  CustomerSelectViewViewController.h
//  pos
//
//  Created by Loc Tran on 2/11/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"
#import "DBManager.h"

@protocol ContactSelectDelegate <NSObject>
- (void) contactSelectChanged:(id) contact;
@end

@interface CustomerSelectViewViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate> {
    id<ContactSelectDelegate> _delegate;
    NSMutableArray *datasource;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) ContactType contactType;
@property (nonatomic, assign) BOOL allowSelectAll;

- (void)setDelegate:(id) target;
@end
