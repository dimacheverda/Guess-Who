//
//  SummaryViewController.m
//  Expression
//
//  Created by Dima on 4/24/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "SummaryViewController.h"
#import <Social/Social.h>

@interface SummaryViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *highscoreArray;
@property (nonatomic, strong) NSDictionary *scoreDictionary;
@property (nonatomic, weak) IBOutlet UIButton *mainMenuButton;
@property (nonatomic, weak) IBOutlet UILabel *isHighscoreLabel;
@property (nonatomic, strong) NSURL *urlForAppInAppStore;
@property (nonatomic, strong) UIImage *screenshotImage;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;

@end

@implementation SummaryViewController

#define BUTTON_FILLED_GREEN @"myButtonFilledGreen"

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.urlForAppInAppStore = [NSURL URLWithString:@"www.google.com"];
    
    //view main background color
//    [self.view setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:250.0/255.0 blue:233.0/255.0 alpha:1.0]];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    self.longestStreakLabel.text = [NSString stringWithFormat:@"Longest Streak: %d", self.longestStreak];
    
    UIImage *buttonImage = [[UIImage imageNamed:BUTTON_FILLED_GREEN]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.mainMenuButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:116.0/255.0 green:150.0/255.0 blue:96.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Gill Sans" size:20.0], UITextAttributeFont, nil]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Summary screen";
    
    NSDictionary *score = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.score], @"score", [NSNumber numberWithInteger:self.longestStreak], @"streak", nil];
    self.scoreDictionary = score;
    
    [self loadHighscores];
    
    [self checkIfHighscore];
    
    if (self.score != 0) {
        [self addScoreToHighscores];
    }
    if (self.score == 0) {
        self.tweetButton.enabled = NO;
        self.tweetButton.alpha = 0.0;
    }
    [self sortHighscores];
    [self saveHighscores];
}

- (UIImage *)takeScreenshot
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width), NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)sortHighscores
{
    NSArray *tempArray;
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    NSArray *DA = [NSArray arrayWithObject:descriptor];
    tempArray = [self.highscoreArray sortedArrayUsingDescriptors:DA];
    self.highscoreArray = [tempArray mutableCopy];
}

- (void)loadHighscores
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"highscores"]) {
        NSArray *arrayFromDisk = [defaults objectForKey:@"highscores"];
        self.highscoreArray = arrayFromDisk;
    } else {
        self.highscoreArray = [[NSArray alloc] init];
    }
}

- (void)checkIfHighscore
{
    if (self.highscoreArray.count != 0) {
        NSLog(@"%d", self.score);
        if ((self.score > 0) && ([[NSNumber numberWithInteger:self.score] integerValue] > [[[self.highscoreArray objectAtIndex:0] objectForKey:@"score"] integerValue])) {
            [self.isHighscoreLabel setAlpha:1.0];
            //        NSLog(@"1");
        } else {
            [self.isHighscoreLabel setAlpha:0.0];
            //        NSLog(@"2");
        }
    } else if (self.score > 0) {
        [self.isHighscoreLabel setAlpha:1.0];
    }
}

- (void)addScoreToHighscores
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.highscoreArray];
    [tempArray addObject:self.scoreDictionary];
    self.highscoreArray = [tempArray copy];
}

- (void)saveHighscores
{
    // Save the array
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.highscoreArray forKey:@"highscores"];
    [defaults synchronize];
    
    NSLog(@"\n\n\nsummary %@ \n\n\n", self.highscoreArray);
}

- (IBAction)mainMenuButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES]; 
}

- (IBAction)shareButtonPressed:(id)sender
{
//    NSString *actionSheetTitle = @"Share"; //Action Sheet Title
//    NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
    NSString *other1 = @"Post in Twitter";
    NSString *other2 = @"Post in Facebook";
    NSString *cancelTitle = @"Cancel";

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil//actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil//destructiveTitle
                                  otherButtonTitles:other1, other2, nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Destructive Button"]) {
        NSLog(@"Destructive pressed --> Delete Something");
    }
    
    if ([buttonTitle isEqualToString:@"Post in Twitter"]) {
        NSLog(@"Other 1 pressed");
        [self postToTwitterYourResult:nil];
    }
    
    if ([buttonTitle isEqualToString:@"Post in Facebook"]) {
        NSLog(@"Other 2 pressed");
        [self postToFacebookYourResult:nil];
    }
    
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
}

- (void)postToTwitterYourResult:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        self.screenshotImage = [self takeScreenshot];
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Check out my result in theQuiz! "];
        if (self.screenshotImage) {
            [tweetSheet addImage:self.screenshotImage];
        }
        if (self.urlForAppInAppStore) {
            [tweetSheet addURL:self.urlForAppInAppStore];
        }
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)postToFacebookYourResult:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        self.screenshotImage = [self takeScreenshot];
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:@"Check out my result in theQuiz! "];
        if (self.screenshotImage) {
            [facebookSheet addImage:self.screenshotImage];
        }
        if (self.urlForAppInAppStore) {
            [facebookSheet addURL:self.urlForAppInAppStore];
        }
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }

}

@end
