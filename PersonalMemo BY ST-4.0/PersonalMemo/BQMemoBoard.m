//
//  BQMemoBoard.m
//  PersonalMemo
//
//  Created by River on 14-10-7.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import "BQMemoBoard.h"

@interface BQMemoBoard()

@end

@implementation BQMemoBoard

- (NSMutableArray *)themeArray
{
    if (_themeArray == nil) {
        _themeArray = [NSMutableArray array];
    }
    return _themeArray;
}

- (NSMutableArray *)memoArray
{
    if (_memoArray == nil) {
        _memoArray = [NSMutableArray array];
    }
    return _memoArray;
}

- (BQTheme *)currentTheme
{
    if (_currentTheme == nil) {
        _currentTheme = [[BQTheme alloc] init];
    }
    return _currentTheme;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.currentTheme.name = @"默认";
        [self loadTheme];
        [self loadMemo];
    }
    return self;
}

- (void)loadTheme
{
    [self.themeArray removeAllObjects];
    self.themeArray = [self queryAllThemeInDataBase];
}

//---------------------加载某一主题下的所有便签---------------------------
- (void)loadMemo
{
    NSArray *allMemoArraty = [self queryAllMemoInDataBase];
    NSMutableArray *unSortedMemoArray = [NSMutableArray array];
    [self.memoArray removeAllObjects];

    for (BQMemo *memo in allMemoArraty) {
        if ([memo.theme isEqualToString:self.currentTheme.name]) {
            [unSortedMemoArray addObject:memo];
            [self.memoArray addObject:memo];
        }
    }
    for (BQMemo *memo in unSortedMemoArray) {
        self.memoArray[[memo.memoOrder intValue]] = memo;
    }
}

- (void)switchThemeAction:(BQTheme *)theme
{
    self.currentTheme = theme;
    [self loadMemo];
}

//------------------判断新建的便签主题是否和已有便签相同---------------------
- (BOOL)isDataBaseContainMemoWithSummary:(NSString *)summaryToCheck
{
    for (BQMemo *memo in self.memoArray) {
        if ([memo.summary isEqualToString:summaryToCheck]) {
            return YES;
        }
    }
    return NO;
}

//------------把数据库当前主题的所有便签读取出来,memoOrder+1---------------
- (void)increaseMemoOderForAllMemo
{
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *memoArray = [app.managedObjectContext executeFetchRequest:request error:Nil];
    for (Memo *memo in memoArray) {
        if ([memo.theme isEqualToString:self.currentTheme.name]){
            NSInteger order = [memo.memoOrder intValue];
            order++;
            memo.memoOrder=[[NSString alloc]initWithFormat:@"%i", order];
        }
        
    }
    [app saveContext];
    [self loadMemo];
}

//-------------------根据便签的summary更新便签的order---------------------
- (void)updateMemoOrderWithTitle:(NSString *)summary newOrder:(NSString *)order
{
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *memoArray = [app.managedObjectContext executeFetchRequest:request error:Nil];
    for (Memo *memo in memoArray) {
        if([memo.summary isEqualToString:summary])
        {   //iv.tag 设置为这一个数据中的memoorder的值
            memo.memoOrder = order;
        }
    }
    [app saveContext];
    [self loadMemo];

}

//------------------根据当前主题和order修改便签内容-----------------------
- (void)updateMemoContextWithTheme:(NSString *)theme andOrder:(NSString *)order newSummary:(NSString *)summary newDetail:(NSString *)detail
{
    //从数据库读取memoOrder=iv.tag的memo
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *memoArray = [app.managedObjectContext executeFetchRequest:request error:Nil];
    //创建时间
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *createTime = [dateFormatter stringFromDate:[NSDate date]];
    
    for (Memo *memo in memoArray) {
        if ([memo.theme isEqualToString:theme]&&[memo.memoOrder isEqualToString:order]) {
            memo.summary = summary;
            memo.details = detail;
            memo.createTime = createTime;
        }
    }
    [app saveContext];
    [self loadMemo];

}

//---------------------根据便签的summary删除便签-------------------------
- (void)removeMemoInDataBaseWithMemoTitle:(NSString *)summary
{
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *memoArray = [app.managedObjectContext executeFetchRequest:request error:Nil];
    int deleteMemoOrder = -1;
    for (Memo *memo in memoArray) {
        if ([memo.theme isEqualToString:self.currentTheme.name]) {
            if ([memo.summary isEqualToString:summary]) {
                deleteMemoOrder = [memo.memoOrder intValue];
                [app.managedObjectContext deleteObject:memo];
            }
        }
    }
    for (Memo *memo in memoArray) {
        if ([memo.theme isEqualToString:self.currentTheme.name]) {
            if (deleteMemoOrder >= 0 && [memo.memoOrder intValue] > deleteMemoOrder) {
                memo.memoOrder = [NSString stringWithFormat:@"%d",[memo.memoOrder intValue]-1];
            }
        }
    }
    [app saveContext];
    [self loadMemo];
    
}

