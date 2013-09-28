//
//  MainMenuViewController.m
//  Expression
//
//  Created by Dima on 4/23/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "MainMenuViewController.h"
#import "PlaySessionViewController.h"

@interface MainMenuViewController ()

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *highscoresButton;
@property (nonatomic, weak) IBOutlet UIButton *aboutButton;
@property (nonatomic, weak) IBOutlet UILabel *mainTitleLabel;

@end

@implementation MainMenuViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self applyAppearance];
}

#define BUTTON_FILLED_GREEN @"myButtonFilledGreen"

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.screenName = @"Main Menu screen";
    
    //customizing buttons
    UIImage *buttonImage = [[UIImage imageNamed:BUTTON_FILLED_GREEN]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.playButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.highscoresButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.aboutButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    //view main background color
//    [self.view setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:250.0/255.0 blue:233.0/255.0 alpha:1.0]];
    
    //hidding NavBar
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self adjustForIPhone5];
    
    [self loadDatabase];
}

- (void)adjustForIPhone5
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    if ((screenRect.size.height == 568.0) || (screenRect.size.height == 548.0))
    {        
        screenRect = self.playButton.frame;
        screenRect.origin.y += 68.0;
        self.playButton.frame = screenRect;
        
        screenRect = self.highscoresButton.frame;
        screenRect.origin.y += 68.0;
        self.highscoresButton.frame = screenRect;
        
        screenRect = self.aboutButton.frame;
        screenRect.origin.y += 68.0;
        self.aboutButton.frame = screenRect;
    }
}

- (void)applyAppearance
{
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Gill Sans" size:20.0], UITextAttributeFont, nil]];
    
}

- (void)loadDatabase
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        
        //    NSString *plistPath;
        //    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //    plistPath = [rootPath stringByAppendingPathComponent:@"database.plist"];
        //    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        //        plistPath = [[NSBundle mainBundle] pathForResource:@"database" ofType:@"plist"];
        //    }
        //    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/100095175/database.plist"]];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.database = (NSMutableDictionary *)[NSPropertyListSerialization
                                                propertyListFromData:urlData
                                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                format:&format
                                                errorDescription:&errorDesc];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [self.database objectForKey:@"Appstore Link"];
        [defaults setObject:url forKey:@"Appstore Link"];
        [defaults synchronize];
        NSLog(@"\n\n\\nmain%@\n\n\n\n", url);
        if (!self.database) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }

    });
}

- (IBAction)playButtonPressed:(id)sender
{
    if (!self.database) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"Questions database naven't downloaded from internet. Check your network connection or wait for it to be downloaded."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        [self performSegueWithIdentifier:@"Play Session" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Play Session"]) {
        [segue.destinationViewController setQuestionDatabase:[self.database objectForKey:@"questions"]];
    }
}

@end
