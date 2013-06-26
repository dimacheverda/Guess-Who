//
//  SummaryViewController.m
//  Expression
//
//  Created by Dima on 4/24/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()

@property (nonatomic, strong) NSMutableArray *highscoreArray;
@property (nonatomic, strong) NSDictionary *scoreDictionary;
@property (nonatomic, weak) IBOutlet UIButton *mainMenuButton;

@end

@implementation SummaryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    self.longestStreakLabel.text = [NSString stringWithFormat:@"Longest Streak: %d", self.longestStreak];
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-pattern"]]];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"greenButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.mainMenuButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *score = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.score], @"score", [NSNumber numberWithInteger:self.longestStreak], @"streak", nil];
    self.scoreDictionary = score;
    
    [self loadHighscores];
    [self addScoreToHighscores];
    [self saveHighscores];
    
//    self.navigationItem.hidesBackButton = YES;
}

- (void)loadHighscores
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"highscores.plist"];
//    NSLog(@"path: %@",plistPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"highscores" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    
    self.highscoreArray = (NSMutableArray *)[NSPropertyListSerialization
                                            propertyListFromData:plistXML
                                            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                            format:&format
                                            errorDescription:&errorDesc];
    if (!self.highscoreArray) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
//    NSLog(@"%@", plistPath);
//    NSLog(@"%@", self.highscoreArray);
    
}

- (BOOL)isHighscore
{
    if ([NSNumber numberWithInteger:self.score] > [[self.highscoreArray objectAtIndex:0] objectForKey:@"score"]) {
        return YES;
    } else
        return NO;
}

- (void)addScoreToHighscores
{    
    [self.highscoreArray addObject:self.scoreDictionary];
}

- (void)saveHighscores
{
    NSString *error;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"highscores" ofType:@"plist"];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:self.highscoreArray
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
//    NSLog(@"%@", self.scoreDictionary);
//    NSLog(@"%@", self.highscoreArray);
    if (plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
}

- (IBAction)mainMenuButtonPressed:(id)sender
{
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil]; //for modal segue
    [self.navigationController popToRootViewControllerAnimated:YES]; 
}

@end
