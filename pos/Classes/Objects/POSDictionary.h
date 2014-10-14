//
//  POSDictionary.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSDictionary : POSObject
@property (strong, nonatomic) NSNumber* Type;
@property (strong, nonatomic) NSString* Key;
@property (strong, nonatomic) NSString* Value;
@end
