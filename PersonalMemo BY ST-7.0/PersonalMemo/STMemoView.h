//
//  STMemoView.h
//  SimpleView
//
//  Created by st2 on 15/1/9.
//  Copyright (c) 2015年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQRelatedViewController.h"
#import "BQMemoTransmition.h"
@interface STMemoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *detail;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *clock;
@property (weak, nonatomic) IBOutlet UILabel *deadline;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UILabel *memoStateLabel;

@property NSString *memoID;
@property UITextView * detailTextView;

@property int order;
@property bool isZoomUp ;
@property int fixHeight;
@property BQRelatedViewController *delegate;
@property BQMemoTransmition *TR;
@end
