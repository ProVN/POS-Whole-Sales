//
//  DBCaches.m
//  pos
//
//  Created by Loc Tran on 2/24/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "DBCaches.h"

DBCaches* _instant = nil;

@implementation DBCaches
+ (DBCaches*)sharedInstant
{
    if(_instant == nil) {
        _instant = [[DBCaches alloc] init];
    }
    return _instant;
}

-(id) getObjectInCaches:(NSMutableArray *)caches withId:(NSNumber *)Id
{
    POSObject *obj;
    if(caches == nil)
        return nil;

    for (POSObject *object in caches) {
        if([object.Id intValue] == [Id intValue])
            obj = object;
    }
    
    return obj;
}
@end
