//
//  BQThemeCreationView.h
//  PersonalMemo
//
//  Created by River on 14-10-7.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQViewController.h"
@interface BQThemeCreationView : UIView
@property(nonatomic) CGRect labelRect;
@property(nonatomic) CGRect textRect;
@property(nonatomic) CGRect confirmRect;
@property(nonatomic) CGRect cancelRect;

@property(strong, nonatomic) UIImageView *themeCreatePanel;
@property(strong, nonatomic) UILabel *label;
@property(strong, nonatomic) UITextField * textField ;
@property(strong, nonatomic) UIButton * confirmBtn ;
@property(strong, nonatomic) UIButton * cancelBtn ;

- (void)reLoadText;

@end
