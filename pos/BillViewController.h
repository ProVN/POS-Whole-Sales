//
//  BillViewController.h
//  pos
//
//  Created by Loc Tran on 8/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

@interface BillViewController : UIViewController <UIPrintInteractionControllerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *invoiceNo;
@property (strong, nonatomic) NSDate *invoiceDate;
@property (assign, nonatomic) BOOL invoiceCredit;
@property (strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) NSString* contact;
@property (strong, nonatomic) NSString* dismount;
@property (strong, nonatomic) NSString* total;
@property (strong, nonatomic) NSString* gst;
@property (strong, nonatomic) NSString* paid;
@property (strong, nonatomic) NSString* balance;
@property (strong, nonatomic) NSString* toFrom;
@property (strong, nonatomic) NSString* customerName;
@property (assign, nonatomic) TransactionType transactionType;
@end
