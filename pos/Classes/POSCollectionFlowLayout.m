//
//  POSCollectionFlowLayout.m
//  pos
//
//  Created by Loc Tran on 2/27/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSCollectionFlowLayout.h"
#import "ProductCollectionViewCell.h"
@implementation POSCollectionFlowLayout

- (id)init
{
    self = [super init];
    if(self)
    {
        self.minimumLineSpacing = 20;
        self.itemSize = CGSizeMake(100, 130);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        
    }
    return self;
}

@end
