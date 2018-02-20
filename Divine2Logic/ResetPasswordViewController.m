//
//  ResetPasswordViewController.m
//  Divine2Logic
//
//  Created by Apple on 15/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    otpView.layer.cornerRadius = 5;
    otpView.clipsToBounds = YES;
    passwordView.layer.cornerRadius = 5;
    passwordView.clipsToBounds = YES;
    confPasswordView.layer.cornerRadius = 5;
    confPasswordView.clipsToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    [containerScroll setContentOffset:CGPointMake(0.0, 00) animated:YES];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [otpText resignFirstResponder];
    [passwordText resignFirstResponder];
    [confPasswordText resignFirstResponder];
    [containerScroll setContentOffset:CGPointMake(0.0, 00) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag == 1)
        [containerScroll setContentOffset:CGPointMake(0.0,205) animated:YES];
    return YES;
}

- (IBAction)backCallBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendResetCallBack:(id)sender {
    
    [otpText resignFirstResponder];
    [passwordText resignFirstResponder];
    [confPasswordText resignFirstResponder];
    [containerScroll setContentOffset:CGPointMake(0.0, 00) animated:YES];
    
    if(![[MMCommon  sharedInstance] isNullString:otpText.text])
    {
        if(![[MMCommon  sharedInstance] isNullString:passwordText.text])
        {
            if(![[MMCommon  sharedInstance] isNullString:confPasswordText.text])
            {
                if([passwordText.text isEqualToString:confPasswordText.text])
                {
                    [self performRequestForResetPassword];
                }
                else{
                    [MMCommon showOnlyAlert:@"Sorry!" :@"Password Mismatch":self.navigationController];
                }
            }
            else{
                [MMCommon showOnlyAlert:@"Sorry!" :@"Confirm Password Required":self.navigationController];
            }
        }
        else{
            [MMCommon showOnlyAlert:@"Sorry!" :@"New Password Required":self.navigationController];
        }
    }
    else{
        [MMCommon showOnlyAlert:@"Sorry!" :@"OTP Required":self.navigationController];
    }
}

#pragma mark-API Integration

-(void)performRequestForResetPassword
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];
        
        NSString *requestStr = @"User/getnewpassword";
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];
        
        request.delegate=self;
        [request setUseSessionPersistence:NO];
        
        [request addPostValue:_cellPhNo forKey:@"cell_phone"];
        [request addPostValue:otpText.text forKey:@"forget_code"];
        [request addPostValue:passwordText.text forKey:@"password"];
        
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    
    forgetResetPasswdJson = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([[forgetResetPasswdJson valueForKey:@"status"] intValue] == 1)
    {
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
        
        //        NSMutableArray *personal = [[NSMutableArray alloc]init];
        //        personal = [loginJson objectForKey:@"user"];

        LoginViewController *login =(LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }
    else
    {
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
        [MMCommon showOnlyAlert:@"Sorry!" :[forgetResetPasswdJson valueForKey:@"message"]:self.navigationController];
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
