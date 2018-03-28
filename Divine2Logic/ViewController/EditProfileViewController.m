//
//  EditProfileViewController.m
//  Divine2Logic
//
//  Created by Apple on 21/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [GlobalStore getInstance];
    
    CGRect bounds = self.view.bounds;
    scaleFX = bounds.size.width  / 320.0f;
    scaleFY = bounds.size.height / 568.0f;
    
    ProfileImageView.layer.cornerRadius=ProfileImageView.frame.size.width/2.0;
    ProfileImageView.clipsToBounds=YES;
    
    
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
    NSString *ImageURL = [NSString stringWithFormat:@"%@ProfilePicture/%@",BASE_URL,userInfo.pic_id];
    [ProfileImageView sd_setImageWithURL:[NSURL URLWithString:ImageURL]];

    [self performRequestForDynamicForm];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(profileImageChanged)
    {
        [self UpdatePictureApi];
        
    }
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
#pragma mark - Actions

- (IBAction)backCallBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API Integration

-(void)performRequestForDynamicForm
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];
        
        NSString *requestStr = @"Dynamicform/GetDynamicMemberform";
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];
        
        request.delegate=self;
        [request setUseSessionPersistence:NO];
        request.tag=1;
        
        [request addPostValue:userInfo.id_enc forKey:@"id_enc"];
        
        [request startAsynchronous];
    }
}


-(void)submitCallBack:(id) sender
{
    NSLog(@"data-%@",[self getDataFromTextField]);
    
    
    
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];
        
        NSString *requestStr = @"Dynamicform/UpdateDynamicMemberForm";
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];
        
        request.delegate=self;
        [request setUseSessionPersistence:NO];
        request.tag=3;
        [request addPostValue:userInfo.id_enc forKey:@"id_enc"];
        [request addPostValue:[self getDataFromTextField] forKey:@"strvalue"];
        [request startAsynchronous];
        
    }
    
}
-(void)UpdatePictureApi
{
    
    
    
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];
        
        NSString *requestStr = @"MSMember/UpdateMemberPic";
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];
        
        request.delegate=self;
        [request setUseSessionPersistence:NO];
        request.tag=4;
        [request addPostValue:userInfo.id_enc forKey:@"id_enc"];
        [request addPostValue:profileBase64String forKey:@"imageval"];
        [request addPostValue:@"1" forKey:@"flag"];
        [request startAsynchronous];
        
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    
    responseJson = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
    if(request.tag==1)
    {
    if ([[responseJson valueForKey:@"status"] intValue] == 1)
    {
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
        
        question = [[NSMutableArray alloc]init];
        question = [responseJson objectForKey:@"list"];
        
        [self formDesign:@"-1"];
    }
    else
    {
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
        [MMCommon showOnlyAlert:@"Sorry!" :[responseJson valueForKey:@"message"]:self.navigationController];
    }
    }
    else if(request.tag==2)

    {
        NSArray *address_components=[[[responseJson valueForKey:@"results"]objectAtIndex:0]valueForKey:@"address_components"];
        NSLog(@"address_components-%@",address_components);
        [self autoFillAddress:address_components];
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];

    }
     else if(request.tag==3)
     {
        if ([[responseJson valueForKey:@"status"] intValue] == 1)
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            [MMCommon showOnlyAlert:@"Success" :[responseJson valueForKey:@"dbresponse"]:self.navigationController];
            
          
        }
        else
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            [MMCommon showOnlyAlert:@"Sorry!" :[responseJson valueForKey:@"message"]:self.navigationController];
        }
    }
    else
    {
        
        if ([[responseJson valueForKey:@"status"] intValue] == 1)
        {
            [MMCommon showOnlyAlert:@"Success" :[responseJson valueForKey:@"dbresponse"]:self.navigationController];
            userInfo.pic_id=[responseJson valueForKey:@"imagepath"];
            NSString *ImageURL = [NSString stringWithFormat:@"%@ProfilePicture/%@",BASE_URL,userInfo.pic_id];
            [[SDImageCache sharedImageCache]clearMemory];
            [[SDImageCache sharedImageCache]clearDisk];
            [ProfileImageView sd_setImageWithURL:[NSURL URLWithString:ImageURL]];
            profileImageChanged=NO;
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];

            
        }
        else
        {
            [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
            [MMCommon showOnlyAlert:@"Sorry!" :[responseJson valueForKey:@"message"]:self.navigationController];
            profileImageChanged=NO;

        }
        
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
    [MMCommon showOnlyAlert:@"Sorry!" :@"Something Went Wrong.":self.navigationController];
}

