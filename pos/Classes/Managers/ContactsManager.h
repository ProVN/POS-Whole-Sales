//
//  ContactsManager.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "POSContact.h"
#import "Define.h"

@interface ContactsManager : DBManager {

}

+ (ContactsManager*)sharedContactsManager;

- (void)requestAllContacts: (ContactType)contactType target:(id)target;

@end
