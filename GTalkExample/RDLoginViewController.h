//
//  RDLoginViewController.h
//  GTalkExample
//
//  Created by Oleksiy Ivanov on 1/14/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCyclingLabel.h"

@interface RDLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *waitingView;
@property (weak, nonatomic) IBOutlet BBCyclingLabel *waitingViewAnimatedLabel;

- (IBAction)onLoginTextFieldEditingEnded:(id)sender;
- (IBAction)onPasswordTextFieldEditingEnded:(id)sender;
- (IBAction)onConnectButtonTouched:(id)sender;

-(void)setWaitingText:(NSString*)text;

@end
