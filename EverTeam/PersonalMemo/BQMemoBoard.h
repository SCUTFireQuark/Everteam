//
//  BQMemoBoard.h
//  PersonalMemo
//
//  Created by River on 14-10-7.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STAppDelegate.h"
#import "MemoXMLParser.h"
#import "BQMemo.h"
#import "BQTheme.h"
#import "Memo.h"
#import "Theme.h"

@interface BQMemoBoard : NSObject

@property(strong, nonatomic) NSMutableArray *themeArray;  //记录所有的主题
@property(strong, nonatomic) NSMutableArray *memoArray;   //记录当前主题下的所有便签
@property(strong, nonatomic) BQTheme *currentTheme;       //记录当前主题

- (void)loadMemo;
- (void)updateMemoOrderWithTitle:(NSString *)summary newOrder:(NSString *)order;
- (void)removeMemoInDataBaseWithMemoTitle:(NSString *)summary;
- (void)createThemeInDataBase:(BQTheme *)theme;
- (void)updateMemoContextWithTheme:(NSString *)theme andOrder:(NSString *)order newSummary:(NSString *)summary newDetail:(NSString *)detail;
- (void)switchThemeAction:(BQTheme *)theme;
- (void)removeThemeInDataBaseWithThemeName:(NSString *)name;
- (void)removeAllMemosInTheme:(NSString *)themeName;
- (BOOL)isDataBaseContainMemoWithSummary:(NSString *)summaryToCheck;
- (BOOL)isDataBaseContainMemoWithSummary:(NSString *)summaryToCheck exceptOrder:(NSString *)order;
- (void)increaseMemoOderForAllMemo;
- (void)createMemoInDataBase:(BQMemo *)memo;

@end
