//
//  OptionItem.h
//  PersonalMemo
//
//  Created by new45 on 15-1-11.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultButtonHeight  40
@interface OptionItem : UIButton

@property(nonatomic,readonly) NSInteger index;

@property(nonatomic,strong) UIAttachmentBehavior *attachment;
- (instancetype)initWithIndex:(NSInteger)index;
@end
