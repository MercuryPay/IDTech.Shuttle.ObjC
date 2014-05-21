//
//  HCVerifyPaymentRequest.h
//  HostedCheckout
//
//  Created by agharris73 on 9/4/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCMercuryHelper.h"
#import "AppDelegate.h"

@interface HCVerifyPaymentRequest : UIViewController <HCMercuryHelperDelegate, UIWebViewDelegate, UIAlertViewDelegate>

- (IBAction)runHCVerifyPaymentRequest:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonRunVerifyPaymentRequest;

@end
