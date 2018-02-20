//
//  ForgotPasswordViewController.h
//  Divine2Logic
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCommon.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "ResetPasswordViewController.h"

@interface ForgotPasswordViewController : UIViewController
{
    NSDictionary *forgetPasswdJson;
    
    IBOutlet UIScrollView *containerScroll;
    IBOutlet UIView *containerView;
    IBOutlet UITextField *mobileTxtFld;
    
}
@end
