//
//  HCDisplay.h
//  HostedCheckout
//
//  Created by agharris73 on 9/4/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCMercuryHelper.h"
#import "AppDelegate.h"

@interface HCDisplay : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) NSMutableString *paymentID;
@property (weak, nonatomic) UIWebView *viewWeb;

@property (strong, nonatomic) IBOutlet UIButton *buttonDisplayHCPage;
- (IBAction)displayHcPage:(id)sender;

@end
