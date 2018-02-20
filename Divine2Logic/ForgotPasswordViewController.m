//
//  ForgotPasswordViewController.m
//  Divine2Logic
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    containerView.layer.cornerRadius = 5;
    containerView.clipsToBounds = YES;
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
    [mobileTxtFld resignFirstResponder];
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
        [containerScroll setContentOffset:CGPointMake(0.0,105 ) animated:YES];
    return YES;
}

- (IBAction)backCallBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendCallBack:(id)sender {
    
    [mobileTxtFld resignFirstResponder];
    [containerScroll setContentOffset:CGPointMake(0.0, 00) animated:YES];
    
    if(![[MMCommon  sharedInstance] isNullString:mobileTxtFld.text])
    {
        [self performRequestForForgetPassword];
    }
    else{
        [MMCommon showOnlyAlert:@"Sorry!" :@"Mobile No Required":self.navigationController];
    }
}


#pragma mark-API Integration

-(void)performRequestForForgetPassword
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];
        
        NSString *requestStr = @"User/forgetpassword";
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];
        
        request.delegate=self;
        [request setUseSessionPersistence:NO];
        
        [request addPostValue:mobileTxtFld.text forKey:@"cell_phone"];
        
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    
    forgetPasswdJson = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([[forgetPasswdJson valueForKey:@"status"] intValue] == 1)
    {
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
        
        NSMutableArray *forgetCode = [[NSMutableArray alloc]init];
        forgetCode = [forgetPasswdJson objectForKey:@"list"];
        
        ResetPasswordViewController *resetPassword =(ResetPasswordViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
        resetPassword.cellPhNo = mobileTxtFld.text;
        [self.navigationController pushViewController:resetPassword animated:YES];
    }
    else
    {
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
        [MMCommon showOnlyAlert:@"Sorry!" :[forgetPasswdJson valueForKey:@"message"]:self.navigationController];
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
