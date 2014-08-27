//
//  ViewController.h
//  Hello
//
//  Created by new45 on 14-7-12.
//  Copyright (c) 2014年 FireQuark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *userOutput;
@property (strong, nonatomic) IBOutlet UITextField *userInput;
- (IBAction)setOutput:(id)sender;

@end
