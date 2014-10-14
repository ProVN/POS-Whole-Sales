//
//  POSProduct.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSProduct : POSObject
@property (strong, nonatomic) NSNumber* CategoryId;
@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSString* PackType;
@property (strong, nonatomic) NSString* Size;
@property (strong, nonatomic) NSNumber* Levies;
@property (assign, nonatomic) BOOL Status;
@property (strong, nonatomic) NSDate* AddedTime;
@property (strong, nonatomic) NSDate* UpdatedTime;


+ (NSMutableArray *)filterWithCategoryId:(NSMutableArray*) products categoryId:(NSNumber *)categoryId;
+ (NSMutableArray*) filterWithStatus:(NSMutableArray*) products status: (BOOL) status;
@end
