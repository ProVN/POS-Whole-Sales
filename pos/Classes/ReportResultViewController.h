//
//  ReportResultViewController.h
//  pos
//
//  Created by Loc Tran on 7/25/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+POSViewController.h"

typedef enum {
    reportTypeSales,
    reportTypePurchase,
}
ReportType;

@interface ReportResultViewController : UIViewController<UIWebViewDelegate, UIPrintInteractionControllerDelegate> {

}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (assign, nonatomic) ReportType reportType;
@property (strong, nonatomic) NSString *reportTitle;
@property (strong, nonatomic) NSMutableArray* reportHeader;
@property (strong, nonatomic) NSMutableArray* reportContents;

@end
