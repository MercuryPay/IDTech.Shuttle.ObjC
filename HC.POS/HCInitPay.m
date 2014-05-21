//
//  HCInitPay.m
//  HostedCheckout
//
//  Created by agharris73 on 9/4/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import "HCInitPay.h"

@interface HCInitPay ()

@end

@implementation HCInitPay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.autoresizesSubviews = YES;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)runInitPaymentRequest:(id)sender {
    
    NSMutableDictionary *dictionaryReq = [NSMutableDictionary new];
    [dictionaryReq setObject:@"018847445761734" forKey:@"MerchantID"];
    [dictionaryReq setObject:@"Y6@Mepyn!r0LsMNq" forKey:@"Password"];
    [dictionaryReq setObject:@"Sale" forKey:@"TranType"];
    [dictionaryReq setObject:@"OneTime" forKey:@"Frequency"];
    [dictionaryReq setObject:@"12345" forKey:@"Invoice"];
    [dictionaryReq setObject:@"2.50" forKey:@"TotalAmount"];
    [dictionaryReq setObject:@"0.25" forKey:@"TaxAmount"];
    [dictionaryReq setObject:@"HostedCheckou.Mobile.Dev.Kit.ObjC" forKey:@"Memo"];
    [dictionaryReq setObject:@"COMPLETED" forKey:@"ProcessCompleteURL"];
    [dictionaryReq setObject:@"CANCELED" forKey:@"ReturnURL"];
    [dictionaryReq setObject:@"Off" forKey:@"Keypad"];
    [dictionaryReq setObject:@"#CCCCCC" forKey:@"TotalAmountBackgroundColor"];
    [dictionaryReq setObject:@"Swipe" forKey:@"DefaultSwipe"];
    [dictionaryReq setObject:@"Both" forKey:@"CardEntryMethod"];
    [dictionaryReq setObject:@"Custom" forKey:@"DisplayStyle"];
    [dictionaryReq setObject:@"#CCCCCC" forKey:@"BackgroundColor"];
    [dictionaryReq setObject:@"#CCCCCC" forKey:@"ButtonBackgroundColor"];
    
    HCMercuryHelper *mgh = [HCMercuryHelper new];
    mgh.delegate = self;
    [mgh hctransctionFromDictionary:dictionaryReq andPassword:@"Y6@Mepyn!r0LsMNq"];
    
}

-(void) hctransactionDidFailWithError:(NSError *)error {
    
}

-(void) hctransactionDidFinish:(NSDictionary *)result {
    
    //NSMutableString *message = [NSMutableString new];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([result objectForKey:@"PaymentID"])
    {  
        appDelegate.pid = [result objectForKey:@"PaymentID"];
    }
    
    if ([result objectForKey:@"ResponseCode"])
    {
        appDelegate.responseCode = [result objectForKey:@"ResponseCode"];
    }
    
    if ([result objectForKey:@"Message"])
    {
        appDelegate.message = [result objectForKey:@"Message"];
    }
   
//    for (NSString *key in [result allKeys])
//    {
//        [message appendFormat:@"%@: %@;\n", key, [result objectForKey:key]];
//    }
//    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Result from Mercury"
//                                                   message: message
//                                                  delegate: self
//                                         cancelButtonTitle: nil
//                                         otherButtonTitles:@"OK",nil];
//    
//    [alert show];
    
    [self performSegueWithIdentifier:@"FirstSegue" sender:self];

}

@end
