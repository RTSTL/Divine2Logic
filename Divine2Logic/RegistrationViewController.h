//
//  RegistrationViewController.h
//  Divine2Logic
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController
{
    IBOutlet UIScrollView *mainContainerScroll;
    IBOutlet UIScrollView *fieldContainerScroll;
    IBOutlet UIView *containerView;
    IBOutlet UITextField *initial;
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *dateOfBirth;
    IBOutlet UITextField *email;
    IBOutlet UITextField *mobileNo;
    IBOutlet UITextField *userName;
    IBOutlet UITextField *password;
    IBOutlet UITextField *confPassword;
    
}
@end
