//
//  CategoryAddViewController.m
//  pos
//
//  Created by Loc Tran on 7/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "CategoryAddViewController.h"
#import "POSCategory.h"

@interface CategoryAddViewController ()

@end

@implementation CategoryAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Produce's Information";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.txtCategoryName becomeFirstResponder];
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 400, 180	);
    [self setLayout];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = btnDone;
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    if(self.category) {
        self.txtCategoryName.text = self.category.Name;
    }
    else {
        self.category = [[POSCategory alloc] init];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark User Defined

- (void)done
{
    self.errorMsg.hidden = YES;
    for (POSCategory* category in [DBCaches sharedInstant].categories) {
        if(category) {
            if([category.Name isEqualToString:self.txtCategoryName.text] && ![self.category.Name isEqualToString:self.txtCategoryName.text])
            {
                self.errorMsg.hidden = NO;
                break;
            }
        }
        else {
            if([category.Name isEqualToString:self.txtCategoryName.text]){
                self.errorMsg.hidden = NO;
                break;
            }
        }
    }
    if(!self.errorMsg.hidden) return;
    POSCategory *category = [[POSCategory alloc] init];
    if(self.category)
        category.Id = self.category.Id;
    category.Name = self.txtCategoryName.text;
    [[DBManager sharedInstant] saveData:kDbCategories item:category target:self];
}

- (void)cancel
{
    [self closeForm];
}

- (void) closeForm
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTarget:(id)target
{
    _target = target;
}

#pragma mark-
#pragma mark DBDelegate 

- (void)saveDataCompleted:(POSObject *)insertedItem
{
    [_target categoryAddViewControllerCompleted];
    [self closeForm];
}

- (void)requestFailed:(NSError *)message
{
    
}
@end
