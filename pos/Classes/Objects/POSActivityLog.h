//
//  POSActivityLog.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSActivityLog : POSObject
@property (strong, nonatomic) NSString* Action;
@property (strong, nonatomic) NSDate* Time;
@property (strong, nonatomic) NSNumber* UserId;
@end
