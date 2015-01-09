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

@interface BQMemoTransmition : NSObject

- (void)startRequest:(BQMemo *)memoForSend;

@end
