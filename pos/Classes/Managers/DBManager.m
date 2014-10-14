//
//  DBManager.m
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "DBManager.h"
#import "AppDelegate.h"
#import "POSAllObjects.h"
#import "LoginViewController.h"
#import "MasterViewController.h"

static DBManager* _instant = nil;
@implementation DBManager
@synthesize client, table, currentUser;

+ (DBManager*)sharedInstant
{
    if(_instant == nil) {
        _instant = [[DBManager alloc] init];
    }
    [_instant setDB];
    return _instant;
}
-(id)init {
    caches = [DBCaches sharedInstant];
    return self;
}

- (void) setDB {
    if(self.dbIndex == 1)
        self.client = [(AppDelegate*)[UIApplication sharedApplication].delegate clientM];
    else
        self.client = [(AppDelegate*)[UIApplication sharedApplication].delegate clientS];
}

-(void)setDelegate:(id)target
{
   _delegate = target;
}

#pragma mark
#pragma mark Login
-(BOOL)isLoggedIn
{
    if(currentUser) return YES;
    return NO;
}

- (void) viewLogin:(UIViewController*) controller
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [controller presentViewController:loginViewController animated:NO completion:nil];
}

#pragma mark
#pragma mark RequestData
- (void)requestData:(DBName)dbName predicate:(NSPredicate *)predicate target:(id)target
{
    [self setDelegate:target];
    [self requestData:dbName predicate:predicate title:@"Loading" message:@"Loading data, please wait ..."];
}

-(void)requestData:(DBName)dbName predicate:(NSPredicate *)predicate title:(NSString *)title message:(NSString *)message target:(id)target
{
    [self setDelegate:target];
    [self requestData:dbName predicate:predicate title:title message:message];
}

- (void)requestData:(DBName)dbName predicate:(NSPredicate *)predicate title:(NSString *)title message:(NSString *)message
{
    cancelled = NO;
    if(title || message){
        alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        alert.tag = 1;
        [alert show];
    }
    [self getTableName:dbName];
    
    if(table == nil) return;
    MSQuery *query = [self.table query];
    query.fetchLimit = 1000;
    query.predicate = predicate;
    
    [query readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if(cancelled) return;
        if(error) {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [_delegate requestFailed:error];
        }
        else {
            NSMutableArray* results = [[NSMutableArray alloc] init];
            for (NSDictionary* item in items) {
                POSObject* object = [self getObject:dbName item:item];
                if(object)
                    [results addObject:object];
            }
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [self saveCache:dbName items:results];
            [_delegate requestDataCompleted:results];
        }
    }];
}

#pragma mark -
#pragma mark Insert Data
- (void)saveData:(DBName)dbName item:(POSObject *)item title:(NSString *)title message:(NSString *)message target:(id)target
{
    [self setDelegate:target];
    [self saveData:dbName item:item title:title message:message];
}
- (void)saveData:(DBName)dbName item:(POSObject *)item target:(id)target
{
    [self setDelegate:target];
    [self saveData:dbName item:item title:@"Inserting Data" message:@"Please wait"];
}

