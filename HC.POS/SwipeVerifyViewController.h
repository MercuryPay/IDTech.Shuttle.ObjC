//
//  SwipeVerifyViewController.h
//  Shuttle.Mobile.Starter.Kit
//
//  Created by agharris73 on 9/25/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MercuryHelper.h"

@interface SwipeVerifyViewController : UIViewController <MercuryHelperDelegate>

- (IBAction)swipeStep2:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
