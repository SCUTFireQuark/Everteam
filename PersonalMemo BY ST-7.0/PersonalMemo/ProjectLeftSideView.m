//
//  ProjectLeftSideView.m
//  PersonalMemo
//
//  Created by st2 on 15/1/10.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import "ProjectLeftSideView.h"

@implementation ProjectLeftSideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.ProjectBtns=[[NSMutableArray alloc]init];
        
        self.isSwip = NO;
        //初始化位置
        self.center = CGPointMake(-60, self.center.y+20 );
        //添加左划右划手势
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        
        [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swipeGestureRight];
        
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipeGestureLeft];

        
    }
    return self;
    
}


- (void)LoadProjectBtn:(NSMutableDictionary*)dict
{
    [self.ProjectBtns removeAllObjects];
    
    //NSMutableArray * ms = [[NSMutableArray alloc]init];
    NSEnumerator * enumeratorobj = [dict objectEnumerator];
    int i=0;
    for (NSMutableDictionary * project in enumeratorobj) {
        NSString *projectID=[project valueForKey:@"projectID"];
        NSString *projectName=[project valueForKey:@"projectName"];
        
        //服务器返回的最后一个空项目不显示
        if (projectName==nil) {
            break;
        }
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10 + i * 50, 120, 40)];
        [btn setTitle:projectName forState:UIControlStateNormal];
        
        //btn的tag存放projectID
        btn.tag=projectID.intValue;
        
        NSLog(@"btn.tag:%ld",(long)btn.tag);
        btn.backgroundColor=[UIColor blueColor];
        //添加点击事件
        [btn addTarget:self action:@selector(changeProject:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [self.ProjectBtns addObject:btn];
        
        i++;
    }
    
    //默认选中的project是第一个
    UIButton *a=(UIButton *)self.ProjectBtns[0];
    //被选中的project颜色被标示
    a.backgroundColor=[UIColor grayColor];
    
     NSLog(@"a.tag:%ld",(long)a.tag);
    
    self.projectSelectedID=[NSString stringWithFormat: @"%ld", (long)a.tag ];
    
    NSLog(@"projectSelectedID:%@",self.projectSelectedID);
    
    
   // [self.delegate LoadMemo];
    
//测试用
/*
    int i = 0;
    for (NSString * str in projects) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(35, 10 + i * 50, 70, 40)];
        [btn setTitle:str forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor blueColor];
        //添加点击事件
        [btn addTarget:self action:@selector(changeProject:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        i++;
    }
 */
}

- (void)changeProject:(UIButton *)btn{
    
    //颜色标示改变
    for (int i=0; i<self.ProjectBtns.count; i++) {
        UIButton *a=self.ProjectBtns[i];
        
        if ([[NSString stringWithFormat: @"%ld", (long)a.tag ] isEqualToString:self.projectSelectedID]) {
            a.backgroundColor=[UIColor blueColor];
        }
    }
    
   // [self viewWithTag:self.projectSelectedID.intValue].backgroundColor=[UIColor blueColor];
    
    btn.backgroundColor=[UIColor grayColor];
    
    
    //选中项目便签数据请求及显示
    self.projectSelectedID=[NSString stringWithFormat: @"%ld", (long)btn.tag ];
    //调用delegate的函数
    [self.delegate delegate_changeProject:self.projectSelectedID];
    
}

-(void)swipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer{
    
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight && !self.isSwip) {
        
        CGRect newPos=CGRectMake(self.frame.origin.x+130, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        [self memoMovement:self initialFrame:self.frame FinalFrame:newPos];
        
       // self.center = CGPointMake(self.center.x + 40, self.center.y);
        self.isSwip = YES;
        //调用delegate 让全部任务右移动
        [self.delegate delegate_memo2Right:130];
        
    }
    
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft && self.isSwip) {
        CGRect newPos=CGRectMake(self.frame.origin.x-130, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        [self memoMovement:self initialFrame:self.frame FinalFrame:newPos];
        
        //self.center = CGPointMake(self.center.x - 40, self.center.y);
        self.isSwip = NO;
        [self.delegate delegate_memo2Left:130];
        //调用delegate 全部任务左移动
    }

}

//动画函数
- (void)memoMovement:(UIView *)selectedView initialFrame:(CGRect)startRect FinalFrame:(CGRect)endRect
{
    selectedView.frame = startRect;
    [UIView beginAnimations:nil context:(__bridge void *)(selectedView)];
    [UIView setAnimationDuration:0.5];
    selectedView.frame = endRect;
    [UIView commitAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
