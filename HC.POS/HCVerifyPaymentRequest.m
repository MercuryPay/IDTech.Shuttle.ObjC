//
//  HCVerifyPaymentRequest.m
//  HostedCheckout
//
//  Created by agharris73 on 9/4/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import "HCVerifyPaymentRequest.h"

@interface HCVerifyPaymentRequest ()

@end

@implementation HCVerifyPaymentRequest

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

- (IBAction)runHCVerifyPaymentRequest:(id)sender {
    
    NSMutableDictionary *dictionaryReq = [NSMutableDictionary new];
    [dictionaryReq setObject:@"018847445761734" forKey:@"MerchantID"];
    [dictionaryReq setObject:@"Y6@Mepyn!r0LsMNq" forKey:@"Password"];
    [dictionaryReq setObject:@"%@" forKey:@"PaymentID"];
    
    HCMercuryHelper *mgh = [HCMercuryHelper new];
    mgh.delegate = self;
    [mgh hcVerifyFromDictionary:dictionaryReq andPassword:@"Y6@Mepyn!r0LsMNq"];
}

-(void) hctransactionDidFailWithError:(NSError *)error {
    
}
    
-(void) hctransactionDidFinish:(NSDictionary *)result {
    
    //NSMutableString *message = [NSMutableString new];
        
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
    if ([result objectForKey:@"Status"])
    {
            appDelegate.status = [result objectForKey:@"Status"];
    }
    if ([result objectForKey:@"TranType"])
    {
            appDelegate.tranType = [result objectForKey:@"TranType"];
    }
    if ([result objectForKey:@"AuthCode"])
    {
            appDelegate.authCode = [result objectForKey:@"AuthCode"];
    }
    if ([result objectForKey:@"AuthAmount"])
    {
            appDelegate.authAmount = [result objectForKey:@"AuthAmount"];
    }
    if ([result objectForKey:@"Amount"])
    {
            appDelegate.amount = [result objectForKey:@"Amount"];
    }    
    if ([result objectForKey:@"TaxAmount"])
    {
            appDelegate.taxAmt = [result objectForKey:@"TaxAmount"];
    }
    if ([result objectForKey:@"AcqRefData"])
    {
            appDelegate.acqRefData = [result objectForKey:@"AcqRefData"];
    }
    if ([result objectForKey:@"CardType"])
    {
            appDelegate.cardType = [result objectForKey:@"CardType"];
    }
    if ([result objectForKey:@"DisplayMessage"])
    {
            appDelegate.displayMessage = [result objectForKey:@"DisplayMessage"];
    }
    if ([result objectForKey:@"ExpDate"])
    {
            appDelegate.expDate = [result objectForKey:@"ExpDate"];
    }
    if ([result objectForKey:@"Invoice"])
    {
            appDelegate.invoice = [result objectForKey:@"Invoice"];
    }
    if ([result objectForKey:@"MaskedAccount"])
    {
            appDelegate.maskedAccount = [result objectForKey:@"MaskedAccount"];
    }
    if ([result objectForKey:@"RefNo"])
    {
            appDelegate.refNo = [result objectForKey:@"RefNo"];
    }
    if ([result objectForKey:@"ResonseCode"])
    {
            appDelegate.responseCode = [result objectForKey:@"ResponseCode"];
    }
    if ([result objectForKey:@"StatusMessage"])
    {
            appDelegate.statusMessage = [result objectForKey:@"StatusMessage"];
    }
    if ([result objectForKey:@"Token"])
    {
            appDelegate.token = [result objectForKey:@"Token"];
    }
    if ([result objectForKey:@"TransPostTime"])
    {
            appDelegate.transPostTime = [result objectForKey:@"TransPostTime"];
    }
    if ([result objectForKey:@"CvvResult"])
    {
            appDelegate.cvvResult = [result objectForKey:@"CvvResult"];
    }
    
    [self performSegueWithIdentifier:@"FifthSegue" sender:self];
    
    }

@end
