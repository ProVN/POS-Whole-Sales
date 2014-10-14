//
//  ProductFormViewController.m
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ProductFormViewController.h"

@interface ProductFormViewController ()

@end

@implementation ProductFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"Sub Produce's Information";
        detailView = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadViewBySegment];

    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = btnDone;
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    if(self.product == nil) {
        self.product = [[POSProduct alloc] init];
        self.product.CategoryId = self.category.Id;
        self.product.Status = YES;
    }
    [detailView setData:self.product];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setLayout];
    
    //Add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) loadViewBySegment {
    [detailView.view removeFromSuperview];
    if(historyView) [historyView.view removeFromSuperview];
    if(self.segmentControl.selectedSegmentIndex == 0) {
        [self.scrollView addSubview:detailView.view];
    }
    else if(self.segmentControl.selectedSegmentIndex == 1){
        if(historyView == nil) {
            historyView = [[ProductHistoriesTableViewController alloc] init];
            historyView.productId = self.product.Id;
        }
        [self.scrollView addSubview:historyView.view];
    }
}

- (IBAction)segmentValueChanged:(id)sender {
    [self loadViewBySegment];
}

#pragma mark - 
#pragma mark User Defined

-(void) keyboardWillShow
{
    if([POSCommon isLandscapeMode])
    {
        CGSize size = self.scrollView.frame.size;
        size.height += 150;
        self.scrollView.contentSize = size;
    }
}
-(void) keyboardWillHide
{
    if([POSCommon isLandscapeMode])
    {
        CGSize size = self.scrollView.frame.size;
        self.scrollView.contentSize = size;
    }
}

- (void)done
{
    if(!detailView.isValidData) return;
    POSProduct* product = [detailView getData];
    [[DBManager sharedInstant] saveData:kDbProducts item:product target:self];
}

- (void)cancel
{
    [self closeForm];
}

- (void)closeForm
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setTarget:(id)target
{
    _target = target;
}

#pragma mark -
#pragma mark DBDelegate
- (void)saveDataCompleted:(POSObject *)insertedItem
{
    [_target productFormViewControllerCompleted];
    [self closeForm];
}

-(void)requestFailed:(NSError *)message
{
    
}
@end
