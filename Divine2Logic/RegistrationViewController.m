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
    
    userInfo = [GlobalStore getInstance];
    
    initialArray = [[NSMutableArray alloc] init];
    genderArray = [[NSMutableArray alloc] init];
    
    [self performRequestForSystemValue:@"prefix" :1];
    [self performRequestForSystemValue:@"gender" :2];
    
}

-(void)ShowSelectedDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    dateOfBirth.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [dateOfBirth resignFirstResponder];
}

-(void)cancelAction
{
    [dateOfBirth resignFirstResponder];
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
    [mainContainerScroll setContentOffset:CGPointMake(0.0, 00) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag == 4){
        [mainContainerScroll setContentOffset:CGPointMake(0.0,105 ) animated:YES];
        
        datePicker=[[UIDatePicker alloc]init];
        datePicker.datePickerMode=UIDatePickerModeDate;
        
        [dateOfBirth setInputView:datePicker];
        datePicker.maximumDate = [NSDate date];
        
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor orangeColor]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate)];
        
        UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [toolBar setItems:[NSArray arrayWithObjects:cancelBtn,space,doneBtn,nil]];
        [dateOfBirth setInputAccessoryView:toolBar];
    }
    else if (textField.tag== 5 || textField.tag== 6 || textField.tag== 7 || textField.tag== 8 || textField.tag== 9)
        [mainContainerScroll setContentOffset:CGPointMake(0.0,205 ) animated:YES];
    return YES;
}

- (IBAction)optionCallBack:(id)sender {
    
    if([sender tag] == 1){
        UIAlertController *actionInitial = [UIAlertController alertControllerWithTitle:@"Select Initial"
                                                                               message:@""
                                                                        preferredStyle:UIAlertControllerStyleActionSheet];
        for (int j =0 ; j<initialArray.count; j++)
        {
            NSString *titleString = [[initialArray objectAtIndex:j] valueForKey:@"initialValue"];
            UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                initial.text = [[initialArray objectAtIndex:j] valueForKey:@"initialValue"];
                initialTag = [[initialArray objectAtIndex:j] valueForKey:@"initilID"];
            }];
            
            [actionInitial addAction:action];
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            
            [self dismissViewControllerAnimated:actionInitial completion:nil];
        }];
        
        [actionInitial addAction:cancelAction];
        [self presentViewController:actionInitial animated:YES completion:nil];
    }
    else if([sender tag] == 2){
        UIAlertController *actionGender = [UIAlertController alertControllerWithTitle:@"Select Gender"
                                                                               message:@""
                                                                        preferredStyle:UIAlertControllerStyleActionSheet];
        for (int j =0 ; j<genderArray.count; j++)
        {
            NSString *titleString = [[genderArray objectAtIndex:j] valueForKey:@"initialValue"];
            UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                gender.text = [[genderArray objectAtIndex:j] valueForKey:@"initialValue"];
                genderTag = [[genderArray objectAtIndex:j] valueForKey:@"initilID"];
            }];
            
            [actionGender addAction:action];
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            
            [self dismissViewControllerAnimated:actionGender completion:nil];
        }];
        
        [actionGender addAction:cancelAction];
        [self presentViewController:actionGender animated:YES completion:nil];
    }
}

- (IBAction)signInCallBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpCallBack:(id)sender {
    
//    ConfirmRegistrationViewController *confRegistration =(ConfirmRegistrationViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmRegistrationViewController"];
//    [self.navigationController pushViewController:confRegistration animated:YES];
    
    if(![[MMCommon  sharedInstance] isNullString:initial.text])
    {
        if(![[MMCommon  sharedInstance] isNullString:firstName.text])
        {
            if(![[MMCommon  sharedInstance] isNullString:dateOfBirth.text])
            {
                if(![[MMCommon  sharedInstance] isNullString:gender.text])
                {
                    if(![[MMCommon  sharedInstance] isNullString:mobileNo.text])
                    {
                        if (![[MMCommon  sharedInstance] isNullString:userName.text])
                        {
                            if (![[MMCommon  sharedInstance] isNullString:password.text])
                            {
                                if (![[MMCommon  sharedInstance] isNullString:confPassword.text])
                                {
                                    if([password.text isEqualToString:confPassword.text])
                                    {
                                        [self performRequestForSignUp];
                                    }
                                    else{
                                        [MMCommon showOnlyAlert:@"Sorry!" :@"password mismatch":self.navigationController];
                                    }
                                }else{
                                    [MMCommon showOnlyAlert:@"Sorry!" :@"Enter Your Confirm Password":self.navigationController]; }
                            }
                            else
                            {
                                [MMCommon showOnlyAlert:@"Sorry!" :@"Enter Your Password":self.navigationController];
                            }
                        }
                        else
                        {
                            [MMCommon showOnlyAlert:@"Sorry!" :@"Enter Your username":self.navigationController];
                        }
                    }
                    else{
                        [MMCommon showOnlyAlert:@"Sorry!" :@"Enter your mobile number":self.navigationController];
                    }
                }
                else{
                    [MMCommon showOnlyAlert:@"Sorry!" :@"Enter your Gender":self.navigationController];
                }
            }
            else{
                [MMCommon showOnlyAlert:@"Sorry!" :@"please select your date of birth":self.navigationController];
            }
        }
        else {
            [MMCommon showOnlyAlert:@"Sorry!" :@"Enter your first name":self.navigationController];
        }
    }else {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Enter your Name Initial":self.navigationController];
    }
}

