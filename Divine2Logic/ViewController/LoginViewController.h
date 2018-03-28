//
//  LoginViewController.h
//  Divine2Logic
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCommon.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "GlobalStore.h"

@interface LoginViewController : UIViewController
{
    NSDictionary *loginJson;
    GlobalStore *userInfo;
    
    IBOutlet UIView *loginContainer;
    IBOutlet UITextField *userID;
    IBOutlet UITextField *password;
    IBOutlet UIScrollView *containerScrollView;
    
}
@end
