//
//  ViewController.m
//  Divine2Logic
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [MMCommon showOnlyAlert:@"Sorry!" :@"Password Required" :self.navigationController];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(login) userInfo:nil repeats:NO];
}

-(void)login
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"logged_in"])
    {
        UITabBarController *dashboard =(UITabBarController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mainTabbar"];
        
        [self.navigationController pushViewController:dashboard animated:YES];
    }
    else{
        UIViewController *viewcontroller =(UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
  
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
