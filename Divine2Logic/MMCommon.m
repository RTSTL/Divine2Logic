//
//  MMCommon.m
//  MusicApp
//
//  Created by Sayantan Thakur on 26/05/15.
//  Copyright (c) 2015 unified infotech. All rights reserved.
//

#import "MMCommon.h"

@implementation MMCommon

+ (MMCommon *)sharedInstance
{
    static MMCommon *sharedInstance_ = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance_ = [[MMCommon alloc] init];
        //  sharedInstance_.appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    });
    return sharedInstance_;
    
}



-(BOOL)isNullString:(NSString*)_inputString
{
    
    NSString *InputString=_inputString;
    
    //InputString=[NSString stringWithFormat:@"%@",_inputString];
    if( (InputString == nil) ||(InputString ==(NSString *)[NSNull null])||([InputString isEqual:nil])||([InputString length] == 0)||([InputString isEqualToString:@""])||([InputString isEqualToString:@"(NULL)"])||([InputString isEqualToString:@"<NULL>"])||([InputString isEqualToString:@"<null>"]||([InputString isEqualToString:@"(null)"])||([InputString isEqualToString:@""]))
       
       )
        return YES;
    else
        return NO ;
    
}

- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
    
}

+(void) showOnlyAlert:(NSString*)title :(NSString*)message :(UIViewController*)viewController
{
//    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark-FullScreenIndicator
-(void)showfullScreenIndicator:(BOOL)indicator animated:(BOOL)animated
{
    UIWindow *window=[[UIApplication sharedApplication] delegate].window;
    if (!self.indicatorView) {
        self.indicatorView =[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.indicatorView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
        //  [self.appDelegate.window addSubview:self.indicatorView];
        [window addSubview:self.indicatorView];
        
        self.uploadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.uploadingIndicator.frame=CGRectMake((self.indicatorView.frame.size.width-34)/2, (self.indicatorView.frame.size.height-34)/2, 34, 34);
        self.uploadingIndicator.center = self.indicatorView.center;
        [self.indicatorView addSubview:self.uploadingIndicator];
        
        self.indicatorView.alpha = 0.0f;
    }
    
    if (indicator) {
        //NSLog(@"show : %s",__PRETTY_FUNCTION__);
        [self.uploadingIndicator startAnimating];
        // [self.appDelegate.window bringSubviewToFront:self.indicatorView];
        [window bringSubviewToFront:self.indicatorView];
        
        if (animated) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            self.indicatorView.alpha = 1.0f;
            [UIView commitAnimations];
        }
        else {
            self.indicatorView.alpha = 1.0f;
        }
    }
    else {
        //NSLog(@"hide : %s",__PRETTY_FUNCTION__);
        [self.uploadingIndicator stopAnimating];
        if (animated) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            self.indicatorView.alpha = 0.0f;
            [UIView commitAnimations];
        }
        else {
            self.indicatorView.alpha = 0.0f;
        }
    }
}



@end
