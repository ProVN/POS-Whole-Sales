//
//  Define.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#ifndef pos_Define_h
#define pos_Define_h

typedef enum
{
    ContactTypeUnknown,
    ContactTypeCustomer,
    ContactTypeSuppplier
}
ContactType;

typedef enum
{
    TransactionTypeUnknown,
    TransactionTypeSale,
    TransactionTypePurchase
}
TransactionType;
#endif
