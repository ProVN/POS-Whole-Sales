//
//  DateTimePickerViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "DateTimePickerViewController.h"

@interface DateTimePickerViewController ()

@end

@implementation DateTimePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Choose a date";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLayout];
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 420, 280);
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doSave)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    if(self.datetime)
        [self.datetimePicker setDate:self.datetime];
}

- (void)setDelegate:(id)target
{
    _delegate = target;
}

- (void)setTag:(int)tag
{
    _tag = tag;
}

-(void) doSave
{
    [_delegate dateTimePickerSaved:self.datetimePicker.date tag:_tag];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) doCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayInTextField:(UITextField *)txtfield
{
    textfield = txtfield;
}

@end
