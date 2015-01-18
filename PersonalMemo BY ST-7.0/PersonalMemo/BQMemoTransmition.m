//
//  BQMemoTransmition.m
//  PersonalMemo
//
//  Created by River on 14-10-23.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import "BQMemoTransmition.h"

@interface BQMemoTransmition()

@property(nonatomic) BOOL isStartRequest;
@property (strong,nonatomic) NSMutableData *datas;
@property (strong,nonatomic) NSMutableArray *memoList;
@property bool lock;
@end


@implementation BQMemoTransmition

//登陆判断跳转
-(void) loginSuccessTag:(NSString *)userAccountName :(NSString *)password :(NSString *)userid
{
    if([self.judgeTag isEqualToString:@"login failed"])
        //登陆失败
    {
        
        }
    
        //登陆成功
    else{
        [self.delegate popView];
        [self.delegate dataStore:userAccountName :password :userid ];
        }
}
//便签状态改变成功
-(void)stateChangeSuccess
{
    //状态改变成功提示框
    NSLog(@"便签状态改变成功！！！！");

}
//注册成功
-(void) registerSuccess
{
  //注册成功提示框
    NSLog(@"success");
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
    
    [self.delegate_Register performSegueWithIdentifier:@"registerSuccess" sender:nil];
  
}

//注册不成功(用户名重复）
-(void)accountNameReplicated
{
    
  //用户名重复提示框
    NSLog(@"success!");
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"邮箱已被注册!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
    NSLog(@"fail");

}

//显示便签
-(void)printMemo:(NSMutableDictionary *)dict
{
    //[[BQRelatedViewController alloc] inputADicWithMemoData:dict];
    [self.delegate_Related inputADicWithMemoData:dict];
}

//显示我的任务便签
-(void)printMyTaskMemo:(NSMutableDictionary *)dict
{
    self.delegate_Related.selectMemoKindBar.selectedSegmentIndex=0;
    //[[BQRelatedViewController alloc] inputADicWithMemoData:dict];
    [self.delegate_Related inputADicWithMemoData:dict];
}


//显示项目
-(void)printProject:(NSMutableDictionary *)dict
{
    //self.delegate_Project=[[STProjectNameSelectViewController alloc] init];
    //调用显示项目函数
    
    [self.delegate_Project printProject:dict];
    NSLog(@"printProject diaoyong");
}

//显示成员
-(void)printMember:(NSMutableDictionary *)dict
{
    //调用显示成员函数
    [self.delegate_User printUser:dict];
}


//新建便签成功
-(void)memoCreateSuccess:(NSString *)memoID
{
    //存储便签ID
    for (int i = 0; i < self.delegate_sent.selectedUserID.count; i++) {
        NSLog(@"AAAAAA");
        NSLog(@"%@",self.delegate_sent.selectedUserID[i]);
        [self sendMemowithuserid:self.delegate_sent.selectedUserID[i] memoid:memoID projectid:self.delegate_sent.selectedProjectID];
    }

}


//网络连接参数设置
-(AFHTTPRequestOperationManager *)connectsetting
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer  serializer];//响应
    return  manager;
}
//数据封装
-(NSMutableDictionary *)packup:(NSString *)jsonStr
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:jsonStr forKey:@"jsonText"];
    return parameters;
}
//选择网络连接方法
-(NSString *)URL:(NSString *)selector
{
    NSString *url =[[NSString alloc] init];
    url=[NSString stringWithFormat:@"http://115.28.169.252:8090/TeamManagementWebService.asmx/%@",selector];
    return url;
    
}
//解析返回数据
-(NSString *)parseData:(id)data
{   NSLog(@"接收数据！");
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    MemoXMLParser *parser = [MemoXMLParser new];
    [parser start:result];
    NSString *jsonStr = [[NSString alloc] initWithString:parser.jsonString];
    NSLog(@"jsonStr:%@",jsonStr);
    return jsonStr;
}

//获得我的项目
-(void)projectOfMeGet:(NSString *)userID
{
    NSString *jsonText = [NSString stringWithFormat:@"[{\"userID\": \"%@\" }]",userID];
    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETGetProjectByUserID"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    
    //连接
    [manager POST:url parameters:para
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *jsonStr = [self parseData:responseObject];
              NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
              NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData: jsonData options:
                                           NSJSONReadingAllowFragments error:nil];
              [self.delegate_leftSideView LoadProjectBtn:dict];
              [self printProject:dict];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];

}

