//
//  EditProfileViewController.h
//  Divine2Logic
//
//  Created by Apple on 21/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

#import <UIKit/UIKit.h>
#import "MMCommon.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "GlobalStore.h"
#import "CustomButton.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImageView+WebCache.h"

@interface EditProfileViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    GlobalStore *userInfo;
    NSDictionary *responseJson;
    float scaleFX, scaleFY;
    NSMutableArray *question;
    
    IBOutlet UIScrollView *dynamicFormScroll;
    IBOutlet UIScrollView *containerScroll;
    IBOutlet UIImageView *ProfileImageView;
    UIDatePicker *datePicker;
    UILabel *showDate;
    UIToolbar *toolBar;
    NSString *profileBase64String;
    bool profileImageChanged;
    bool gallery;
}
@property(nonatomic,assign)id currentResponder;
@property(retain,nonatomic) NSString *profileImageString;
@end
