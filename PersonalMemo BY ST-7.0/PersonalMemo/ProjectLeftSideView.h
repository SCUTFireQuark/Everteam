//
//  ProjectLeftSideView.h
//  PersonalMemo
//
//  Created by st2 on 15/1/10.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQRelatedViewController.h"
@interface ProjectLeftSideView : UIView
@property BQRelatedViewController * delegate;
@property bool isSwip;

@property NSString * projectSelectedID;//左边栏当前选中的projectID
@property NSMutableArray *ProjectBtns;//左边栏项目btn数组
- (void)LoadProjectBtn:(NSMutableDictionary*)dict;


@end