#pragma mark - Method

-(IBAction)imagePickerCallBack:(id)sender
{
    
    UIActionSheet *actionphoto = [[UIActionSheet alloc] initWithTitle:@"Select" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    
    [actionphoto showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0)
    {
        
        [self openCamera];
        
        
    }
    if(buttonIndex == 1)
    {
        [self openGallery];
        
    }
    if(buttonIndex == 2)
    {
        
    }
    
    
    
    
}



-(void)openCamera
{
    gallery=NO;
    @try
    {
        UIImagePickerController *pickers = [[UIImagePickerController alloc] init];
        pickers.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickers.delegate = self;
        
        if(IS_IPAD)
        {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self presentViewController:pickers animated:NO completion:nil];
            }];
            
         
            
        }
        else{
            
            [self presentViewController:pickers animated:YES completion:nil];
        }
        
    }
    @catch (NSException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera Is Not Available  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
}
-(void)openGallery
{
    gallery=YES;
    @try
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
        if(IS_IPAD)
        {
            
         
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self presentViewController:picker animated:NO completion:nil];
            }];
           
        }
        else{
            
            [self presentViewController:picker animated:YES completion:nil];
            
            
        }
        
        
        
    }
    @catch (NSException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry !!" message:@"Gallery Access Denied. Please Change Access From Settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"editInfo-%@",editingInfo);
    profileImageChanged=YES;
    UIImage *image=[self optimize:selectedImage];
    
     profileBase64String = [UIImageJPEGRepresentation(image,0.9f)
               base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    ;


    [self dismissViewControllerAnimated:YES completion:NULL];

}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
{
    NSLog(@"editInfo-%@",info);
    profileImageChanged=YES;
//    UIImage *image=[self optimize:[]];
    ProfileImageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
//
    if (@available(iOS 11.0, *)) {
        profileBase64String=[info valueForKey:UIImagePickerControllerImageURL];
        NSLog(@"ImageURL-%@",[info valueForKey:UIImagePickerControllerImageURL]);

    } else {
       // profileBase64String=[info valueForKey:UIImagePickerControllerReferenceURL];
      //  ALAsset *assert=[info valueForKey:UIImagePickerControllerReferenceURL];
        PHAsset *assert=[info valueForKey:UIImagePickerControllerReferenceURL];
        [assert requestContentEditingInputWithOptions:[PHContentEditingInputRequestOptions new] completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
            NSURL *imageURL = contentEditingInput.fullSizeImageURL;
            NSLog(@"MediaURL-%@",imageURL);

        }];

    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
}
*/
-(UIImage*)optimize:(UIImage*)beforeooptimize
{
    float actualHeight = beforeooptimize.size.height;
    float actualWidth = beforeooptimize.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/480.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0;
        }
        else{
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [beforeooptimize drawInRect:rect];
    UIImage *afteroptimize = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return afteroptimize;
}




