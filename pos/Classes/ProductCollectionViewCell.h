//
//  ProductCollectionViewCell.h
//  pos
//
//  Created by Loc Tran on 2/11/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) NSString* displayname;
@property(nonatomic, strong) NSString* cornerText;
@property(nonatomic, strong) NSNumber* price;
@property(nonatomic, strong) NSNumber* amount;
- (void) applyProductSkin;
- (void) applyTransportSkin;
- (void) prepareForReuse;
@end
