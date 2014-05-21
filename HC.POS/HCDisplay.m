//
//  HCDisplay.m
//  HostedCheckout
//
//  Created by agharris73 on 9/4/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import "HCDisplay.h"

@interface HCDisplay ()

@end

@implementation HCDisplay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)displayHcPage:(id)sender {
    
    NSString *pidURL = [NSString stringWithFormat:@"https://hc.mercurydev.net/CheckoutPOSiFrame.aspx?pid=%@", self.paymentID];
    NSURL *url = [NSURL URLWithString:pidURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
