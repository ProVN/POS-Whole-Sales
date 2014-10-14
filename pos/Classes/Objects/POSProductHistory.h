//
//  POSProductHistory.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSProductHistory : POSObject
@property (strong, nonatomic) NSNumber* ProductID;
@property (strong, nonatomic) NSNumber* StockOnHand;
@property (strong, nonatomic) NSDate* AddedTime;
@end