- (void)saveData:(DBName)dbName item:(POSObject*) item  title:(NSString *)title message:(NSString *)message
{
    cancelled = NO;
    if(title || message){
        alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        alert.tag = 1;
        [alert show];
    }
    [self getTableName:dbName];
    if(table == nil) return;
    if(item.Id == nil)
    {
        [self.table insert:[item dictionary] completion:^(NSDictionary *insertedItem, NSError *error) {
            if(error) {
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [POSCommon showError:@"Error" message:error.description];
                [_delegate requestFailed:error];
            }
            else {
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                
                POSObject* object = [self getObject:dbName item:insertedItem];
                [self insertItem:dbName item: object];
                if([item isKindOfClass:[POSSaleInvoice class]])
                {
                    POSSaleInvoice* saleInvoice = (POSSaleInvoice* )item;
                    saleInvoice.Id = [insertedItem objectForKey:@"id"];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yy"];
                    NSString* yearString = [formatter stringFromDate:[NSDate date]];
                    NSString *saleNo = [NSString stringWithFormat:@"MS%@%5d",yearString,[item.Id integerValue]];
                    saleInvoice.SaleInvoiceRef = saleNo;
                    [self saveData:kDbSaleInvoices item:saleInvoice title:nil message:nil];
                }
                else if([item isKindOfClass:[POSPurchase class]])
                {
                    POSPurchase* purchase = (POSPurchase* )item;
                    purchase.Id = [insertedItem objectForKey:@"id"];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yy"];
                    NSString* yearString = [formatter stringFromDate:[NSDate date]];
                    NSString *purNo = [NSString stringWithFormat:@"MS%@%5d",yearString,[item.Id integerValue]];
                    purchase.PurchaseRef = purNo;
                    [self saveData:kDbPurchases item:purchase title:nil message:nil];
                }
                else
                {
                    [_delegate saveDataCompleted:object];
                }
            }
        }];
    }
    else
    {
        [self.table update:[item dictionary] completion:^(NSDictionary *updatedItem, NSError *error) {
            if(error) {
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [POSCommon showError:@"Error" message:error.description];
                [_delegate requestFailed:error];
            }
            else {
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                POSObject* object = [self getObject:dbName item:updatedItem];
                [self updateItem:dbName item:object];
                [_delegate saveDataCompleted:object];
            }
        }];

    }
}

#pragma mark
#pragma Delete

- (void)deleteData:(DBName)dbName item:(POSObject *)item target:(id)target
{
    [self setDelegate:target];
    [self deleteData:dbName item:item title:@"Deleting data" message:@"Please wait..."];
}

- (void)deleteData:(DBName)dbName item:(POSObject *)item title:(NSString *)title message:(NSString *)message target:(id)target
{
    [self setDelegate:target];
    [self deleteData:dbName item:item title:title message:message];
}

- (void)deleteData:(DBName)dbName item:(POSObject *)item title:(NSString *)title message:(NSString *)message
{
    if(title || message){
        alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        alert.tag = 1;
        [alert show];
    }
    [self getTableName:dbName];
    if(table == nil) return;
    [self.table deleteWithId:item.Id completion:^(id itemId, NSError *error) {
        if(error) {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [_delegate requestFailed:error];
        }
        else {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [self deleteItem:dbName item:itemId];
            [_delegate deleteDataCompleted:itemId];
        }
    }];
}



#pragma mark -
#pragma mark Common

- (void)insertItem:(DBName)dbName item:(POSObject *)item
{
    switch (dbName) {
        case kDbActivityLogs:
        {
            [caches.activityLogs addObject:item];;
            break;
        }
        case kDbCustomers:
        {
            [caches.customers addObject:item];
            break;
        }
        case kDbDictionary:
        {
            [caches.dictonary addObject:item];
            break;
        }
        case kDbLessOthers:
        {
            [caches.lessOthers addObject:item];
            break;
        }
        case kDbLessTransports:
        {
            [caches.lessTransport addObject:item];
            break;
        }
        case kDbMetadatas:
        {
            [caches.metaDatas addObject:item];
            break;
        }
        case kDbProductHistories:
        {
            [caches.productHistories addObject:item];
            break;
        }
            
        case kDbCategories:
        {
            [caches.categories addObject:item];
            break;
        }
        case kDbProducts:
        {
            [caches.products addObject:item];
            break;
        }
        case kDbPurchaseDetails:
        {
            [caches.purchaseDetail addObject:item];
            break;
        }
        case kDbPurchasePayments:
        {
            [caches.purchasePayments addObject:item];
            break;
        }
        case kDbPurchases:
        {
            [caches.purchases addObject:item];
            break;
        }
        case kDbPurchaseTransports:
        {
            [caches.purchaseTransports addObject:item];
            break;
        }
        case kDbSaleInvoiceDetails:
        {
            [caches.saleInvoiceDetails addObject:item];
            break;
        }
        case kDbSaleInvoicePayments:
        {
            [caches.saleInvoicePayments addObject:item];
            break;
        }
        case kDbSaleInvoices:
        {
            [caches.saleInvoices addObject:item];
            break;
        }
        case kDbSuppliers:
        {
            [caches.suppliers addObject:item];
            break;
        }
        case kDBUsers:
        {
            [caches.users addObject:item];
            break;
        }
        case kDbUnknown:
        default:
            break;
    }
}

