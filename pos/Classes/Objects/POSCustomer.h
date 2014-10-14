//
//  POSCustomer.h
//  pos
//
//  Created by Loc Tran on 2/18/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSObject.h"
@interface POSCustomer : POSObject
@property (strong, nonatomic) NSString* CompanyName;
@property (strong, nonatomic) NSString* ABN;
@property (strong, nonatomic) NSString* ContactName;
@property (strong, nonatomic) NSString* Title;
@property (strong, nonatomic) NSString* Address;
@property (strong, nonatomic) NSString* Phone;
@property (strong, nonatomic) NSString* AltPhone;
@property (strong, nonatomic) NSString* Fax;
@property (strong, nonatomic) NSString* Email;
@property (strong, nonatomic) NSString* CcEmail;
@property (strong, nonatomic) NSString* CurrentOwning;
@property (strong, nonatomic) NSDate* AddedTime;
@property (assign, nonatomic) BOOL Status;
@property (strong, nonatomic) NSDate* UpdatedTime;
@property (strong, nonatomic) NSNumber* AccountLimit;
@property (strong, nonatomic) NSString* BankBSB;
@property (strong, nonatomic) NSString* BankAccount;
@property (strong, nonatomic) NSString* BankNotes;
@property (strong, nonatomic) NSString* CCNumber;
@property (strong, nonatomic) NSString* CCName;
@property (strong, nonatomic) NSDate* CCExpire;
@property (strong, nonatomic) NSNumber* CurrentBalance;
@property (strong, nonatomic) NSDate* LastBuying;
@property (strong, nonatomic) NSDate* LastPayment;
@property (strong, nonatomic) NSString* MemberCode;
@end
