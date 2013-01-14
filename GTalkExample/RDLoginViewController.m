//
//  RDLoginViewController.m
//  GTalkExample
//
//  Created by Oleksiy Ivanov on 1/14/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RDLoginViewController.h"
#import "RDAppController.h"

@implementation RDLoginViewController

#pragma mark Internal interface
-(void)showWaitingView
{
    self.waitingView.hidden = NO;
    
    self.waitingView.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.waitingView.alpha = 1;
    }];
    
}

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
    
    self.waitingViewAnimatedLabel.textColor = [UIColor whiteColor];
    self.waitingViewAnimatedLabel.shadowColor = [UIColor lightGrayColor];
    self.waitingViewAnimatedLabel.shadowOffset = CGSizeMake(1, 1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginTextFieldEditingEnded:(id)sender
{
    int64_t delayInSeconds = 0.05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.passwordTextField becomeFirstResponder];
    });
}

- (IBAction)onPasswordTextFieldEditingEnded:(id)sender
{
    int64_t delayInSeconds = 0.05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self onConnectButtonTouched:nil];
    });
}

- (IBAction)onConnectButtonTouched:(id)sender
{
    [self.passwordTextField resignFirstResponder];
    [self.loginTextField resignFirstResponder];
    
    if([self.loginTextField.text length]<5 || [self.passwordTextField.text length]<4)
    {
        [[[UIAlertView alloc]initWithTitle:@"Enter Login and Password" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]show];
        return;
    }
    
    [self showWaitingView];
    
    //check values for Login and passowrd
    [appController() connectToGTalkWithLogin:self.loginTextField.text withPassword:self.passwordTextField.text];
}

-(void)setWaitingText:(NSString*)text
{
    self.waitingViewAnimatedLabel.text = text;
}

- (void)viewDidUnload {
    [self setWaitingViewAnimatedLabel:nil];
    [super viewDidUnload];
}
@end
