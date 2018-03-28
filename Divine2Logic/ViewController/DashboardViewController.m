//
//  DashboardViewController.m
//  Divine2Logic
//
//  Created by Apple on 08/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userInfo=[GlobalStore getInstance];
    
    userInfo.id_enc = [KFKeychain loadObjectForKey:@"id_enc"];;
    userInfo.member_id = [KFKeychain loadObjectForKey:@"id_enc"];
    userInfo.member_type = [KFKeychain loadObjectForKey:@"id_enc"];
    userInfo.name = [KFKeychain loadObjectForKey:@"id_enc"];
    userInfo.org_mem_id = [KFKeychain loadObjectForKey:@"id_enc"];
    userInfo.pic_id = [KFKeychain loadObjectForKey:@"pic_id"];

    
    
    [self performRequestForDashboardItem];
    categoryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
#pragma mark-Table Implementation

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [categoryArray count];
}

-(CategoryListingTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"CategoryListing";
    
    CategoryListingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell == nil) {
        cell = [[CategoryListingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *prependStr = [NSString stringWithFormat:@"data:image/png;base64,%@",[[categoryArray objectAtIndex:indexPath.row] valueForKey:@"pic_content"]];
    NSURL *url = [NSURL URLWithString:prependStr];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *ret = [UIImage imageWithData:imageData];
    
    cell.categoryImageView.image = ret;
    cell.categoryTitle.text = [[categoryArray objectAtIndex:indexPath.row] valueForKey:@"itemtype_nm"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark- API Integration

-(void)performRequestForDashboardItem
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMCommon showOnlyAlert:@"Sorry!" :@"Check Your Internet Connection.":self.navigationController];
    }
    else{
        [[MMCommon sharedInstance] showfullScreenIndicator:YES animated:YES];
        
        NSString *requestStr = @"MSItemType/GetMSItemType";
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,requestStr]]];
        
        request.delegate=self;
        [request setUseSessionPersistence:NO];
        
        [request addPostValue:@"" forKey:@"itemtype_id_enc"];
        
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    
    dashboardJson = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([[dashboardJson valueForKey:@"status"] intValue] == 1)
    {
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
        
        categoryArray = [[NSMutableArray alloc]init];
        categoryArray = [dashboardJson objectForKey:@"list"];
        
        [categoryTableView reloadData];
    }
    else
    {
        [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
        [MMCommon showOnlyAlert:@"Sorry!" :[dashboardJson valueForKey:@"message"]:self.navigationController];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[MMCommon sharedInstance] showfullScreenIndicator:NO animated:YES];
    [MMCommon showOnlyAlert:@"Sorry!" :@"Something Went Wrong.":self.navigationController];
}

@end
