//
//  POSProduct.m
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSProduct.h"


@implementation POSProduct

+ (NSMutableArray *)filterWithCategoryId:(NSMutableArray*) products categoryId:(NSNumber *)categoryId;
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(POSProduct* product in products)
    {
       if([categoryId intValue] == [product.CategoryId intValue])
            [result addObject:product];
    }
    
    NSLog(@"Filter Products with CategorId=%d (%d products)",[categoryId integerValue], result.count);
    return result;
}


+ (NSMutableArray *)filterWithStatus:(NSMutableArray *)products status:(BOOL)status
{
     NSMutableArray *result = [[NSMutableArray alloc] init];
    for(POSProduct* product in products)
    {
        if(product.Status == status)
           [result addObject:product];
    }
    NSLog(@"Filter Products with Status=%hhd (%d products)",status, result.count);
    return result;
}
@end
