//
//  POSLessTransport.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSLessTransport : POSObject
@property (strong, nonatomic) NSNumber* SaleInvoiceID;
@property (strong, nonatomic) NSNumber* Quantity;
@property (strong, nonatomic) NSNumber* TransportPrice;
@property (strong, nonatomic) NSNumber* TotalTransport;
@end