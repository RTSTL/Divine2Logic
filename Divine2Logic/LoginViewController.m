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
    
    UITabBarController *dashboard =(UITabBarController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mainTabbar"];
    
    [self.navigationController pushViewController:dashboard animated:YES];
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
