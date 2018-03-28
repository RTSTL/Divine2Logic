//
//  CustomButton.h
//  Divine2Logic
//
//  Created by Apple on 23/02/18.
//  Copyright © 2018 Rtstl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton
{
    id optionData;
    id fieldValue;
}

@property (nonatomic, readwrite, retain) id optionData;
@property (nonatomic, readwrite, retain) id fieldValue;
@end
