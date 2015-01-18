//
//  BQMemoTransmition.h
//  PersonalMemo
//
//  Created by River on 14-10-23.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQMemo.h"
#import "MemoXMLParser.h"
#import "AFNetworking.h"
#import "STLoginViewController.h"
#import "STRegisterViewController.h"
#import "BQRelatedViewController.h"
#import "BQRelatedViewController.h"
#import "STProjectNameSelectViewController.h"
#import "STUserSelectedViewController.h"
#import "ProjectLeftSideView.h"
@interface BQMemoTransmition : NSObject

@property STRegisterViewController * delegate_Register;
@property (strong,nonatomic)NSString *currentTagName;
@property(strong,nonatomic) NSMutableString *jsonString;
@property (strong,nonatomic)NSString *judgeTag;
@property STLoginViewController * delegate;
@property TaskMemoViewController *delegate_sent;
@property BQRelatedViewController * delegate_Related;
@property STProjectNameSelectViewController * delegate_Project;
@property STUserSelectedViewController * delegate_User;
@property ProjectLeftSideView * delegate_leftSideView;

- (void)startRequest:(BQMemo *)memoForSend;
- (void)loginWithUserID:(NSString*)userid withpassword:(NSString*)password;//登陆接口
- (void)accountVery:(NSString*)account withpassword:(NSString*)password withnickname:(NSString*)nickname withimage:(NSString*)image;//注册接口
-(void)newMemoSummary:(NSString*)summary detail:(NSString*)details remindtime:(NSString*)remindTime createtime:(NSString*)createTime projectid:(NSString*)projectID source:(NSString*)memoSource memostate:(NSString*)state;//新便签
-(void)sendMemowithuserid:(NSString *)userID memoid:(NSString *)memoID projectid:(NSString *)projectID
;//分派便签任务
-(void)projectMemoGet:(NSString*)projectid;//获取项目便签

-(void)myTaskMemoGet:(NSString *)userID project:(NSString *)projectID;//获取我的任务便签

-(void)memoFromMeGet:(NSString *)userID project:(NSString *)projectID;//获取我发出的便签
-(void)stateChangewithmemoID:(NSString *)memoID currentstate:(NSString *)currentState;//改变状态
-(void)projectOfMeGet:(NSString *)userID;//获取我的项目名称
-(void)userOfProjectGet:(NSString *)projectID;//获取项目成员名单

@end
