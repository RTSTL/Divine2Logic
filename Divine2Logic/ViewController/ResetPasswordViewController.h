//
//  ResetPasswordViewController.h
//  Divine2Logic
//
//  Created by Apple on 15/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCommon.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "LoginViewController.h"

@interface ResetPasswordViewController : UIViewController
{
    NSDictionary *forgetResetPasswdJson;
    
    IBOutlet UIScrollView *containerScroll;
    IBOutlet UIView *otpView;
    IBOutlet UIView *passwordView;
    IBOutlet UIView *confPasswordView;
    IBOutlet UITextField *otpText;
    IBOutlet UITextField *passwordText;
    IBOutlet UITextField *confPasswordText;
}
@property(nonatomic,retain)NSString *cellPhNo;

@end
