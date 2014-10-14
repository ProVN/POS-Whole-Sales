//
//  UserDetailViewController.m
//  pos
//
//  Created by Loc Tran on 2/11/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "UserDetailViewController.h"
#import "DataTableViewController.h"
#import "DBManager.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController
@synthesize user, txtFullname, txtInital, txtRole,txtStatus, txtTitle, txtUsername;
static UserDetailViewController *_userDetail = nil;

+(UserDetailViewController *)userDetailInstance{
    if (_userDetail == nil) {
        _userDetail = [[UserDetailViewController alloc] init];
    }
    return _userDetail;
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
//    self.txtTitle.delegate = self;
//    self.txtRole.delegate = self;
    if(self.user)
    {
        txtUsername.text    = user.Username;
        txtFullname.text    = user.FullName;
        txtInital.text      = user.UserInitial;
        txtTitle.text = user.Title;
        txtRole.selectedSegmentIndex        = [user.Role integerValue];
        if(user.Status)
            txtStatus.selectedSegmentIndex = 0;
        else
            txtStatus.selectedSegmentIndex = 1;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

//#pragma mark
//#pragma DBDelegate
//-(void)insertData{
//    POSUser *object = [[POSUser alloc] init];
//    if (txtrUsername.text.length == 0 || txtTitle.text.length == 0 || txtRole.text.length == 0) {
//        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill in the empty fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [aler show];
//    }
//    else{
//        object.Username = txtUsername.text;
//        object.FullName = txtFullname.text;
//        object.Title = txtTitle.text;
//        object.Role = [NSNumber numberWithInt:[txtRole.text intValue]];
//        object.UserInitial =txtInital.text;
//        object.Status = YES;
//        object.AddedTime = [NSDate date];
//        object.UpdatedTime = [NSDate date];
//        object.Phone = @"0949931124";
//        object.Password = @"123456";
//        
//        [[DBManager sharedInstant] saveData:kDBUsers item:object target:self];
//    }
//}
//
//- (void)requestDataCompleted: (NSMutableArray*) results{}
//- (void)saveDataCompleted:(POSObject*)insertedItem{
//    [[NSNotificationCenter defaultCenter] postNotificationName:PopToUsersViewController object:nil];
//}
//- (void)deleteDataCompleted:(id)objectId{
//}
//
//- (void)requestFailed: (NSError*) message{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//}

@end
