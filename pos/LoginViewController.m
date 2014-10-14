//
//  LoginViewController.m
//  pos
//
//  Created by Loc Tran on 2/25/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () {
    DBName step;
}

@end

@implementation LoginViewController {
    CGRect frame;
    BOOL isCancelled;
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
    // Do any additional setup after loading the view from its nib.
    self.loginView.layer.cornerRadius = 20;
    self.txtPassword.secureTextEntry = YES;
    self.view.backgroundColor = [self mainColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    frame = self.loginView.frame;
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        frame.origin.x = 300;
        frame.origin.y = 30;
        
    }
    else {
        frame.origin.x = 180;
        frame.origin.y = 150;
    }
    self.loginView.frame = frame;

    [self loadCurrentUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogin:(id)sender {
    [self.txtUsername resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Username=%@ && Password=%@",self.txtUsername.text,self.txtPassword.text];
    self.lblLoading.text = @"Checking your username and password...";
    [self showLoading];
    step = kDbUnknown;
    isCancelled = NO;
    [[DBManager sharedInstant] setDbIndex:self.dbIndex.selectedSegmentIndex];
    [[DBManager sharedInstant] requestData:kDBUsers predicate:predicate title:nil message:nil target:self];
}

- (IBAction)doCancel:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exit application" message:@"Are you sure want to exit ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (IBAction)cancelLogin:(id)sender
{
    isCancelled = YES;
    [self showInput];
}

- (void) showLoading
{
    CGPoint point = self.inputView.frame.origin;
    self.inputView.hidden = YES;
    self.loadingView.frame = CGRectMake(point.x, point.y, self.loginView.frame.size.width, self.loadingView.frame.size.height);
    [self.loginView addSubview:self.loadingView];
}

- (void) showInput
{
    [self.loadingView removeFromSuperview];
    self.inputView.hidden = NO;
}

- (void) saveCurrentUser
{
    [[NSUserDefaults standardUserDefaults] setObject:self.txtUsername.text forKey:@"kUsername"];
    [[NSUserDefaults standardUserDefaults] setObject:self.txtPassword.text forKey:@"kPassword"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.dbIndex.selectedSegmentIndex] forKey:@"kDBIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) deleteCurrentUser
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"kUsername"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"kPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadCurrentUser
{
    self.txtUsername.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"kUsername"];
    self.txtPassword.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"kPassword"];
    NSNumber* dbindex = (NSNumber*)[[NSUserDefaults standardUserDefaults] stringForKey:@"kDBIndex"] ;
    if(dbindex) {
        self.dbIndex.selectedSegmentIndex = [dbindex integerValue];
    }
    
    if(self.txtUsername.text.length > 0)
    {
        [self.txtRemember setOn:YES];
        [self doLogin:nil];
    }
    else
    {
        [self.txtUsername becomeFirstResponder];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        frame.origin.x = 300;
        frame.origin.y = 30;
        
    }
    else {
        frame.origin.x = 180;
        frame.origin.y = 150;
    }
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            self.loginView.frame = frame;
            }
        completion:nil];
}

#pragma mark
#pragma mark DBDelegate
- (void)requestDataCompleted:(NSMutableArray *)results
{
    if(isCancelled) return;
    if(step == kDbUnknown){
        if(results.count > 0)
        {
            [DBManager sharedInstant].currentUser= [results objectAtIndex:0];
            NSLog(@"Login successfully with user=%@", self.txtUsername.text);
            NSLog(@"Initing customers....");
            if(self.txtRemember.on)
            {
                NSLog(@"Remember me is checked. Starting to save current user");
                [self saveCurrentUser];
            }
            else
            {
                NSLog(@"Remember me is not checked. Starting to delete current user");
                [self deleteCurrentUser];
            }
            step++;
            self.lblLoading.text = [NSString stringWithFormat:@"Loading data (%d of %d) ...",step, kDBUsers];
            NSLog(@"Request data of %d",step);
            [[DBManager sharedInstant] requestData:step predicate:nil title:nil message:nil target:self];
            initStep = kInitStepLoadCustomers;
        }
        else
        {
            NSLog(@"Invalid username or password with user=%@", self.txtUsername.text);
            [self.txtUsername becomeFirstResponder];
            self.lblError.text = @"Invalid username or password";
            self.lblError.numberOfLines = 2;
            self.lblError.hidden = NO;
            [self showInput];
        }
    }
    else if(step < kDBUsers){
       step++;
       NSLog(@"Request data of %d",step);
       self.lblLoading.text = [NSString stringWithFormat:@"Loading data (%d of %d) ...",step, kDBUsers];
       [[DBManager sharedInstant] requestData:step predicate:nil title:nil message:nil target:self];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCompleted" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)requestFailed:(NSError *)message
{
    self.lblError.text = @"Cannot connect to server.\nPlease check your internet connection.";
    self.lblError.numberOfLines = 2;
    self.lblError.hidden = NO;
    [self showInput];
}

#pragma mark
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex) {
        exit(0);
    }
}
@end
