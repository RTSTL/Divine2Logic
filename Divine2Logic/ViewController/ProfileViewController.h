//
//  ProfileViewController.h
//  Divine2Logic
//
//  Created by Apple on 08/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTableViewCell.h"
#import "MMCommon.h"
#import "UIImageView+WebCache.h"
#import "GlobalStore.h"

@interface ProfileViewController : UIViewController
{
    NSArray *firstSectionItem, *secondSectionItem, *thirdSectionItem, *fourthSectionItem;
    NSArray *sectionTitle;
    IBOutlet UIImageView *ProfileImageView;
    GlobalStore *userInfo;
    IBOutlet UITableView *profileTable;
    
}
@end
