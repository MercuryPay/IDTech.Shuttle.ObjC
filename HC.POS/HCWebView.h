//
//  HCWebView.h
//  HostedCheckout
//
//  Created by agharris73 on 9/4/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCMercuryHelper.h"
#import "AppDelegate.h"

@interface HCWebView : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) NSMutableString *paymentID;

@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;

@end
