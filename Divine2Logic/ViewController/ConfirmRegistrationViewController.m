//
//  ConfirmRegistrationViewController.m
//  Divine2Logic
//
//  Created by Apple on 20/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import "ConfirmRegistrationViewController.h"

@interface ConfirmRegistrationViewController ()

@end

@implementation ConfirmRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [GlobalStore getInstance];
    
    [self createEnterOTPUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)createEnterOTPUI
{
    for (int i = 1; i<5; i++) {
        UITextField *txtField = [[UITextField alloc]initWithFrame:CGRectMake(50*i,50,40,40)];
        [txtField setDelegate:self];
        [txtField setReturnKeyType:UIReturnKeyDone];
        [txtField setTag:i];
        txtField.layer.cornerRadius = 5;
        txtField.clipsToBounds = YES;
        txtField.secureTextEntry = YES;
        txtField.textAlignment = NSTextAlignmentCenter;
        txtField.backgroundColor = [UIColor whiteColor];
        txtField.keyboardType = UIKeyboardTypeNumberPad;
        [enterOTPView addSubview:txtField];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [containerScrollView setContentOffset:CGPointMake(0.0,105 ) animated:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldProcess = NO; //default to reject
    BOOL shouldMoveToNextField = NO; //default to remaining on the current field
    
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    
    int insertStringLength = (int)[string length];
    if(insertStringLength == 0){ //backspace
        shouldProcess = YES; //Process if the backspace character was pressed
    }
    else {
        if([[textField text] length] == 0) {
            shouldProcess = YES; //Process if there is only 1 character right now
        }
    }
    
    //here we deal with the UITextField on our own
    if(shouldProcess){
        //grab a mutable copy of what's currently in the UITextField
        NSMutableString* mstring = [[textField text] mutableCopy];
        if([mstring length] == 0){
            //nothing in the field yet so append the replacement string
            [mstring appendString:string];
            
            shouldMoveToNextField = YES;
        }
        else{
            //adding a char or deleting?
            if(insertStringLength > 0){
                [mstring insertString:string atIndex:range.location];
            }
            else {
                //delete case - the length of replacement string is zero for a delete
                [mstring deleteCharactersInRange:range];
            }
        }
        
        //set the text now
        [textField setText:mstring];
        
        if (shouldMoveToNextField) {
            //
            //MOVE TO NEXT INPUT FIELD HERE
            if(nextResponder){
                [nextResponder becomeFirstResponder];
            }
            else{
                [textField resignFirstResponder];
                [containerScrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
            }
        }
    }
    
    //always return no since we are manually changing the text field
    return NO;
}

- (IBAction)backCallBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getOTPCallBack:(id)sender {
    [self performRequestForGetOTP];
}

- (IBAction)verifyCallBack:(id)sender {
    
    [self performRequestForVerifyOTP];
}

#pragma mark-API Integration

-(void)performRequestForGetOTP
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];
        
        NSString *requestStr = @"MSMember/GetMemberOTP";
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];
        
        request.delegate=self;
        request.tag = 1;
        [request setUseSessionPersistence:NO];
        
        [request addPostValue:userInfo.id_enc forKey:@"id_enc"];
        [request addPostValue:phoneNoTextFld.text forKey:@"cell_phone"];
        
        [request startAsynchronous]; 
    }
}

-(void)performRequestForVerifyOTP
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];
        
        NSString *requestStr = @"MSMember/VerifyMemberOTP";
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];
        
        request.delegate=self;
        request.tag = 2;
        [request setUseSessionPersistence:NO];
        
        NSString *OTPvalue = @"";
        for (int i = 1; i<5; i++) {
            UITextField *nameTextField = (UITextField*)[enterOTPView viewWithTag:i];
            OTPvalue = [OTPvalue stringByAppendingString:nameTextField.text];
        }

        [request addPostValue:userInfo.id_enc forKey:@"id_enc"];
        [request addPostValue:OTPvalue forKey:@"otp"];
        [request addPostValue:@"1" forKey:@"device_id"];
        [request addPostValue:@"A" forKey:@"device_token"];
        
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    
    responseJson = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
    
    if(request.tag == 1)
    {
        if ([[responseJson valueForKey:@"status"] intValue] == 1)
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            
            enterOTPView.hidden = NO;
        }
        else
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            [MMCommon showOnlyAlert:@"Sorry!" :[responseJson valueForKey:@"message"]:self.navigationController];
        }
    }
    else if (request.tag == 2){
        if ([[responseJson valueForKey:@"status"] intValue] == 1)
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            
            NSMutableArray *personal = [[NSMutableArray alloc]init];
            personal = [responseJson objectForKey:@"user"];
            
            userInfo.id_enc = [[personal valueForKey:@"id_enc"] objectAtIndex:0];
            userInfo.member_id = [[personal valueForKey:@"member_id"] objectAtIndex:0];
            userInfo.member_type = [[personal valueForKey:@"member_typ"] objectAtIndex:0];
            userInfo.name = [[personal valueForKey:@"name"] objectAtIndex:0];
            userInfo.org_mem_id = [[personal valueForKey:@"org_mem_id"] objectAtIndex:0];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thank You" message:@"Your Registration is Successfull" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     UITabBarController *dashboard =(UITabBarController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mainTabbar"];
                                     
                                     [self.navigationController pushViewController:dashboard animated:YES];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            [MMCommon showOnlyAlert:@"Sorry!" :[responseJson valueForKey:@"message"]:self.navigationController];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
    [MMCommon showOnlyAlert:@"Sorry!" :@"Something Went Wrong.":self.navigationController];
}

@end
