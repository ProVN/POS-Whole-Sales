//
//  POSMetadata.h
//  pos
//
//  Created by Loc Tran on 3/3/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

@interface TimeObject : NSObject
@property (strong, nonatomic) NSDate* minDate;
@property (strong, nonatomic) NSDate* maxDate;

- (TimeObject*) initWithMinDate:(NSDate*) minDateVal maxDate:(NSDate*) maxDateVal;
@end

@interface POSMeta : NSObject

@property (strong, nonatomic) NSMutableArray *paymentTypes;
@property (strong, nonatomic) NSMutableArray *timeListStr;
@property (strong, nonatomic) NSMutableArray *timeList;
@property (strong, nonatomic) NSMutableArray *metaType;
@property (strong, nonatomic) NSMutableArray *produceMonth;
@property (strong, nonatomic) NSMutableArray *produceMonthStr;

+ (POSMeta*) sharedInstance;
- (NSString*) getPaymentName:(NSInteger) paymentId;
- (NSString*) getMetaTypeName:(NSInteger) paymentId;
- (NSInteger) getMetaTypeIndex:(NSString*) name;
- (TimeObject*) getTimeObject:(NSInteger) index;
@end