-(void)autoFillAddress:(NSArray*)array
{
    NSString *address=@"";
   for(int idx=0;idx<array.count;idx++)
   {
        if([[[[array objectAtIndex:idx]valueForKey:@"types"]objectAtIndex:0] isEqualToString:@"locality"])
        {
            address=[[array objectAtIndex:idx]valueForKey:@"long_name"];
        }
        else if ([[[[array objectAtIndex:idx]valueForKey:@"types"]objectAtIndex:0] isEqualToString:@"administrative_area_level_1"])
        {
            if([[MMCommon sharedInstance]isNullString:address])
            {
                address=[[array objectAtIndex:idx]valueForKey:@"long_name"];

            }
            else{
            address=[address stringByAppendingString:[NSString stringWithFormat:@", %@",[[array objectAtIndex:idx]valueForKey:@"long_name"]]];
        }
        }
        else if ([[[[array objectAtIndex:idx]valueForKey:@"types"]objectAtIndex:0] isEqualToString:@"country"])
        {
            if([[MMCommon sharedInstance]isNullString:address])
            {
                address=[[array objectAtIndex:idx]valueForKey:@"long_name"];

            }
            else{
                address=[address stringByAppendingString:[NSString stringWithFormat:@", %@",[[array objectAtIndex:idx]valueForKey:@"long_name"]]];
            }
        }
    }
    
    UITextField *field=(UITextField*)[containerScroll viewWithTag:7+100];
    field.text=address;
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        containerScroll.contentOffset = CGPointMake(0, field.frame.origin.y-30);
    } completion:NULL];
}



