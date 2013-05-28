//
//  SummaryViewController.m
//  Expression
//
//  Created by Dima on 4/24/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    self.longestStreakLabel.text = [NSString stringWithFormat:@"Longest Streak: %d", self.longestStreak];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)mainMenuButtonPressed:(id)sender
{
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
