//
//  RDAppController.h
//  GTalkExample
//
//  Created by Oleksiy Ivanov on 1/14/13.
//  Copyright (c) 2013 Oleksiy Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@class XMPPRoster;

@interface RDAppController : NSObject<XMPPStreamDelegate>

@property(strong)NSString*                  login;
@property(strong)NSString*                  password;


@property(strong)XMPPStream*                xmppStream;
@property(strong)XMPPRoster*                xmppRoster;


-(void)connectToGTalkWithLogin:(NSString*)login withPassword:(NSString*)password;

@end


RDAppController* appController();
