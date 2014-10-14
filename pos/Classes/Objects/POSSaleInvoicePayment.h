//
//  POSPurchasePayment.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSSaleInvoicePayment : POSObject
@property (strong, nonatomic) NSNumber* SaleInvoiceID;
@property (strong, nonatomic) NSNumber* PaymentType;
@property (strong, nonatomic) NSNumber* PaymentAmount;
@property (strong, nonatomic) NSDate* PaymentTime;
@property (strong, nonatomic) NSString* Description;
@end
