//
//  OptionsButton.h
//  PersonalMemo
//
//  Created by new45 on 15-1-11.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionItem.h"
#import "PersonalMemoViewController.h"
#import "TaskMemoViewController.h"
#import "TalkMemoViewController.h"
typedef enum {
    OptionsButtonStateOpened,
    OptionsButtonStateClosed,
    OptionsButtonStateNormal
}OptionsButtonStates;

@protocol OptionButtonDelegate;
@interface OptionsButton : UIButton

@property(strong,nonatomic) TaskMemoViewController * TaskMemoView;
@property(strong,nonatomic) TalkMemoViewController * TalkMemoView;
@property(strong,nonatomic) PersonalMemoViewController * PersonalMemoView;
/*!
 * TabBar currently installed on
 */
@property (nonatomic, readonly, weak) UITabBar *tabBar;
@property (nonatomic, assign) NSInteger locationIndexInTabBar;
@property (nonatomic, weak) id<OptionButtonDelegate> delegate;
@property (nonatomic, readonly) OptionsButtonStates currentState;

/*!
 *!parameters: tabBar     - pass the tabBar to be attached to
 *             itemIndex - the item position that will be changed with the button
 *             delgate   - the delegate must be setted
 */
- (instancetype)initForTabBar:(UITabBar*)tabBar
                 forItemIndex:(NSUInteger)itemIndex
                     delegate:(id<OptionButtonDelegate>)delegate;
/*!
 * Set the image for the open state (X in the demo)
 * and for the close state (Apple in the demo)
 */
- (void)setImage:(UIImage *)image forOptionsButtonState:(OptionsButtonStates)state;
@end

//-------------------------------------------
@protocol OptionButtonDelegate <NSObject>
- (void)OptionsButton:(OptionsButton*)OptionsButton didSelectItem:(OptionItem*)item;
- (NSInteger)OptionsButtonNumberOfItems:(OptionsButton*)OptionsButton;

@optional
- (void)OptionsButton:(OptionsButton*)optionsButton willDisplayButtonItem:(OptionItem*)button;
- (NSString*)OptionsButton:(OptionsButton*)OptionsButton titleForItemAtIndex:(NSInteger)index;
- (UIImage*)OptionsButton:(OptionsButton*)OptionsButton imageForItemAtIndex:(NSInteger)index;
@end
