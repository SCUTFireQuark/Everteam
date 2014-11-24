//
//  BQMemoModel.h
//  PersonalMemo
//
//  Created by 蔡家勋 on 14/11/16.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQMemoModel : NSObject

@property(strong, nonatomic) NSDictionary *normalState;
@property(strong, nonatomic) NSDictionary *editState;
@property(strong, nonatomic) NSDictionary *trash;
@property(strong, nonatomic) NSDictionary *moveToTrash;
@property(strong, nonatomic) NSDictionary *themeCreateView;
@property(strong, nonatomic) NSDictionary *themeBtn;
@property(strong, nonatomic) NSDictionary *themeCreateBtn;
@property(strong, nonatomic) NSDictionary *themeDeleteBtn;
@property(strong, nonatomic) NSDictionary *timePicker;
@property(strong, nonatomic) NSDictionary *completeAlert;
@property(strong, nonatomic) NSDictionary *createThemeAlert;
@property(strong, nonatomic) NSDictionary *backgroundSize;
@property(strong, nonatomic) NSDictionary *deleteMemo;

@end