#pragma mark-API Integration

-(void)performRequestForSystemValue: (NSString *) argParam : (int) tagValue
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];

        NSString *requestStr = @"Dynamicform/GetSysValue";

        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];

        request.delegate=self;
        [request setUseSessionPersistence:NO];
        request.tag = tagValue;
        [request addPostValue:argParam forKey:@"sys_attr"];
        
        [request startAsynchronous];
    }
}

-(void)performRequestForSignUp
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];
        
        NSString *requestStr = @"MSMember/AddMember";
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];
        
        request.delegate=self;
        [request setUseSessionPersistence:NO];
        request.tag = 3;
        [request addPostValue:userName.text forKey:@"member_id"];
        [request addPostValue:password.text forKey:@"password"];
        [request addPostValue:email.text forKey:@"email_id"];
        [request addPostValue:mobileNo.text forKey:@"cell_phone"];
        [request addPostValue:@"" forKey:@"member_typ"];
        [request addPostValue:initialTag forKey:@"prefix_id"];
        [request addPostValue:firstName.text forKey:@"first_nm"];
        [request addPostValue:lastName.text forKey:@"last_nm"];
        [request addPostValue:genderTag forKey:@"gender_id"];
        [request addPostValue:dateOfBirth.text forKey:@"dob"];
        
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    
    responseJson = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
    
    if(request.tag == 1){
        if ([[responseJson valueForKey:@"status"] intValue] == 1)
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            
            NSMutableArray *tempInitialArray = [[NSMutableArray alloc]init];
            tempInitialArray = [responseJson objectForKey:@"list"];
            
            for (int i = 0; i<tempInitialArray.count; i++) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:[[tempInitialArray valueForKey:@"sys_val_id"] objectAtIndex:i] forKey:@"initilID"];
                [dict setValue:[[tempInitialArray valueForKey:@"sys_value"] objectAtIndex:i] forKey:@"initialValue"];
                [initialArray addObject:dict];
            }
        }
        else
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            [MMCommon showOnlyAlert:@"Sorry!" :[responseJson valueForKey:@"message"]:self.navigationController];
        }
    }
    
    else if(request.tag == 2){
        if ([[responseJson valueForKey:@"status"] intValue] == 1)
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            
            NSMutableArray *tempGenderArray = [[NSMutableArray alloc]init];
            tempGenderArray = [responseJson objectForKey:@"list"];
            
            for (int i = 0; i<tempGenderArray.count; i++) {
                NSMutableDictionary *dictGender = [[NSMutableDictionary alloc] init];
                [dictGender setValue:[[tempGenderArray valueForKey:@"sys_val_id"] objectAtIndex:i] forKey:@"initilID"];
                [dictGender setValue:[[tempGenderArray valueForKey:@"sys_value"] objectAtIndex:i] forKey:@"initialValue"];
                [genderArray addObject:dictGender];
            }
        }
        else
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            [MMCommon showOnlyAlert:@"Sorry!" :[responseJson valueForKey:@"message"]:self.navigationController];
        }
    }
    
    else if(request.tag == 3){
        if ([[responseJson valueForKey:@"status"] intValue] == 1)
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
                        
            userInfo.id_enc = [responseJson valueForKey:@"dbresponse"];
            
            ConfirmRegistrationViewController *confRegistration =(ConfirmRegistrationViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmRegistrationViewController"];
            [self.navigationController pushViewController:confRegistration animated:YES];
        }
        else
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            [MMCommon showOnlyAlert:@"Sorry!" :[responseJson valueForKey:@"dbresponse"]:self.navigationController];
        }
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
