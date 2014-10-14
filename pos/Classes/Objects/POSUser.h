//
//  POSUser.h
//  pos
//
//  Created by Loc Tran on 2/20/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSUser : POSObject
@property (strong, nonatomic) NSString* Username;
@property (strong, nonatomic) NSString* Password;
@property (strong, nonatomic) NSString* UserInitial;
@property (strong, nonatomic) NSDate* AddedTime;
@property (strong, nonatomic) NSDate* UpdatedTime;
@property (assign, nonatomic) BOOL Status;
@property (strong, nonatomic) NSNumber* Role;
@property (strong, nonatomic) NSString* Title;
@property (strong, nonatomic) NSString* FullName;
@property (strong, nonatomic) NSString* Phone;
@end
