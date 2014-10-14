//
//  DBCaches.h
//  pos
//
//  Created by Loc Tran on 2/24/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POSObject.h"

@interface DBCaches : NSObject

@property (strong, nonatomic) NSMutableArray* activityLogs;
@property (strong, nonatomic) NSMutableArray* customers;
@property (strong, nonatomic) NSMutableArray* dictonary;
@property (strong, nonatomic) NSMutableArray* lessOthers;
@property (strong, nonatomic) NSMutableArray* lessTransport;
@property (strong, nonatomic) NSMutableArray* metaDatas;
@property (strong, nonatomic) NSMutableArray* productHistories;
@property (strong, nonatomic) NSMutableArray* categories;
@property (strong, nonatomic) NSMutableArray* products;
@property (strong, nonatomic) NSMutableArray* purchasePayments;
@property (strong, nonatomic) NSMutableArray* purchases;
@property (strong, nonatomic) NSMutableArray* purchaseDetail;
@property (strong, nonatomic) NSMutableArray* purchaseTransports;
@property (strong, nonatomic) NSMutableArray* saleInvoiceDetails;
@property (strong, nonatomic) NSMutableArray* saleInvoicePayments;
@property (strong, nonatomic) NSMutableArray* saleInvoices;
@property (strong, nonatomic) NSMutableArray* suppliers;
@property (strong, nonatomic) NSMutableArray* users;

- (id) getObjectInCaches:(NSMutableArray*) caches withId:(NSNumber*)Id;
+ (DBCaches*)sharedInstant;

@end
