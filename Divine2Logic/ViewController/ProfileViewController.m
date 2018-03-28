//
//  ProfileViewController.m
//  Divine2Logic
//
//  Created by Apple on 08/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [GlobalStore getInstance];

    
    ProfileImageView.layer.cornerRadius=ProfileImageView.frame.size.width/2.0;
    ProfileImageView.clipsToBounds=YES;
    
    firstSectionItem = [NSArray arrayWithObjects:@"My Orders", @"Delivery Address", nil];
    secondSectionItem = [NSArray arrayWithObjects:@"Wallet", @"Transaction Details", @"Saved Cards", nil];
    thirdSectionItem = [NSArray arrayWithObjects:@"Change Password", nil];
    fourthSectionItem = [NSArray arrayWithObjects:@"Notification", nil];
    sectionTitle = [NSArray arrayWithObjects:@"SHOPPING", @"PAYMENT SETTINGS", @"SECURITY & SETTINGS", @"GENERAL", nil];
    
    UIView *btnContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 50)];
    UIButton *logOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [logOut addTarget:self action:@selector(logOutCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [logOut setImage:[UIImage imageNamed:@"signout_button"] forState:UIControlStateNormal];
    float X_Co = (self.view.frame.size.width - 250)/2;
    [logOut setFrame:CGRectMake(X_Co, 5, 250, 35)];
    [btnContainer addSubview:logOut];
    [profileTable setTableFooterView:btnContainer];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
    NSString *ImageURL = [NSString stringWithFormat:@"%@ProfilePicture/%@",BASE_URL,userInfo.pic_id];
    [ProfileImageView sd_setImageWithURL:[NSURL URLWithString:ImageURL]];
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) logOutCallBack:(id)sender {
    
    NSLog(@"Clicked....");
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, profileTable.bounds.size.width, 30)];
        [headerView setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:187.0/255.0 blue:164.0/255.0 alpha:1]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, profileTable.bounds.size.width - 10, 18)];
    label.text = [sectionTitle objectAtIndex:section];
    label.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionTitle count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if(section == 0)
        return [firstSectionItem count];
    else if(section == 1)
        return [secondSectionItem count];
    else if(section == 2)
        return [thirdSectionItem count];
    else if(section == 3)
        return [fourthSectionItem count];
    else
        return 0;
}

-(ProfileTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"profile";

    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell == nil) {
        cell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0){
        cell.iconLabel.text = [firstSectionItem objectAtIndex:indexPath.row];
        NSString *tempImage = [[[firstSectionItem objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"_"] lowercaseString];
        cell.iconImage.image = [UIImage imageNamed: tempImage];
    }
    else if(indexPath.section == 1){
        cell.iconLabel.text = [secondSectionItem objectAtIndex:indexPath.row];
        NSString *tempImage = [[[secondSectionItem objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"_"] lowercaseString];
        cell.iconImage.image = [UIImage imageNamed: tempImage];
    }
    else if(indexPath.section == 2){
        cell.iconLabel.text = [thirdSectionItem objectAtIndex:indexPath.row];
        NSString *tempImage = [[[thirdSectionItem objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"_"] lowercaseString];
        cell.iconImage.image = [UIImage imageNamed: tempImage];
    }
    else if(indexPath.section == 3){
        cell.iconLabel.text = [fourthSectionItem objectAtIndex:indexPath.row];
        NSString *tempImage = [[[fourthSectionItem objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"_"] lowercaseString];
        cell.iconImage.image = [UIImage imageNamed: tempImage];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)editProfileCallBack:(id)sender {
    
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
