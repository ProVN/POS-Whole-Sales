//
//  CustomerFormViewController.m
//  pos
//
//  Created by ; Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "UserFormViewController.h"

@interface UserFormViewController ()

@end

@implementation UserFormViewController {
    
}
@synthesize user;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Add new user";
        userDetailView = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(insertUpdateUser)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Canel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    if(user)
    {
        userDetailView.user = user;
    }
    [self loadViewBySegment];
    // Do any additional setup after loading the view from its nib.
}
- (void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLayout];
}

//-(void)viewDidAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToUserView) name:PopToUsersViewController object:nil];
//}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PopToUsersViewController object:nil];
}
-(void)popToUserView{
    [DBManager sharedInstant].synchronized = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadViewBySegment {
    [userDetailView.view removeFromSuperview];
    if(self.segmentControl.selectedSegmentIndex == 0) {
        [self.scrollView addSubview:userDetailView.view];
    }
}

- (IBAction)segmentValueChanged:(id)sender {
    [self loadViewBySegment];
}

-(void)insertUpdateUser{
//    [userDetailView insertData];
    [self insertData];
}

//==================
-(void)insertData{
    POSUser *object = [[POSUser alloc] init];
    if (userDetailView.txtUsername.text.length == 0 || userDetailView.txtTitle.text.length == 0) {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill in the empty fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aler show];
    }
    else{
        if (user.Id) {
            object.Id = user.Id;
        }
        object.Username = userDetailView.txtUsername.text;
        object.FullName = userDetailView.txtFullname.text;
        object.Title = userDetailView.txtTitle.text;
        object.Role = [NSNumber numberWithInt:userDetailView.txtRole.selectedSegmentIndex];
        object.UserInitial = userDetailView.txtInital.text;
        object.Status = YES;
        object.AddedTime = [NSDate date];
        object.UpdatedTime = [NSDate date];
        object.Phone = @"";
        object.Password = @"";
        object.Status = userDetailView.txtStatus.selectedSegmentIndex == 0 ? YES: NO;
        
        [[DBManager sharedInstant] saveData:kDBUsers item:object target:self];
        [_target userFormViewControllerCompleted];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)requestDataCompleted: (NSMutableArray*) results{}
- (void)saveDataCompleted:(POSObject*)insertedItem{
    [self popToUserView];
}
- (void)deleteDataCompleted:(id)objectId{
}

- (void)requestFailed: (NSError*) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)setTarget:(id)target
{
    _target = target;
}

@end
