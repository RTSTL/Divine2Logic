//
//  RegistrationViewController.m
//  Divine2Logic
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect bounds = self.view.bounds;
    float scaleFY = bounds.size.height / 568.0f;
        
    fieldContainerScroll.contentSize = CGSizeMake(1, 550 * scaleFY);
    
    containerView.layer.cornerRadius = 5;
    containerView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [mainContainerScroll setContentOffset:CGPointMake(0.0, 00) animated:YES];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [initial resignFirstResponder];
//    [firstName resignFirstResponder];
//    [lastName resignFirstResponder];
//    [dateOfBirth resignFirstResponder];
//    [email resignFirstResponder];
//    [mobileNo resignFirstResponder];
//    [userName resignFirstResponder];
//    [password resignFirstResponder];
//    [confPassword resignFirstResponder];
    
    [mainContainerScroll setContentOffset:CGPointMake(0.0, 00) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag == 4)
        [mainContainerScroll setContentOffset:CGPointMake(0.0,105 ) animated:YES];
    else if (textField.tag== 5 || textField.tag== 6 || textField.tag== 7 || textField.tag== 8 || textField.tag== 9)
        [mainContainerScroll setContentOffset:CGPointMake(0.0,205 ) animated:YES];
    return YES;
}


- (IBAction)signInCallBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