- (void)formDesign: (NSString *) updatedAttrValue {
    
    UILabel *label;
    UITextField *textField;

    NSString *lastControlTypeStr = @"";

    
    for (int count = 0; count<question.count; count++) {
        
        NSString *controlTypeStr = [[question objectAtIndex:count] valueForKey:@"attr_obj_typ"];
        
        SWITCH (lastControlTypeStr) {
            CASE(@""){
                label = [[UILabel alloc] initWithFrame:CGRectMake(10 * scaleFX, ProfileImageView.frame.origin.y+ProfileImageView.frame.size.height+count * 90, 300 * scaleFX, 30)];
                break;
            }
            CASE(@"text"){
                label = [[UILabel alloc] initWithFrame:CGRectMake(10 * scaleFX, (textField.frame.origin.y + textField.frame.size.height), 300 * scaleFX, 30)];
                break;
            }
            CASE(@"ziptext"){
                label = [[UILabel alloc] initWithFrame:CGRectMake(10 * scaleFX, (textField.frame.origin.y + textField.frame.size.height), 300 * scaleFX, 30)];
                break;
            }
            CASE(@"datepick"){

                label = [[UILabel alloc] initWithFrame:CGRectMake(10 * scaleFX, (textField.frame.origin.y + textField.frame.size.height), 300 * scaleFX, 30)];

                break;
            }
            CASE(@"select"){

                label = [[UILabel alloc] initWithFrame:CGRectMake(10 * scaleFX, (textField.frame.origin.y + textField.frame.size.height), 300 * scaleFX, 30)];

                break;
            }
//            case 4:
//                label = [[UILabel alloc] initWithFrame:CGRectMake(10 * scaleFX, (multiChoiceType.frame.origin.y + multiChoiceType.frame.size.height), 300 * scaleFX, 30)];
//                break;
            DEFAULT {
                break;
            }
        }
        
        
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 1;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        label.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
        label.text = [[question objectAtIndex:count] valueForKey:@"attr_name"];
        [containerScroll addSubview:label];
        
        SWITCH(controlTypeStr) {
            CASE(@"text")
            {
                textField = [[UITextField alloc] initWithFrame:CGRectMake(10 * scaleFX, (label.frame.origin.y + label.frame.size.height), 300 * scaleFX, 40)];
                textField.textColor = [UIColor blackColor];
                textField.font = [UIFont fontWithName:@"system" size:15];
                textField.backgroundColor=[UIColor whiteColor];
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
                textField.delegate = self;
                textField.text = [[[responseJson objectForKey:@"list"] objectAtIndex:count] objectForKey:@"attr_value"];
                textField.tag = count+100;
                [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

                
                [containerScroll addSubview:textField];
            
                break;
            }
            CASE(@"ziptext")
            {
                textField = [[UITextField alloc] initWithFrame:CGRectMake(10 * scaleFX, (label.frame.origin.y + label.frame.size.height), 300 * scaleFX, 40)];
                textField.textColor = [UIColor blackColor];
                textField.font = [UIFont fontWithName:@"system" size:15];
                textField.backgroundColor=[UIColor whiteColor];
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
                textField.delegate = self;
                textField.text = [[[responseJson objectForKey:@"list"] objectAtIndex:count] objectForKey:@"attr_value"];
                textField.keyboardType=UIKeyboardTypeNumberPad;
                [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                textField.tag =  count+100;

                UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
                [keyboardDoneButtonView setTintColor:[UIColor orangeColor]];
                
                [keyboardDoneButtonView sizeToFit];
                keyboardDoneButtonView.backgroundColor=[UIColor whiteColor];
                UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                  target:nil action:nil];
                
                UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                               style:UIBarButtonItemStyleBordered target:self
                                                                              action:@selector(doneClickedZipCode:)];
                
                doneButton.tag= count+100;
                
                [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexBarButton,doneButton, nil]];
                textField.inputAccessoryView = keyboardDoneButtonView;
                [containerScroll addSubview:textField];
                
                break;
            }
            CASE(@"datepick")
            {
             
                
                textField = [[UITextField alloc] initWithFrame:CGRectMake(10 * scaleFX, (label.frame.origin.y + label.frame.size.height), 300 * scaleFX, 40)];
                textField.textColor = [UIColor blackColor];
                textField.font = [UIFont fontWithName:@"system" size:15];
                textField.backgroundColor=[UIColor whiteColor];
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
                textField.delegate = self;
                textField.text = [[[responseJson objectForKey:@"list"] objectAtIndex:count] objectForKey:@"attr_value"];
                textField.tag =  count+100;
                [textField setEnabled:NO];
                
                
                [containerScroll addSubview:textField];
                
                UIButton *transparentBtn = [[UIButton alloc] init];
                transparentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [transparentBtn addTarget:self action:@selector(datePickCallBack:)  forControlEvents:UIControlEventTouchUpInside];
                transparentBtn.backgroundColor = [UIColor clearColor];
                transparentBtn.tag =  count+100;
                transparentBtn.frame = textField.frame;

                [containerScroll addSubview:transparentBtn];
                
                break;
            }
            CASE(@"select"){


                textField = [[UITextField alloc] initWithFrame:CGRectMake(10 * scaleFX, (label.frame.origin.y + label.frame.size.height), 300 * scaleFX, 40)];
                textField.textColor = [UIColor blackColor];
                textField.font = [UIFont fontWithName:@"system" size:15];
                textField.backgroundColor=[UIColor whiteColor];
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
                textField.delegate = self;
                textField.text = [[[responseJson objectForKey:@"list"] objectAtIndex:count] objectForKey:@"attr_value"];
                textField.tag =  count+100;
                [textField setEnabled:NO];
                [containerScroll addSubview:textField];
                
                if([[[responseJson objectForKey:@"list"] objectAtIndex:count] objectForKey:@"column_value"] > 0){

                    NSMutableArray *tempOption = [[NSMutableArray alloc]init];
                    NSMutableArray *option = [[NSMutableArray alloc]init];
                    NSMutableArray *finalOptionArray = [[NSMutableArray alloc]init];
                    
                    tempOption = [[[[[responseJson objectForKey:@"list"] objectAtIndex:count] objectForKey:@"column_value"] componentsSeparatedByString:@"|"] mutableCopy];
                    
                    
                    for (int i = 0; i<tempOption.count; i++) {
                        NSMutableArray *countArray = [[[tempOption objectAtIndex:i] componentsSeparatedByString:@","] mutableCopy];
                        
                        if ([[[[responseJson objectForKey:@"list"] objectAtIndex:count] objectForKey:@"lvl"] isEqualToString:@""]) {
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                            
                            [dict setValue:[countArray objectAtIndex:0] forKey:@"ownId"];
                            [dict setValue:[countArray objectAtIndex:1] forKey:@"ownValue"];
                            
                            [option addObject:dict];
                        }
                        else{
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                            if([[[[responseJson objectForKey:@"list"] objectAtIndex:count] objectForKey:@"attr_name"] isEqualToString:@"Country"]){
                                
                                [dict setValue:[countArray objectAtIndex:0] forKey:@"parentId"];
                                [dict setValue:[countArray objectAtIndex:1] forKey:@"ownId"];
                                [dict setValue:[countArray objectAtIndex:2] forKey:@"ownValue"];
                            }else{
                                [dict setValue:[countArray objectAtIndex:1] forKey:@"parentId"];
                                [dict setValue:[countArray objectAtIndex:0] forKey:@"ownId"];
                                [dict setValue:[countArray objectAtIndex:2] forKey:@"ownValue"];
                            }
                            
                            [option addObject:dict];
                        }
                        
                        // To display the selected value

                            if ([[[option objectAtIndex:i]valueForKey:@"ownId"] isEqualToString:[[question objectAtIndex:count] objectForKey:@"attr_value"]]) {
                            NSLog(@"string contains bla!");
                            textField.text = [[option objectAtIndex:i] valueForKey:@"ownValue"];
                        } else {
                            NSLog(@"string does not contain bla");
                        }
                        

                        if([[[option objectAtIndex:i]valueForKey:@"parentId"] isEqualToString:[[question objectAtIndex:count] objectForKey:@"prev_attr_value"]]) {
                        
                                [finalOptionArray addObject:[option objectAtIndex:i]];
                            }

                         else if ([[[question objectAtIndex:count] objectForKey:@"prev_attr_value"] isEqualToString:@""]){
                        
                                [finalOptionArray addObject:[option objectAtIndex:i]];
                            }

                    }
                    
                    CustomButton *transparentSelectBtn = [[CustomButton alloc] init];
                    transparentSelectBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
                    [transparentSelectBtn setExclusiveTouch:NO];
                    [transparentSelectBtn setOptionData:finalOptionArray];
                    [transparentSelectBtn setFieldValue:[[[responseJson objectForKey:@"list"] objectAtIndex:count] objectForKey:@"attr_name"]];
                    transparentSelectBtn.tag= count+100;
                    [transparentSelectBtn addTarget:self action:@selector(selectCallBack:)  forControlEvents:UIControlEventTouchUpInside];
                    
                    transparentSelectBtn.backgroundColor = [UIColor clearColor];
                    transparentSelectBtn.frame = textField.frame;
                    [containerScroll addSubview:transparentSelectBtn];
                    

                }
                break;
            }
//            case 4:
//                dummyLabelChk = [[UILabel alloc] initWithFrame:CGRectMake(10 * scaleFX, (label.frame.origin.y + label.frame.size.height), 300 * scaleFX, 1)];
//                dummyLabelChk.backgroundColor = [UIColor clearColor];
//                dummyLabelChk.textAlignment = NSTextAlignmentLeft;
//                dummyLabelChk.textColor = [UIColor blackColor];
//                dummyLabelChk.numberOfLines = 1;
//                dummyLabelChk.layer.borderColor = [UIColor lightGrayColor].CGColor;
//                dummyLabelChk.layer.borderWidth = 1.0;
//                dummyLabelChk.layer.masksToBounds = YES;
//                dummyLabelChk.layer.cornerRadius = 5.0;
//                dummyLabelChk.tag = count - 900;
//                dummyLabelChk.hidden = YES;
//                [containerScroll addSubview:dummyLabelChk];
//
//                if([[[dynamicJson objectForKey:@"result"] objectAtIndex:count] objectForKey:@"options"] > 0){
//
//                    NSMutableArray *option = [[NSMutableArray alloc]init];
//                    option = [[[[[dynamicJson objectForKey:@"result"] objectAtIndex:count] objectForKey:@"options"] componentsSeparatedByString:@"|"] mutableCopy];
//
//                    for(int i = 0, j = 1; i<option.count; i++, j=j+40){
//                        multiChoiceType = [[UIView alloc] initWithFrame:CGRectMake(0 * scaleFX, (dummyLabelChk.frame.origin.y + dummyLabelChk.frame.size.height) + j, 320  * scaleFX, 40)];
//                        multiChoiceType.backgroundColor = [UIColor clearColor];
//                        [containerScroll addSubview:multiChoiceType];
//
//                        UIButton *chkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                        [chkBtn addTarget:self action:@selector(checkBoxCallBack1:) forControlEvents:UIControlEventTouchUpInside];
//                        [chkBtn setImage:[UIImage imageNamed:@"cb_box_off"] forState:UIControlStateNormal];
//                        [chkBtn setImage:[UIImage imageNamed:@"cb_box_on"] forState:UIControlStateSelected];
//                        chkBtn.frame = CGRectMake(10  * scaleFX, 5, 25, 25);
//                        //                        chkBtn.accessibilityValue = [[option objectAtIndex:i] valueForKey:@"optionvalue"];
//                        chkBtn.tag = count - 900;
//                        [multiChoiceType addSubview:chkBtn];
//
//                        UILabel *dispLabel = [[UILabel alloc] initWithFrame:CGRectMake(50  * scaleFX, 5, 220  * scaleFX, 30)];
//                        dispLabel.backgroundColor = [UIColor clearColor];
//                        dispLabel.textAlignment = NSTextAlignmentLeft;
//                        dispLabel.textColor = [UIColor blackColor];
//                        dispLabel.numberOfLines = 1;
//                        dispLabel.text = [option objectAtIndex:i];
//                        [multiChoiceType addSubview:dispLabel];
//                    }
//                }
//                break;
            DEFAULT {
                break;
            }
        }
        
        lastControlTypeStr = controlTypeStr;
    }
    
    /// ADD SUBMIT BUTTON ///
    
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn addTarget:self action:@selector(submitCallBack:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = [UIColor redColor];
    
    SWITCH([[question objectAtIndex:question.count-1] valueForKey:@"attr_obj_typ"]) {
        CASE(@"text"){
            submitBtn.frame = CGRectMake(10 * scaleFX, textField.frame.origin.y + textField.frame.size.height, 300 * scaleFX, 50);
            break;
        }
        CASE(@"ziptext"){
            submitBtn.frame = CGRectMake(10 * scaleFX, textField.frame.origin.y + textField.frame.size.height, 300 * scaleFX, 50);
            break;
        }
        CASE(@"datepick"){
            submitBtn.frame = CGRectMake(10 * scaleFX, textField.frame.origin.y + datePicker.frame.size.height, 300 * scaleFX, 50);
            break;
        }
        CASE(@"select"){
            submitBtn.frame = CGRectMake(10 * scaleFX, textField.frame.origin.y + textField.frame.size.height+20, 300 * scaleFX, 50);
            break;
        }
//        case 4:
//            submitBtn.frame = CGRectMake(10 * scaleFX, multiChoiceType.frame.origin.y + multiChoiceType.frame.size.height, 300 * scaleFX, 50);
//            break;
        DEFAULT {
            break;
        }
    }

    
    submitBtn.layer.cornerRadius = 5.0;
    [submitBtn setTitle:@"Save Changes" forState:UIControlStateNormal];
    [containerScroll addSubview:submitBtn];
    
    containerScroll.contentSize = CGSizeMake(1, (submitBtn.frame.origin.y + submitBtn.frame.size.height + 10)  * scaleFX);
}
-(void)datePickCallBack:(UIButton*) sender
{
    [_currentResponder resignFirstResponder];
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        containerScroll.contentOffset = CGPointMake(0, sender.frame.origin.y-30);
    } completion:NULL];
    CGRect pickerFrame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height-200.0,[UIScreen mainScreen].bounds.size.width,200.0);
    
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.tag = [sender tag];
    
    datePicker.maximumDate = [NSDate date];
    toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, pickerFrame.origin.y-40, 320, 44)];
    [toolBar setTintColor:[UIColor orangeColor]];
    toolBar.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate:)];
    doneBtn.tag=sender.tag;
    
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    cancelBtn.tag=sender.tag;
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelBtn,space,doneBtn,nil]];
    
    
    
    
    
    [self.view addSubview:toolBar];
    [self.view addSubview:datePicker];
}
-(NSString*)getDataFromTextField
{
    NSString *finalResult;
    NSMutableArray *arrayResult=[[NSMutableArray alloc]init];
    for(int idx=0;idx<question.count;idx++)
    {
        UITextField *fieldValue=[containerScroll viewWithTag:idx+100];
        
        if([[MMCommon sharedInstance]isNullString:fieldValue.text]&&[[[question valueForKey:@"required_field"]objectAtIndex:idx] isEqualToString:@"1"])
        {
            [MMCommon showOnlyAlert:@"Warning!" :[NSString stringWithFormat:@"%@ can't be blank",[[question valueForKey:@"attr_name"]objectAtIndex:idx]]:self.navigationController];
            
        }
        else{
            
            NSString *attr_id=[NSString stringWithFormat:@"%d",[[[question valueForKey:@"attr_id"] objectAtIndex:idx]intValue]];
            if([[question objectAtIndex:idx]valueForKey:@"column_value"]>0&& [[[question objectAtIndex:idx]valueForKey:@"attr_obj_typ"] isEqualToString:@"select"])
            {
                NSString *selectedId;
                NSMutableArray *tempOption = [[NSMutableArray alloc]init];
                NSMutableArray *option = [[NSMutableArray alloc]init];
                NSMutableArray *finalOptionArray = [[NSMutableArray alloc]init];
                
                tempOption = [[[[question objectAtIndex:idx]valueForKey:@"column_value"] componentsSeparatedByString:@"|"] mutableCopy];
                
                
                for (int i = 0; i<tempOption.count; i++) {
                    NSMutableArray *countArray = [[[tempOption objectAtIndex:i] componentsSeparatedByString:@","] mutableCopy];
                    
                    if ([[[question objectAtIndex:idx]valueForKey:@"lvl"] isEqualToString:@""]) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        
                        [dict setValue:[countArray objectAtIndex:0] forKey:@"ownId"];//to send
                        [dict setValue:[countArray objectAtIndex:1] forKey:@"ownValue"];//to show
                        
                        [option addObject:dict];
                    }
                    else{
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        if([[[question objectAtIndex:idx]valueForKey:@"attr_name"]  isEqualToString:@"Country"]){
                            
                            [dict setValue:[countArray objectAtIndex:0] forKey:@"parentId"];
                            [dict setValue:[countArray objectAtIndex:1] forKey:@"ownId"];//to send
                            [dict setValue:[countArray objectAtIndex:2] forKey:@"ownValue"];//toshow
                        }else{
                            [dict setValue:[countArray objectAtIndex:1] forKey:@"parentId"];
                            [dict setValue:[countArray objectAtIndex:0] forKey:@"ownId"];//tosend
                            [dict setValue:[countArray objectAtIndex:2] forKey:@"ownValue"];//toshow
                        }
                        
                        [option addObject:dict];
                    }
                    
                    
                    
                    
                    if([[[option objectAtIndex:i]valueForKey:@"parentId"] isEqualToString:[[question objectAtIndex:idx] objectForKey:@"prev_attr_value"]]) {
                        
                        [finalOptionArray addObject:[option objectAtIndex:i]];
                    }
                    
                    else if ([[[question objectAtIndex:idx] objectForKey:@"prev_attr_value"] isEqualToString:@""]){
                        
                        [finalOptionArray addObject:[option objectAtIndex:i]];
                    }
                    
                    
                    
                }
                
                for(int k=0;k<finalOptionArray.count;k++)
                {
                    if ([[[finalOptionArray objectAtIndex:k]valueForKey:@"ownValue"] isEqualToString:fieldValue.text]) {
                        NSLog(@"string contains bla!");
                        selectedId = [[finalOptionArray objectAtIndex:k] valueForKey:@"ownId"];
                        break;
                    } else {
                        NSLog(@"string does not contain bla");
                        //                            optionSelect.text = @"Select";
                    }
                }
                
                NSString *stringResult=[NSString stringWithFormat:@"%@^^%@",attr_id,selectedId];
                [arrayResult addObject:stringResult];
                
                
                
            }
            else{
                NSString *stringResult=[NSString stringWithFormat:@"%@^^%@",attr_id,fieldValue.text];
                [arrayResult addObject:stringResult];
            }
            
        }
    }
    finalResult=[arrayResult componentsJoinedByString:@"|"];
    return finalResult;
}

