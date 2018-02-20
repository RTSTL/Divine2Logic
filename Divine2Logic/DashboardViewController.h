//
//  DashboardViewController.h
//  Divine2Logic
//
//  Created by Apple on 08/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCommon.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "CategoryListingTableViewCell.h"

@interface DashboardViewController : UIViewController
{
    NSDictionary *dashboardJson;
    NSMutableArray *categoryArray;
    IBOutlet UITableView *categoryTableView;
}
@end
