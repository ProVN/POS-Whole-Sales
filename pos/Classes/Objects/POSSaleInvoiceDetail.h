//
//  POSPurchaseDetail.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSSaleInvoiceDetail : POSObject
@property (strong, nonatomic) NSNumber* SaleInvoiceID;
@property (strong, nonatomic) NSNumber* ProductID;
@property (strong, nonatomic) NSNumber* Quantity;
@property (strong, nonatomic) NSNumber* TotalAmount;
@property (assign, nonatomic) BOOL IsLessLevies;
@property (strong, nonatomic) NSNumber* SalePrice;
@property (strong, nonatomic) NSNumber* SaleLevy;
@end