-(void)ShowSelectedDate:(UIBarButtonItem*) sender
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    UITextField *field=[containerScroll viewWithTag:sender.tag];
    field.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    datePicker.hidden=YES;
    toolBar.hidden=YES;
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        containerScroll.contentOffset = CGPointMake(0, 0);
    } completion:NULL];
    
    
    
    
}

-(void)cancelAction
{
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        containerScroll.contentOffset = CGPointMake(0, 0);
    } completion:NULL];
    
    datePicker.hidden=YES;
    toolBar.hidden=YES;
}

- (void) selectCallBack:(CustomButton *)sender{
    
    UIAlertController *actionInitial = [UIAlertController alertControllerWithTitle:@"Please Select"
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
    actionInitial.view.tag = 1;
    for (int j =0 ; j<[[sender optionData]count]; j++)
    {
        NSString *titleString = [[[sender optionData] objectAtIndex:j] valueForKey:@"ownValue"];
        UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            UITextField *tmpfld = (UITextField *)[containerScroll viewWithTag:sender.tag];
            tmpfld.text = [[[sender optionData] objectAtIndex:j] valueForKey:@"ownValue"];
        }];
        
        [actionInitial addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
        [self dismissViewControllerAnimated:actionInitial completion:nil];
    }];
    
    [actionInitial addAction:cancelAction];
    [self presentViewController:actionInitial animated:YES completion:nil];
}



