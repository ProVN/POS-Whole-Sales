//
//  ContactsManager.m
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ContactsManager.h"

static ContactsManager* _instant = nil;
@implementation ContactsManager

+ (ContactsManager *)sharedContactsManager
{
    if(_instant == nil) {
        _instant = [[ContactsManager alloc] init];
    }
    return _instant;
}



@end
