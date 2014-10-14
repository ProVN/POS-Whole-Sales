//
//  POSObject.h
//  pos
//
//  Created by Loc Tran on 2/21/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"

@interface POSObject : NSObject

@property (strong, nonatomic) NSNumber* Id;

- (POSObject*) initWithDictionary:(NSDictionary*) dictionary;
- (NSDictionary*) dictionary;
- (void) setValueWithObject:(POSObject*) item;
@end
