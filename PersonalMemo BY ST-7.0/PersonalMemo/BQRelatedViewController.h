//
//  BQRelatedViewController.h
//  PersonalMemo
//
//  Created by st2 on 15/1/10.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTeamMemo.h"

@interface BQRelatedViewController : UIViewController
//函数
-(void)delegate_changeProject:(NSString*)projectName;
-(void)delegate_memo2Right:(int)pix;
-(void)delegate_memo2Left:(int)pix;

-(void)delegate_memoIsZoomUpWithOrder:(int)order fixed:(int)fix;
-(void)delegate_memoIsZoomDownWithOrder:(int)order fixed:(int)fix;

-(void)LoadTaskMemo;

//调用此方法，输入一个dic输出一个保存有所有便签view的数组
-(void)inputADicWithMemoData:(NSMutableDictionary *)dic;


@property (strong, nonatomic) UISegmentedControl *selectMemoKindBar;//便签类型选择
//变量
@property (strong, nonatomic) UIScrollView *MemoScrollView;


//@property (strong, nonatomic) ProjectLeftSideView * leftSideView;

//保存所有的便签view
@property NSMutableArray * memosArray;
@property NSMutableArray * memos;
//project数组
@end