//--------------------获得包含了数据库中所有便签的数组---------------------
- (NSMutableArray *)queryAllMemoInDataBase
{
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *request2 = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *memoArray = [app.managedObjectContext executeFetchRequest:request2
                                                   error:Nil];
    NSMutableArray * returnArray = [NSMutableArray array];

    for (Memo *memo in memoArray) {
        BQMemo *memoReturn = [[BQMemo alloc] init];
        memoReturn.summary = memo.summary;
        memoReturn.details = memo.details;
        memoReturn.theme = memo.theme;
        memoReturn.memoOrder = memo.memoOrder;
        //创建时间
        memoReturn.createTime = memo.createTime;
        memoReturn.remindTime = memo.remindTime;
            
        [returnArray addObject:memoReturn];
    }
    return returnArray;
    
}

//--------------------获得包含了数据库中所有主题的数组---------------------
- (NSMutableArray *)queryAllThemeInDataBase
{
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request1 = [[NSFetchRequest alloc]initWithEntityName:@"Theme"];
    NSArray *themeArray = [app.managedObjectContext executeFetchRequest:request1 error:Nil];
    NSMutableArray * returnArray = [NSMutableArray array];
    BOOL hasDefaultTheme = NO;
    
    for (Theme * theme in themeArray) {
        if ([theme.name isEqualToString:@"默认"]) {
            hasDefaultTheme = YES;
        }
    }

    if (!hasDefaultTheme) {
        Theme *tempTheme = [NSEntityDescription insertNewObjectForEntityForName:@"Theme" inManagedObjectContext:app.managedObjectContext];
        tempTheme.name = @"默认";
        [app saveContext];
        //重新读取主题
        themeArray = [app.managedObjectContext executeFetchRequest:request1 error:Nil];
    }
    
    for (Theme * theme in themeArray) {
        BQTheme *themeReturn = [[BQTheme alloc] init];
        themeReturn.name = theme.name;
        themeReturn.themeID = theme.themeID;
        
        [returnArray addObject:themeReturn];
    }
    return returnArray;
}

//--------------------根据主题名字删除对应的主题---------------------
- (void)removeThemeInDataBaseWithThemeName:(NSString*)name
{
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Theme"];
    NSArray *themeArray = [app.managedObjectContext executeFetchRequest:request error:Nil];
    for (Theme *theme in themeArray) {
        if([theme.name isEqualToString:name]){
            [app.managedObjectContext deleteObject:theme];
        }
        
    }
    [app saveContext];
}

//-------------------根据主题名字删除所有便签--------------------
- (void)removeAllMemosInTheme:(NSString *)themeName
{
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Memo"];
    NSArray *memoToDeleteArray = [app.managedObjectContext executeFetchRequest:request error:Nil];
    for (Memo* memoToDelete in memoToDeleteArray) {
        if ([memoToDelete.theme isEqualToString:themeName]) {
            [app.managedObjectContext deleteObject:memoToDelete];}
    }
    [app saveContext];
}


//--------------------新建一条便签---------------------
- (void)createMemoInDataBase:(BQMemo *)memo
{
    //把便签存入数据库
    STAppDelegate * app1 = [UIApplication sharedApplication].delegate;
    Memo *memoSave = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:app1.managedObjectContext];
    
    memoSave.summary = memo.summary;
    memoSave.details = memo.details;
    memoSave.theme = memo.theme;
    memoSave.memoOrder = memo.memoOrder;
    memoSave.remindTime = memo.remindTime;
    //创建时间
    memoSave.createTime = memo.createTime;
    
    //保存好写入数据库
    [app1 saveContext];
}

//--------------------新建一个主题---------------------
- (void)createThemeInDataBase:(BQTheme *)theme
{
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    Theme *themeSave = [NSEntityDescription insertNewObjectForEntityForName:@"Theme" inManagedObjectContext:app.managedObjectContext];
    themeSave.name = theme.name;
    themeSave.themeID = theme.themeID;
    [app saveContext];
    [self loadTheme];
}

//--------------------根据对应的memoID修改对应的便签---------------------
- (void)editMemoInDataBaseWithMemoID:(NSString *)memoID changeTitleWith:(NSString *)title changeSummaryWith:(NSString *)summary
{
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request2 = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *memoArray = [app.managedObjectContext executeFetchRequest:request2 error:Nil];
    for (Memo *memo in memoArray) {
        if([memo.memoID isEqualToString:memoID]){
            memo.summary = title;
            memo.details = summary;
        }
    }
    [app saveContext];
    [self loadMemo];

}

//--------------------根据便签的summary查询便签的ID---------------------
- (NSString*)queryMemoIDWithMemoTitle:(NSString*)memoTitle
{
    
    STAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Memo"];
    NSArray *memoArray = [app.managedObjectContext executeFetchRequest:request error:Nil];
    for (Memo *memo in memoArray) {
        if([memo.summary isEqualToString:memoTitle]){
            return memo.memoID;
        }
    }
    return nil;
}


@end
