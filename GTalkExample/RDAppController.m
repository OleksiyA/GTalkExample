//
//  RDAppController.m
//  GTalkExample
//
//  Created by Oleksiy Ivanov on 1/14/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import "RDAppController.h"
#import "RDAppDelegate.h"
#import "RDLoginViewController.h"
#import "XMPPRoster.h"
#import "XMPPRosterMemoryStorage.h"

RDAppController* appController()
{
    RDAppDelegate* appDelegate = (RDAppDelegate*)[[UIApplication sharedApplication]delegate];
    RDAppController* appController = [appDelegate appController];
    
    return appController;
}

@implementation RDAppController

#pragma mark Internal interface
-(RDLoginViewController*)loginViewControllerOrNil
{
    UIViewController* rootVC = [[[[UIApplication sharedApplication]delegate]window]rootViewController];
    
    if([rootVC isKindOfClass:[RDLoginViewController class]])
    {
        return (RDLoginViewController*)rootVC;
    }
    
    if([rootVC isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navController = (UINavigationController*)rootVC;
        if([navController.topViewController isKindOfClass:[RDLoginViewController class]])
        {
            return (RDLoginViewController*)(navController.topViewController);
        }
    }
    
    return nil;
}

-(void)setStatusTextToWaitingView:(NSString*)statusText
{
    RDLoginViewController* vc = [self loginViewControllerOrNil];
    if(!vc)
    {
        return;
    }
    
    vc.waitingViewLabel.text = statusText;
}

-(void)connectToGTalk
{
    NSLog(@"Will connect to GTalk with login [%@], password [%@].",self.login,self.password);
    
    self.xmppStream = [[XMPPStream alloc]init];
    self.xmppStream.myJID = [XMPPJID jidWithString:self.login];
    self.xmppStream.hostName = @"talk.google.com";
    
    XMPPRosterMemoryStorage *rosterstorage = [[XMPPRosterMemoryStorage
                                               alloc] init];
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:rosterstorage
                                             dispatchQueue:dispatch_get_main_queue()];
    [self.xmppRoster activate:self.xmppStream];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppStream addDelegate:self.xmppRoster delegateQueue:dispatch_get_main_queue()];
    
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    if (![self.xmppStream connect:&error])
    {
        NSLog(@"Error connection to GTalk: %@", error);
    }
}

-(void)loadContactList
{
    NSLog(@"Will fetch roster.");
    
    [self.xmppRoster fetchRoster];
    
#if 0
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"
                                                  xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    
    [self.xmppStream sendElement:iq];
#endif
}

#pragma mark Allocation and Deallocation
-(id)init
{
    self = [super init];
    
    return self;
}

#pragma mark Public interface
-(void)connectToGTalkWithLogin:(NSString*)login withPassword:(NSString*)password
{
    self.login = login;
    self.password = password;
    
    [self connectToGTalk];
}

#pragma mark XMPPStreamDelegate methods
- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    NSLog(@"Stream will connect.");
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    [settings setObject:@"gmail.com" forKey:(id)kCFStreamSSLPeerName];
    
    NSLog(@"willSecureWithSettings [%@].",settings);
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    NSLog(@"Did secure");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"Stream did connect, will authentificate with password.");
    
    [self.xmppStream authenticateWithPassword:self.password error:NULL];
    
    [self setStatusTextToWaitingView:@"Authentificating..."];
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"Did register");
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"Did not register");
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"Did authentificate");
    
    //set label text @"Loading..."
    [self setStatusTextToWaitingView:@"Loading..."];
    
    [self loadContactList];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"Did not authentificate, error [%@].",error);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"Did disconnect. Error [%@].",error);
    
    [self setStatusTextToWaitingView:@"Disconnected"];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    NSLog(@"didReceivePresence, presenceType[%@], myUsername[%@], presenceFromUser[%@].",presenceType,myUsername,presenceFromUser);
    
#if 0
    if (![presenceFromUser isEqualToString:myUsername]) {
        
        if ([presenceType isEqualToString:@"available"]) {
            [_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"gmail.com"]];
            
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            
            [_chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"gmail.com"]];
            
        }
        
    }
#endif
}



@end
