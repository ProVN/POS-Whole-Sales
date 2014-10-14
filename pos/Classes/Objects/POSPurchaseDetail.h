//
//  POSPurchaseDetail.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSPurchaseDetail : POSObject
@property (strong, nonatomic) NSNumber* ProductID;
@property (strong, nonatomic) NSNumber* Quantity;
@property (strong, nonatomic) NSNumber* TotalAmount;
@property (strong, nonatomic) NSNumber* PurchasePrice;
@property (strong, nonatomic) NSNumber* PurchaseID;
@property (strong, nonatomic) NSNumber* PurchaseLevy;
@property (strong, nonatomic) NSString* SupplierInvoice;
@property (assign, nonatomic) BOOL IsLessLevies;
@end
