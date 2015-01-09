//
//  BQMemoModel.m
//  PersonalMemo
//
//  Created by 蔡家勋 on 14/11/16.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import "BQMemoModel.h"

@implementation BQMemoModel

- (id)init
{
    self = [super init];
    if (self) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ViewParameter" ofType:@"plist"];
        NSDictionary *dataOfPlist = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        self.normalState = [dataOfPlist objectForKey:@"normalState"];
        self.editState = [dataOfPlist objectForKey:@"editState"];
        self.trash = [dataOfPlist objectForKey:@"trash"];
        self.moveToTrash = [dataOfPlist objectForKey:@"moveToTrash"];
        self.themeCreateView = [dataOfPlist objectForKey:@"themeCreateView"];
        self.themeCreateBtn = [dataOfPlist objectForKey:@"themeCreateBtn"];
        self.themeBtn = [dataOfPlist objectForKey:@"themeBtn"];
        self.themeDeleteBtn = [dataOfPlist objectForKey:@"themeDeleteBtn"];
        self.timePicker = [dataOfPlist objectForKey:@"timePicker"];
        self.completeAlert = [dataOfPlist objectForKey:@"completeAlert"];
        self.createThemeAlert = [dataOfPlist objectForKey:@"createThemeAlert"];
        self.backgroundSize = [dataOfPlist objectForKey:@"backgroundSize"];
        self.deleteMemo = [dataOfPlist objectForKey:@"deleteMemo"];

    }
    return self;
}

@end
