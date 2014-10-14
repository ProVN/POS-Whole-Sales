//
//  POSPurchase.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSPurchase : POSObject
@property (strong, nonatomic) NSString* PurchaseRef;
@property (strong, nonatomic) NSDate* IssuedTime;
@property (strong, nonatomic) NSNumber* TotalAmount;
@property (strong, nonatomic) NSNumber* Balance;
@property (assign, nonatomic) BOOL Status;
@property (strong, nonatomic) NSDate* AddedTime;
@property (strong, nonatomic) NSDate* UpdatedTime;
@property (assign, nonatomic) BOOL IsLessTransport;
@property (assign, nonatomic) BOOL IsGstIncluded;
@property (strong, nonatomic) NSNumber* TotalPayment;
@property (strong, nonatomic) NSNumber* Discount;
@property (assign, nonatomic) BOOL CreditService;
@property (strong, nonatomic) NSString* Memo;
@property (strong, nonatomic) NSNumber* SupplierID;
@property (strong, nonatomic) NSNumber* UserID;
@end
