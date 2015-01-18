//
//  MainTabBarController.m
//  PersonalMemo
//
//  Created by new45 on 15-1-11.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import "MainTabBarController.h"
#import "OptionButton.h"
#import "PersonalMemoViewController.h"
#import "TaskMemoViewController.h"
#import "TalkMemoViewController.h"

@interface MainTabBarController ()<OptionButtonDelegate>
@property(strong,nonatomic) TaskMemoViewController * TaskMemoView;
@property(strong,nonatomic) TalkMemoViewController * TalkMemoView;
@property(strong,nonatomic) PersonalMemoViewController * PersonalMemoView;

@end

@implementation MainTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    OptionsButton *brOption = [[OptionsButton alloc] initForTabBar:self.tabBar forItemIndex:2 delegate:self];
    
    self.TaskMemoView = [[TaskMemoViewController alloc]initWithNibName:@"TaskMemoViewController" bundle:nil];
    self.TalkMemoView = [[TalkMemoViewController alloc]initWithNibName:@"TalkMemoViewController" bundle:nil];
    self.PersonalMemoView = [[PersonalMemoViewController alloc]initWithNibName:@"PersonalMemoViewController" bundle:nil];
    
    //self.PersonalMemoView = [[PersonalMemoView alloc]init];
    [brOption setImage:[UIImage imageNamed:@"Add"] forOptionsButtonState:OptionsButtonStateNormal];
    [brOption setImage:[UIImage imageNamed:@"x"] forOptionsButtonState:OptionsButtonStateOpened];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - BROptionsButtonState

- (NSInteger)OptionsButtonNumberOfItems:(OptionsButton *)OptionsButton
{
    return 3;
}

- (UIImage*)OptionsButton:(OptionsButton *)OptionsButton imageForItemAtIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageNamed:@"Add"];
    return image;
}


- (void)OptionsButton:(OptionsButton *)OptionsButton didSelectItem:(OptionItem *)item
{
    NSLog(@"%d",item.index);
        switch (item.index) {
       case 0:
            [self presentViewController:self.PersonalMemoView animated:YES completion:nil];
            break;
       case 1:
            [self presentViewController:self.TaskMemoView animated:YES completion:nil];
            break;
       case 2:
            [self presentViewController:self.TalkMemoView animated:YES completion:nil];
            break;
        default:
            break;
    }
}

@end
