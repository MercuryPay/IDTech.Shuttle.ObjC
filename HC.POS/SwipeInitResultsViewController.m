//
//  SwipeInitResultsViewController.m
//  Shuttle.Mobile.Starter.Kit
//
//  Created by agharris73 on 9/19/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import "SwipeInitResultsViewController.h"
#import "AppDelegate.h"

@interface SwipeInitResultsViewController ()

@end

@implementation SwipeInitResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    EncryptedSwipeData *esd = appDelegate.encryptedSwipeData;
    self.maskedTrack2DataResult.text = esd.track2Masked;
    self.encryptedTrack2DataResult.text = esd.track2Encrypted;
    self.ksnResult.text = esd.ksn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