//获得我的项目test
-(void)returnProjectOfMeGet:(NSString *)userID
{
    NSString *jsonText = [NSString stringWithFormat:@"[{\"userID\": \"%@\" }]",userID];
    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETGetProjectByUserID"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    
    //连接
    [manager POST:url parameters:para
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *jsonStr = [self parseData:responseObject];
              NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
              NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData: jsonData options:
                                           NSJSONReadingAllowFragments error:nil];
              [self printProject:dict];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];
    
}

//改变状态
-(void)stateChangewithmemoID:(NSString *)memoID currentstate:(NSString *)currentState
{
    
        NSString *jsonText = [NSString stringWithFormat:@"[{\"memoID\": \"%@\", \"newMemoState\":\"%@\"}]",memoID,currentState];
        NSMutableDictionary *para=[self packup:jsonText];
        NSString *url=[self URL:@"ETChangeMemoStateByMemoID"];
        AFHTTPRequestOperationManager *manager=[self connectsetting];
        //连接
        [manager POST:url parameters:para
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *jsonStr=[self parseData:responseObject];
                  self.judgeTag = jsonStr;
                  [self stateChangeSuccess];
                  NSLog(@"judgeinside%@",self.judgeTag);
                                    }
         
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error:%@",error);
              }];
    }

//登陆
- (void)loginWithUserID:(NSString *)userAccountName withpassword:(NSString *)password

{    NSString *jsonText = [NSString stringWithFormat:@"[{\"userAccountName\": \"%@\", \"userPassword\":\"%@\"}]",userAccountName,password];//封装传输数据格式为Json
    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETLoginVerification"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    [self myTaskMemoGet:@"000" project:@"000"];
    //连接
    [manager POST:url parameters:para
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *jsonStr=[self parseData:responseObject];
              self.judgeTag = jsonStr;
              
              NSLog(@"judgeinside%@",self.judgeTag);
              
              //调用成功登陆方法
              [self loginSuccessTag:userAccountName :password :jsonStr];}
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error:%@",error);
          }];
}

//发送便签
-(void)sendMemowithuserid:(NSString *)userID memoid:(NSString *)memoID projectid:(NSString *)projectID
{
    NSString *jsonText = [NSString stringWithFormat:@"[{\"userID\": \"%@\",\"memoID\": \"%@\" ,\"projectID\":\"%@\"}]",userID,memoID,projectID];
    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETSendTask"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    
    //连接
    [manager POST:url parameters:para
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"指派任务成功");
          }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];
}

//新建便签
-(void)newMemoSummary:(NSString*)summary detail:(NSString*)details remindtime:(NSString*)remindTime createtime:(NSString*)createTime projectid:(NSString*)projectID source:(NSString*)memoSource memostate:(NSString*)state
{
    NSString *jsonText = [NSString stringWithFormat:@"[{\"memoSummary\":\"%@\",\"memoDetail\":\"%@\",\"memoRemindTime\":\"%@\",\"memoCreateTime\":\"%@\",\"memoProjectID\":\"%@\",\"memoSourceUserID\":\"%@\",\"memoState\":\"%@\"}]",summary,details,remindTime,createTime,projectID,memoSource,state];
    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETCreateNewTeamMemo"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    [manager POST:url parameters:para
     
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"接收数据！");
              NSString *jsonStr = [self parseData:responseObject];
              [self memoCreateSuccess:jsonStr];}
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
}
//注册成功，提交信息
-(void)registerwithUserID:(NSString*)userAccountName withpassword:(NSString*)password withnickname:(NSString*)nickname withimage:(NSString*)image
{
    NSString *jsonText = [NSString stringWithFormat:@"{\"userAccountName\": \"%@\", \"userPassword\":\"%@\",        \"userNickname\": \"%@\",        \"userImage\": \"%@\"    }",userAccountName,password,nickname,image];
    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETRegister"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    
    //连接
    [manager POST:url parameters:para
     
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"接收数据！");
              [self registerSuccess];}
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
}

