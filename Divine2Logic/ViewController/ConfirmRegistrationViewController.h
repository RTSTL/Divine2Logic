//
//  ConfirmRegistrationViewController.h
//  Divine2Logic
//
//  Created by Apple on 20/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCommon.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "GlobalStore.h"

@interface ConfirmRegistrationViewController : UIViewController <UITextFieldDelegate>
{
    NSDictionary *responseJson;
    GlobalStore *userInfo;
    
    IBOutlet UIView *enterOTPView;
    IBOutlet UIScrollView *containerScrollView;
    IBOutlet UITextField *phoneNoTextFld;
    
}
@end