- (void)updateItem:(DBName)dbName item:(POSObject*) item
{
    NSMutableArray *array;
    switch (dbName) {
        case kDbActivityLogs:
        {
            array = caches.activityLogs;
            break;
        }
        case kDbCustomers:
        {
            array = caches.customers;
            break;
        }
        case kDbDictionary:
        {
            array = caches.dictonary;
            break;
        }
        case kDbLessOthers:
        {
            array = caches.lessOthers;
            break;
        }
        case kDbLessTransports:
        {
            array = caches.lessTransport;
            break;
        }
        case kDbMetadatas:
        {
            array = caches.metaDatas;
            break;
        }
        case kDbProductHistories:
        {
            array = caches.productHistories;
            break;
        }
            
        case kDbCategories:
        {
            array = caches.categories;
            break;
        }
        case kDbProducts:
        {
            array = caches.products;
            break;
        }
        case kDbPurchaseDetails:
        {
            array = caches.purchaseDetail;
            break;
        }
        case kDbPurchasePayments:
        {
            array = caches.purchasePayments;
            break;
        }
        case kDbPurchases:
        {
            array = caches.purchases;
            break;
        }
        case kDbPurchaseTransports:
        {
            array = caches.purchaseTransports;
            break;
        }
        case kDbSaleInvoiceDetails:
        {
            array = caches.saleInvoiceDetails;
            break;
        }
        case kDbSaleInvoicePayments:
        {
            array = caches.saleInvoicePayments;
            break;
        }
        case kDbSaleInvoices:
        {
            array = caches.saleInvoices;
            break;
        }
        case kDbSuppliers:
        {
            array = caches.suppliers;
            break;
        }
        case kDBUsers:
        {
            array = caches.users;
            break;
        }
        case kDbUnknown:
        default:
            array = [[NSMutableArray alloc] init];
            break;
    }
    
    for (POSObject* object in array) {
        if([object.Id intValue] == [item.Id intValue]){
            [object setValueWithObject:item];
        }
    }
    [self saveCache:dbName items:array];
}

