//
//  HCInitPay.h
//  HostedCheckout
//
//  Created by agharris73 on 9/4/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCMercuryHelper.h"
#import "AppDelegate.h"

@interface HCInitPay : UIViewController <HCMercuryHelperDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonRunInitPaymentRequest;

- (IBAction)runInitPaymentRequest:(id)sender;

@end
