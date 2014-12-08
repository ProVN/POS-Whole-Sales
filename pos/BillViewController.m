//
//  BillViewController.m
//  pos
//
//  Created by Loc Tran on 8/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "BillViewController.h"
#import "POSSaleInvoiceDetail.h"
#import "POSPurchaseDetail.h"
#import "POSProduct.h"
#import "DBCaches.h"
#import "DBManager.h"
#import "POSCommon.h"

@interface BillViewController ()

@end

@implementation BillViewController {
    NSMutableString *html;
}

- (void)viewDidLoad {
   self.navigationController.view.superview.bounds = CGRectMake(0, 0, 450, 700);
    [super viewDidLoad];
    
    NSString* footer_path = [[NSBundle mainBundle] pathForResource:@"footer_melbourne" ofType:@"html"];
    NSString* footer = [NSString stringWithContentsOfFile:footer_path encoding:NSUTF8StringEncoding error:nil];
    
    if([DBManager sharedInstant].dbIndex == 0) {
        footer_path = [[NSBundle mainBundle] pathForResource:@"footer_sysney" ofType:@"html"];
        footer = [NSString stringWithContentsOfFile:footer_path encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSString* template_path = [[NSBundle mainBundle] pathForResource:@"bill" ofType:@"html"];
    NSString* template = [NSString stringWithContentsOfFile:template_path encoding:NSUTF8StringEncoding error:nil];
    NSString* style_path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString* style = [NSString stringWithContentsOfFile:style_path encoding:NSUTF8StringEncoding error:nil];
    html = [NSMutableString stringWithString:template];
    [html replaceOccurrencesOfString:@"{style}" withString:style options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    NSString *content = @"";
    if(self.transactionType == TransactionTypeSale)
    {
        for (POSSaleInvoiceDetail *detail in self.data) {
            NSString *item = @"<tr>";
            POSProduct* product = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].products withId:detail.ProductID];
            item = [NSString stringWithFormat:@"%@<td style='text-align:left'>%@</td>",item,product.Name];
            item = [NSString stringWithFormat:@"%@<td style='text-align:right'>%@</td>",item ,detail.Quantity];
            item = [NSString stringWithFormat:@"%@<td style='text-align:right'>%@</td>",item,[POSCommon formatCurrencyFromNumber:detail.SalePrice]];
            item = [NSString stringWithFormat:@"%@<td style='text-align:right'>%@</td>",item,[POSCommon formatCurrencyFromNumber:detail.TotalAmount]];
            item = [NSString stringWithFormat:@"%@</tr>",item];
            content = [NSString stringWithFormat:@"%@,%@",content,item];
        }
    }
    else {
       
        for (POSPurchaseDetail *detail in self.data) {
            NSString *item = @"<tr>";
            POSProduct* product = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].products withId:detail.ProductID];
            item = [NSString stringWithFormat:@"%@<td style='text-align:left'>%@</td>",item,product.Name];
            item = [NSString stringWithFormat:@"%@<td style='text-align:right'>%@</td>",item ,detail.Quantity];
            item = [NSString stringWithFormat:@"%@<td style='text-align:right'>%@</td>",item,[POSCommon formatCurrencyFromNumber:detail.PurchasePrice]];
            item = [NSString stringWithFormat:@"%@<td style='text-align:right'>%@</td>",item,[POSCommon formatCurrencyFromNumber:detail.TotalAmount]];
            item = [NSString stringWithFormat:@"%@</tr>",item];
            content = [NSString stringWithFormat:@"%@,%@",content,item];
        }
    }

    [html replaceOccurrencesOfString:@"{tbody}" withString:content options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    
    [html replaceOccurrencesOfString:@"{sale_person}" withString:self.contact options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    [html replaceOccurrencesOfString:@"{dismount}" withString:self.dismount options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    [html replaceOccurrencesOfString:@"{total}" withString:self.total options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    [html replaceOccurrencesOfString:@"{gst}" withString:self.gst options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    [html replaceOccurrencesOfString:@"{paid}" withString:self.paid options:NSLiteralSearch range:NSMakeRange(0, html.length)];
     [html replaceOccurrencesOfString:@"{balance}" withString:self.balance options:NSLiteralSearch range:NSMakeRange(0, html.length)];
     [html replaceOccurrencesOfString:@"{invoice_no}" withString:self.invoiceNo options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    [html replaceOccurrencesOfString:@"{date}" withString:[POSCommon formatDateToString:self.invoiceDate] options:NSLiteralSearch range:NSMakeRange(0, html.length)];
     [html replaceOccurrencesOfString:@"{credit}" withString:self.invoiceCredit?@"YES":@"NO" options:NSLiteralSearch range:NSMakeRange(0, html.length)];

    [html replaceOccurrencesOfString:@"{to_from}" withString:self.toFrom options:NSLiteralSearch range:NSMakeRange(0, html.length)];
     [html replaceOccurrencesOfString:@"{contact_company_name}" withString:self.customerName options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    [html replaceOccurrencesOfString:@"{footer}" withString:footer options:NSLiteralSearch range:NSMakeRange(0, html.length)];

    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *btnPrint = [[UIBarButtonItem alloc] initWithTitle:@"Print via AirPrint" style:UIBarButtonItemStyleBordered target:self action:@selector(doPrint)];
    self.navigationItem.rightBarButtonItem = btnPrint;
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = btnCancel;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) doPrint
{
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        UIPrintInteractionController *print = [UIPrintInteractionController sharedPrintController];
        print.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"POS report print";
        print.printInfo = printInfo;
        
        UIPrintFormatter *formatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:html];
        formatter.startPage = 0;
        formatter.contentInsets = UIEdgeInsetsMake(36.0, 36.0, 36.0, 36.0); // 1 inch margins
        formatter.maximumContentWidth = 6 * 36.0;
        print.printFormatter = formatter;
        print.showsPageRange = YES;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"Printing could not complete because of error: %@", error);
            }
        };
        
        [print presentFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES completionHandler:completionHandler];
        
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Airprint is not available. Please make sure that Airpirnt is connected to your IPAD" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
