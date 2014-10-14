//
//  ReportResultViewController.m
//  pos
//
//  Created by Loc Tran on 7/25/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ReportResultViewController.h"
#import "POSSaleInvoice.h"
#import "POSPurchase.h"
#import "POSCustomer.h"
#import "POSSupplier.h"

@interface ReportResultViewController ()

@end

@implementation ReportResultViewController {
    NSMutableString *html;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* template_path = [[NSBundle mainBundle] pathForResource:@"sales_report" ofType:@"html"];
    NSString* template = [NSString stringWithContentsOfFile:template_path encoding:NSUTF8StringEncoding error:nil];
    NSString* style_path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString* style = [NSString stringWithContentsOfFile:style_path encoding:NSUTF8StringEncoding error:nil];
    html = [NSMutableString stringWithString:template];
    [html replaceOccurrencesOfString:@"{style}" withString:style options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    [html replaceOccurrencesOfString:@"{title}" withString:self.reportTitle options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    
    NSString *header = @"";
    for (NSString* headerItem in self.reportHeader) {
        NSString* tmp = [NSString stringWithFormat:@"<th>%@</th>",headerItem];
        header = [header stringByAppendingString:tmp];
    }
    [html replaceOccurrencesOfString:@"{header}" withString:header options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    
    
    NSString *content = @"";
    for (NSMutableArray *values in self.reportContents) {
        content = [content stringByAppendingString:@"<tr>"];
        for (NSString* contentItem in values) {
            NSString* tmp = [NSString stringWithFormat:@"<td>%@</td>",contentItem];
            content = [content stringByAppendingString:tmp];
        }
        content = [content stringByAppendingString:@"</tr>"];
    }
    [html replaceOccurrencesOfString:@"{contents}" withString:content options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    
    [self.webView loadHTMLString:html baseURL:nil];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *btnPrint = [[UIBarButtonItem alloc] initWithTitle:@"Print via AirPrint" style:UIBarButtonItemStyleBordered target:self action:@selector(doPrint)];
    self.navigationItem.rightBarButtonItem = btnPrint;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
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
        formatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
        formatter.maximumContentWidth = 6 * 72.0;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
