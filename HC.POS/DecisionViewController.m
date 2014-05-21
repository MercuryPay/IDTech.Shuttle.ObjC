//
//  DecisionViewController.m
//  Shuttle.ObjC
//
//  Created by agharris73 on 9/18/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import "DecisionViewController.h"
#import "AppDelegate.h"

@interface DecisionViewController ()

@end

@implementation DecisionViewController

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

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate reset];
    
//    NSArray *imageNames = @[@"offline.png", @"online.png"];
//    
//    NSMutableArray *images = [[NSMutableArray alloc] init];
//    for (int i = 0; i < imageNames.count; i++) {
//        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
//    }
//    
//    // Normal Animation
//    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(375, 515, 51, 61)];
//    
//    animationImageView.animationImages = images;
//    animationImageView.animationDuration = 0.5;
//    
//    [self.view addSubview:animationImageView];
//    
//    [animationImageView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
