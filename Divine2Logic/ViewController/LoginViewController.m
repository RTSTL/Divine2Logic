//
//  LoginViewController.m
//  Divine2Logic
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    loginContainer.layer.cornerRadius = 5;
    loginContainer.clipsToBounds = YES;
    
    [userID setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [password setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    userInfo = [GlobalStore getInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    [containerScrollView setContentOffset:CGPointMake(0.0, 00) animated:YES];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userID resignFirstResponder];
    [password resignFirstResponder];
    [containerScrollView setContentOffset:CGPointMake(0.0, 00) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag == 1)
        [containerScrollView setContentOffset:CGPointMake(0.0,105 ) animated:YES];
    else if (textField.tag== 2)
        [containerScrollView setContentOffset:CGPointMake(0.0,105 ) animated:YES];
    return YES;
}

- (IBAction)loginCallBack:(id)sender {
    
    [userID resignFirstResponder];
    [password resignFirstResponder];
    
    if(![[MMCommon sharedInstance] isNullString:userID.text])
    {
        if(![[MMCommon  sharedInstance] isNullString:password.text])
        {
            [containerScrollView setContentOffset:CGPointMake(0.0, 00) animated:YES];
            [self performRequestForLogIn];
        }
        else{
            [MMCommon showOnlyAlert:@"Sorry!" :@"Password Required":self.navigationController];
        }
    }
    else
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Enter UserID":self.navigationController];
    }
}

#pragma mark-Call Api For LogIn

-(void)performRequestForLogIn
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];
        
        NSString *requestStr = @"User/Login";
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];
        
        request.delegate=self;
        [request setUseSessionPersistence:NO];
        
        [request addPostValue:@"cypher007" forKey:@"member_id"];
        [request addPostValue:@"Sa123456" forKey:@"password"];
        [request addPostValue:VENDOR_UUID forKey:@"device_id"];
        [request addPostValue:@"1" forKey:@"device_token"];
        
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    
    loginJson = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([[loginJson valueForKey:@"status"] intValue] == 1)
    {
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
        
        NSMutableArray *personal = [[NSMutableArray alloc]init];
        personal = [loginJson objectForKey:@"user"];
        
//        userInfo.id_enc = [[personal valueForKey:@"id_enc"] objectAtIndex:0];
//        userInfo.member_id = [[personal valueForKey:@"member_id"] objectAtIndex:0];
//        userInfo.member_type = [[personal valueForKey:@"member_typ"] objectAtIndex:0];
//        userInfo.name = [[personal valueForKey:@"name"] objectAtIndex:0];
//        userInfo.org_mem_id = [[personal valueForKey:@"org_mem_id"] objectAtIndex:0];
//        
        [KFKeychain saveObject:[[personal valueForKey:@"id_enc"] objectAtIndex:0] forKey:@"id_enc"];
        [KFKeychain saveObject:[[personal valueForKey:@"member_id"] objectAtIndex:0] forKey:@"member_id"];
        [KFKeychain saveObject:[[personal valueForKey:@"member_type"] objectAtIndex:0] forKey:@"member_type"];
        [KFKeychain saveObject:[[personal valueForKey:@"name"] objectAtIndex:0] forKey:@"name"];
        [KFKeychain saveObject:[[personal valueForKey:@"org_mem_id"] objectAtIndex:0] forKey:@"org_mem_id"];
        [KFKeychain saveObject:[[personal valueForKey:@"pic_id"] objectAtIndex:0] forKey:@"pic_id"];

        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged_in"];

        
        userID.text=@"";
        password.text=@"";
        
        UITabBarController *dashboard =(UITabBarController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mainTabbar"];
        
        [self.navigationController pushViewController:dashboard animated:YES];
    }
    else
    {
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
        [MMCommon showOnlyAlert:@"Sorry!" :[loginJson valueForKey:@"message"]:self.navigationController];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
    [MMCommon showOnlyAlert:@"Sorry!" :@"Something Went Wrong.":self.navigationController];
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
