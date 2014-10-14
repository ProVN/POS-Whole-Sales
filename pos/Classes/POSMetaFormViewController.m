//
//  POSMetaFormViewController.m
//  pos
//
//  Created by Loc Tran on 7/14/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSMetaFormViewController.h"
#import "POSMeta.h"

@interface POSMetaFormViewController ()

@end

@implementation POSMetaFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Meta's Infomation";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationController.view.superview.bounds = CGRectMake(0, 0, 400, 300);
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = btnDone;
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    [self.txtType removeAllSegments];
    for(int i = 0; i < [POSMeta sharedInstance].metaType.count ; i++){
        [self.txtType insertSegmentWithTitle:[[POSMeta sharedInstance] getMetaTypeName:i] atIndex:i animated:NO];
    }
    self.txtType.selectedSegmentIndex = 0;
    
    // Do any additional setup after loading the view from its nib.
    if(self.metaData == nil){
        self.metaData = [[POSMetadata alloc] init];
    }
    else {
        self.txtType.selectedSegmentIndex = [[POSMeta sharedInstance] getMetaTypeIndex:self.metaData.Group];
        self.txtValue.text = self.metaData.Value;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark User Defined

- (void)setTarget:(id)target
{
    _target = target;
}


- (void) done
{
    POSMetadata *metadata = [[POSMetadata alloc] init];
    if(self.metaData){
        metadata.Id = self.metaData.Id;
    }
    metadata.Group = [[POSMeta sharedInstance] getMetaTypeName:self.txtType.selectedSegmentIndex];
    metadata.Value = self.txtValue.text;
    [[DBManager sharedInstant] saveData:kDbMetadatas item:metadata target:self];
}

- (void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark DBDelegate
- (void)saveDataCompleted:(POSObject *)insertedItem
{
    [_target POSMetaFormViewControllerCompleted];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)requestFailed:(NSError *)message
{
    
}
@end
