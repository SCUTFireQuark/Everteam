//
//  MemoXMLParser.h
//  PersonalMemo
//
//  Created by mac on 14-8-25.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoXMLParser : NSObject<NSXMLParserDelegate>

//解析出的数据，内部是字典类型
//@property (strong,nonatomic)NSMutableArray *notes;
//当前标签的名字
@property (strong,nonatomic)NSString *currentTagName;
@property(strong,nonatomic) NSMutableString *jsonString;
//开始解析
-(void)start:(NSString *) memoString;

@end
