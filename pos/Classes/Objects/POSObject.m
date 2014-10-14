//
//  POSObject.m
//  pos
//
//  Created by Loc Tran on 2/21/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//
#import <objc/runtime.h>
#import "POSObject.h"

objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount);
const char *property_getName(objc_property_t property);

@implementation POSObject

/*! Init an object with dictionary */
- (POSObject*) initWithDictionary:(NSDictionary *)dictionary
{
    if(dictionary == nil) return nil;
    self = [self init];
    [self setValuesForKeysWithDictionary:dictionary];
    return self;

}

/*! Generate a dictionary with current object */
- (NSDictionary *)dictionary
{
    if(self == nil) return nil;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    if(self.Id != nil)
    {
        [dic setValue:self.Id  forKey:@"id"];
    }
    for(int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        if([key isEqual:@"Id"]) continue;
        NSString *value = [self valueForKey:key];
        NSString *dicKey = key;
            [dic setValue:value forKey:dicKey];
    }
    return dic;
}

- (void)setValueWithObject:(POSObject *)item
{
    [self setValuesForKeysWithDictionary:[item dictionary]];
}

@end