-(void)doneClickedZipCode:(UIBarButtonItem*)sender
{
    UITextField *fieldZip=[containerScroll viewWithTag:sender.tag];
    if(![[MMCommon sharedInstance]isNullString:fieldZip.text])
    {
        [self getAddressFromZipcode:fieldZip.text];
    }
    else{
    }
    
    [_currentResponder resignFirstResponder];
    
}
-(void)getAddressFromZipcode:(NSString*)zipcode
{
    [[MMCommon sharedInstance]showfullScreenIndicator:YES animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyDLbtpVesVpXDK5srPAG-3HlVrZYUSuKu8",zipcode]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    request.delegate=self;
    request.tag=2;
    [request startAsynchronous];
    
}


#pragma mark - Textfield Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentResponder=textField;
    datePicker.hidden=YES;
    toolBar.hidden=YES;
    UIView * view=textField;
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        containerScroll.contentOffset = CGPointMake(0, view.frame.origin.y-30);
    } completion:NULL];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        containerScroll.contentOffset = CGPointMake(0, 0);
    } completion:NULL];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    int trueIndex=(int)textField.tag-100;
    NSString *attr_val_format=[[question valueForKey:@"attr_val_format"] objectAtIndex:trueIndex];
    NSString *type=[[question valueForKey:@"attr_obj_typ"] objectAtIndex:trueIndex];
    if(![[MMCommon sharedInstance]isNullString:attr_val_format]&&![type isEqualToString:@"ziptext"])
    {
      //  NSLog(@"textfield-%lu",textField.text.length);
      //  NSLog(@"range-%lu",(unsigned long)range.length);
       // NSLog(@"string-%@",searchStr);
        
        
        if([[MMCommon  sharedInstance] validateFieldRegex:attr_val_format:searchStr])
        {
            return YES;
        }
        else{
            return NO;
            
        }
    }
    else if ([type isEqualToString:@"ziptext"])
    {
        if (textField.text.length >= 6 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {
            return YES;
        }
        
    }
    else{
        return YES;
        
    }
    return nil;
}

-(void)textFieldDidChange :(UITextField *)theTextField
{
    
}


//- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
//{
//    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
//    dateFormat.dateStyle=NSDateFormatterMediumStyle;
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//
//    UILabel *tmpLbl = (UILabel *)[containerScroll viewWithTag:datePicker.tag];
//    tmpLbl.text = [dateFormat stringFromDate:datePicker.date];
//    datePicker.hidden = YES;
//}




@end