//判断注册是否成功
-(void)accountVery:(NSString*)account withpassword:(NSString*)password withnickname:(NSString*)nickname withimage:(NSString*)image
{
    
    NSString *jsonText = [NSString stringWithFormat:@"[{\"userAccountName\": \"%@\" }]",account];
    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETAccountNameVerification"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    
    //连接
    [manager POST:url parameters:para
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *jsonStr = [self parseData:responseObject];
              
              self.judgeTag=jsonStr;//假如用户名没重复则提交注册信息
              
              if([self.judgeTag isEqualToString:@"false"])
                  [self registerwithUserID:account withpassword:password withnickname:nickname withimage:image];
              else
                  [self accountNameReplicated];}
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];
}

//获取项目便签数据
-(void)projectMemoGet:(NSString*)projectid
{
    
    NSString *jsonText = [NSString stringWithFormat:@"[{\"projectID\": \"%@\" }]",projectid];
    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETGetMemoByProjectID"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    
    //连接
    [manager POST:url parameters:para
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *jsonStr = [self parseData:responseObject];
              NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
              NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData: jsonData options:
                                    NSJSONReadingAllowFragments error:nil];
              [self printMemo:dict];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];
}

//获取我的任务便签数据
-(void)myTaskMemoGet:(NSString *)userID project:(NSString *)projectID
{
    
    NSString *jsonText = [NSString stringWithFormat:@"[{\"memoSourceUserID\": \"%@\",\"projectID\": \"%@\" }]",userID,projectID];
    

    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETGetMemoAssignToMeByUserID"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    
    //连接
    [manager POST:url parameters:para
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *jsonStr = [self parseData:responseObject];
              NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
              NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData: jsonData options:
                                    NSJSONReadingAllowFragments error:nil];
              
              [self printMyTaskMemo:dict];
              
          }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];
}

//获取我发出的便签数据
-(void)memoFromMeGet:(NSString *)userID project:(NSString *)projectID
{
    
    NSString *jsonText = [NSString stringWithFormat:@"[{\"userID\": \"%@\",\"projectID\": \"%@\" }]",userID,projectID];
    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETGetMemoSourceIsMeByUserID"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    
    //连接
    [manager POST:url parameters:para
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *jsonStr = [self parseData:responseObject];
              NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
              NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData: jsonData options:
                                    NSJSONReadingAllowFragments error:nil];
              [self printMemo:dict];
          }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];
}
//获取项目成员
-(void)userOfProjectGet:(NSString *)projectID
{
    NSString *jsonText = [NSString stringWithFormat:@"[{\"projectID\": \"%@\" }]",projectID];
    NSMutableDictionary *para=[self packup:jsonText];
    NSString *url=[self URL:@"ETGetUserByProjectID"];
    AFHTTPRequestOperationManager *manager=[self connectsetting];
    
    //连接
    [manager POST:url parameters:para
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *jsonStr = [self parseData:responseObject];
              NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
              NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData: jsonData options:
                                           NSJSONReadingAllowFragments error:nil];
              [self printMember:dict];
          }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];



}
- (void)startRequest:(BQMemo *)memoForSend
{
    
}




//解析XML委托方法：

//在文档开始的时候触发
-(void) parserDidStartDocument:(NSXMLParser *)parser
{
    //_notes=[NSMutableArray new];
}
//在遇到第一个开始标签时触发
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentTagName=elementName;
    //把<string xmlns>的属性值输出
    /*if ([_currentTagName isEqualToString:@"string"])
     {
     NSString *string =[attributeDict objectForKey:@"xmlns"];
     NSLog(@"****string:%@",string);
     
     }
     */
}
//在遇到字符串时触发
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //由于xml太长，解析会把开始标签和结束标签之间的string分开若干段，因此采用拼接到_jsonString的方法
    [_jsonString appendString:string];
    //NSLog(@"parser:string:%@",string);
    
}
//在遇到结束标签时触发
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    self.currentTagName=nil;
    //NSLog(@"reach endElement");
}
//在文档结束时触发
-(void)parserDidEndDocument:(NSXMLParser *)parser   {
    //self.notes=nil;
}


@end