- (void)deleteItem:(DBName)dbName item:(id)itemId
{
    NSMutableArray *array;
    switch (dbName) {
        case kDbActivityLogs:
        {
            array = caches.activityLogs;
            break;
        }
        case kDbCustomers:
        {
            array = caches.customers;
            break;
        }
        case kDbDictionary:
        {
            array = caches.dictonary;
            break;
        }
        case kDbLessOthers:
        {
            array = caches.lessOthers;
            break;
        }
        case kDbLessTransports:
        {
            array = caches.lessTransport;
            break;
        }
        case kDbMetadatas:
        {
            array = caches.metaDatas;
            break;
        }
        case kDbProductHistories:
        {
            array = caches.productHistories;
            break;
        }
            
        case kDbCategories:
        {
            array = caches.categories;
            break;
        }
        case kDbProducts:
        {
            array = caches.products;
            break;
        }
        case kDbPurchaseDetails:
        {
            array = caches.purchaseDetail;
            break;
        }
        case kDbPurchasePayments:
        {
            array = caches.purchasePayments;
            break;
        }
        case kDbPurchases:
        {
            array = caches.purchases;
            break;
        }
        case kDbPurchaseTransports:
        {
            array = caches.purchaseTransports;
            break;
        }
        case kDbSaleInvoiceDetails:
        {
            array = caches.saleInvoiceDetails;
            break;
        }
        case kDbSaleInvoicePayments:
        {
            array = caches.saleInvoicePayments;
            break;
        }
        case kDbSaleInvoices:
        {
            array = caches.saleInvoices;
            break;
        }
        case kDbSuppliers:
        {
            array = caches.suppliers;
            break;
        }
        case kDBUsers:
        {
            array = caches.users;
            break;
        }
            
        case kDbUnknown:
        default:
            array = [[NSMutableArray alloc] init];
            break;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (POSObject* object in array) {
        if([object.Id integerValue] != [itemId integerValue]){
            [arr addObject:object];
        }
    }
    [self saveCache:dbName items:arr];
}

- (NSMutableArray*) sortByDefault:(DBName)dbName items:(NSMutableArray* )items
{
    NSMutableArray *result;
    NSSortDescriptor *sortDescriptor;
    switch (dbName) {
        case kDbCustomers:
        {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"CompanyName" ascending:YES];
            break;
        }
        case kDbMetadatas:
        {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Value" ascending:YES];
            break;
        }
        case kDbCategories:
        {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES];
            break;
        }
        case kDbProducts:
        {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES];
            break;
        }
        case kDbPurchases:
        {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"UpdatedTime" ascending:NO];
            break;
        }
        case kDbSaleInvoices:
        {
             sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"UpdatedTime" ascending:NO];
            break;
        }
        case kDbSuppliers:
        {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"CompanyName" ascending:YES];
            break;
        }
        case kDBUsers:
        {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"FullName" ascending:YES];
            break;
        }
        default:
        {
            return items;
            break;
        }
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    result = [[items sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    return result;
}

- (void)saveCache:(DBName) dbName items:(NSMutableArray*) items
{
    items = [self sortByDefault:dbName items:items];
    switch (dbName) {
        case kDbActivityLogs:
        {
            caches.activityLogs = items;
            break;
        }
        case kDbCustomers:
        {
            caches.customers = items;
            break;
        }
        case kDbDictionary:
        {
            caches.dictonary = items;
            break;
        }
        case kDbLessOthers:
        {
            caches.lessOthers = items;
            break;
        }
        case kDbLessTransports:
        {
            caches.lessTransport = items;
            break;
        }
        case kDbMetadatas:
        {
            caches.metaDatas = items;
            break;
        }
        case kDbProductHistories:
        {
            caches.productHistories = items;
            break;
        }
            
        case kDbCategories:
        {
            caches.categories = items;
            break;
        }
        case kDbProducts:
        {
            caches.products = items;
            break;
        }
        case kDbPurchaseDetails:
        {
            caches.purchaseDetail = items;
            break;
        }
        case kDbPurchasePayments:
        {
            caches.purchasePayments = items;
            break;
        }
        case kDbPurchases:
        {
            caches.purchases = items;
            break;
        }
        case kDbPurchaseTransports:
        {
            caches.purchaseTransports = items;
            break;
        }
        case kDbSaleInvoiceDetails:
        {
            caches.saleInvoiceDetails = items;
            break;
        }
        case kDbSaleInvoicePayments:
        {
            caches.saleInvoicePayments = items;
            break;
        }
        case kDbSaleInvoices:
        {
            caches.saleInvoices = items;
            break;
        }
        case kDbSuppliers:
        {
            caches.suppliers = items;
            break;
        }
        case kDBUsers:
        {
            caches.users = items;
            break;
        }
        
        case kDbUnknown:
        default:
            break;
    }

}

- (id)getObject: (DBName) dbName item:(NSDictionary*) item {
    switch (dbName) {
        case kDbActivityLogs:
        {
            POSActivityLog *obj = [[POSActivityLog alloc] initWithDictionary:item];
            return obj;
        }
        case kDbCustomers:
        {
            POSCustomer *obj = [[POSCustomer alloc] initWithDictionary:item];
            return obj;
        }
        case kDbDictionary:
        {
            POSDictionary *obj = [[POSDictionary alloc] initWithDictionary:item];
            return obj;
        }
        case kDbLessOthers:
        {
            POSLessOther *obj = [[POSLessOther alloc] initWithDictionary:item];
            return obj;
        }
        case kDbLessTransports:
        {
            POSLessTransport *obj = [[POSLessTransport alloc] initWithDictionary:item];
            return obj;
        }
        case kDbMetadatas:
        {
            POSMetadata *obj = [[POSMetadata alloc] initWithDictionary:item];
            return obj;
        }
        case kDbProductHistories:
        {
            POSProductHistory *obj = [[POSProductHistory alloc] initWithDictionary:item];
            return obj;
        }
        case kDbCategories:
        {
            POSCategory *obj = [[POSCategory alloc] initWithDictionary:item];
            return obj;
        }
        case kDbProducts:
        {
            POSProduct *obj = [[POSProduct alloc] initWithDictionary:item];
            return obj;
        }
        case kDbPurchaseDetails:
        {
            POSPurchaseDetail *obj = [[POSPurchaseDetail alloc] initWithDictionary:item];
            return obj;
        }
        case kDbPurchasePayments:
        {
            POSPurchasePayment *obj = [[POSPurchasePayment alloc] initWithDictionary:item];
            return obj;
        }
        case kDbPurchases:
        {
            POSPurchase *obj = [[POSPurchase alloc] initWithDictionary:item];
            return obj;
        }
        case kDbPurchaseTransports:
        {
            POSPurchaseTransport *obj = [[POSPurchaseTransport alloc] initWithDictionary:item];
            return obj;
        }
        case kDbSaleInvoiceDetails:
        {
            POSSaleInvoiceDetail *obj = [[POSSaleInvoiceDetail alloc] initWithDictionary:item];
            return obj;
        }
        case kDbSaleInvoicePayments:
        {
            POSSaleInvoicePayment *obj = [[POSSaleInvoicePayment alloc] initWithDictionary:item];
            return obj;
        }
        case kDbSaleInvoices:
        {
            POSSaleInvoice *obj = [[POSSaleInvoice alloc] initWithDictionary:item];
            return obj;
        }
        case kDbSuppliers:
        {
            POSSupplier *obj = [[POSSupplier alloc] initWithDictionary:item];
            return obj;
        }
        case kDBUsers:
        {
            POSUser *obj = [[POSUser alloc] initWithDictionary:item];
            return obj;
        }
        case kDbUnknown:
        default:
            return nil;
            break;
    }
}

- (void)getTableName: (DBName)dbName {
    switch (dbName) {
        case kDbActivityLogs:
            table = [client tableWithName:DB_ACTIVITY_LOGS];
            break;
        case kDbCustomers:
            table = [client tableWithName:DB_CUSTOMERS];
            break;
        case kDbDictionary:
            table = [client tableWithName:DB_DICTIONARY];
            break;
        case kDbLessOthers:
            table = [client tableWithName:DB_LESS_OTHERS];
            break;
        case kDbLessTransports:
            table = [client tableWithName:DB_LESS_TRANSPORTS];
            break;
        case kDbMetadatas:
            table = [client tableWithName:DB_METADATAS];
            break;
        case kDbProductHistories:
            table = [client tableWithName:DB_PRODUCT_HISTORIES];
            break;
        case kDbCategories:
            table = [client tableWithName:DB_CATEGORIES];
            break;
        case kDbProducts:
            table = [client tableWithName:DB_PRODUCTS];
            break;
        case kDbPurchaseDetails:
            table = [client tableWithName:DB_PURCHASE_DETAILS];
            break;
        case kDbPurchasePayments:
            table = [client tableWithName:DB_PURCHASE_PAYMENTS];
            break;
        case kDbPurchases:
            table = [client tableWithName:DB_PURCHASES];
            break;
        case kDbPurchaseTransports:
            table = [client tableWithName:DB_PURCHASE_TRANSPORTS];
            break;
        case kDbSaleInvoiceDetails:
            table = [client tableWithName:DB_SALE_INVOICE_DETAILS];
            break;
        case kDbSaleInvoicePayments:
            table = [client tableWithName:DB_SALE_INVOICE_PAYMENTS];
            break;
        case kDbSaleInvoices:
            table = [client tableWithName:DB_SALE_INVOICES];
            break;
        case kDbSuppliers:
            table = [client tableWithName:DB_SUPPLIERS];
            break;
        case kDBUsers:
            table = [client tableWithName:DB_USERS];
            break;
        default:
            table = nil;
            break;
    }
}

#pragma mark
#pragma mark DBDelegate
- (void)requestDataCompleted:(NSMutableArray *)results
{
    return;
}

- (void)insertDataCompleted:(POSObject *)insertedItem
{
    return;
}
- (void)updateDataCompleted:(POSObject *)updatedItem
{
    return;
}
- (void)deleteDataCompleted:(id)objectId
{
    return;
}

- (void)requestFailed:(NSError *)message
{
   return;
}

#pragma mark
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
        cancelled = YES;
    else if(alertView.tag == 3)
    {
        if(buttonIndex == alertView.cancelButtonIndex)
            exit(0);
    }
}

@end
