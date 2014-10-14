//
//  DBManager.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "DBCaches.h"
#import "POSUser.h"

/*! DEFINE DATABASE TABLE NAME */
#define DB_ACTIVITY_LOGS                @"ActivityLogs"
#define DB_CUSTOMERS                    @"Customers"
#define DB_DICTIONARY                   @"Dictionary"
#define DB_LESS_OTHERS                  @"LessOthers"
#define DB_LESS_TRANSPORTS              @"LessTransports"
#define DB_METADATAS                    @"Metadatas"
#define DB_PRODUCT_HISTORIES            @"ProductHistories"
#define DB_CATEGORIES                   @"Categories"
#define DB_PRODUCTS                     @"Products"
#define DB_PURCHASE_DETAILS             @"PurchaseDetails"
#define DB_PURCHASE_PAYMENTS            @"PurchasePayments"
#define DB_PURCHASES                    @"Purchases"
#define DB_PURCHASE_TRANSPORTS          @"PurchaseTransports"
#define DB_SALE_INVOICE_DETAILS         @"SaleInvoiceDetails"
#define DB_SALE_INVOICE_PAYMENTS        @"SaleInvoicePayments"
#define DB_SALE_INVOICES                @"SaleInvoices"
#define DB_SUPPLIERS                    @"Suppliers"
#define DB_USERS                        @"Users"

typedef enum
{
    kDbUnknown,                 //0
    kDbActivityLogs,            //1
    kDbCustomers,               //2
    kDbDictionary,              //3
    kDbLessOthers,              //4
    kDbLessTransports,          //5
    kDbMetadatas,               //6
    kDbProductHistories,        //7
    kDbCategories,              //8
    kDbProducts,                //9
    kDbPurchaseDetails,         //10
    kDbPurchasePayments,        //11
    kDbPurchases,               //12
    kDbPurchaseTransports,      //13
    kDbSaleInvoiceDetails,      //14
    kDbSaleInvoicePayments,     //15
    kDbSaleInvoices,            //16
    kDbSuppliers,               //17
    kDBUsers                    //18
}
DBName;

@protocol DBDelegate <NSObject>
@required
- (void)requestFailed: (NSError*) message;
@optional
- (void)requestDataCompleted: (NSMutableArray*) results;
- (void)saveDataCompleted:(POSObject*)insertedItem;
- (void)deleteDataCompleted:(id)objectId;
@end


@interface DBManager : NSObject<UIAlertViewDelegate, DBDelegate> {
    id<DBDelegate> _delegate;
    UIAlertView *alert;
    BOOL cancelled;
    DBCaches *caches;
}
@property (strong, nonatomic) MSClient *client;
@property (strong, nonatomic) MSTable *table;
@property (assign, nonatomic) BOOL synchronized;
@property (strong, nonatomic) POSUser* currentUser;
@property (assign, nonatomic) NSInteger dbIndex;

+ (DBManager*)sharedInstant;
- (void)setDelegate:(id) target;
- (void)requestData:(DBName) dbName predicate:(NSPredicate*) predicate title:(NSString*) title message:(NSString*) message target:(id)target;
- (void)requestData:(DBName) dbName predicate:(NSPredicate*) predicate target:(id)target;

- (void)saveData:(DBName) dbName item:(POSObject*) item title:(NSString*) title message:(NSString*) message target:(id)target;
- (void)saveData:(DBName) dbName item:(POSObject*) item target:(id)target;

- (void)deleteData:(DBName) dbName item:(POSObject*) item title:(NSString*) title message:(NSString*) message target:(id)target;
- (void)deleteData:(DBName) dbName item:(POSObject*) item target:(id)target;

- (void)insertItem:(DBName) dbName item:(POSObject*) item;
- (void)deleteItem:(DBName) dbName item:(POSObject*) item;
@end
