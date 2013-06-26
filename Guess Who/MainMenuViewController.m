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

@end

@implementation MainMenuViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //customizing buttons
    NSString *buttonFilled = @"myButtonFill.png";
    
    UIImage *buttonImage = [[UIImage imageNamed:buttonFilled]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.playButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.highscoresButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.aboutButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    //hidding NavBar
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDatabase];
}

- (void)loadDatabase
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"database.plist"];
//    NSLog(@"path: %@",plistPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"database" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    
    self.database = (NSMutableDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!self.database) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
//    NSLog(@"%@", self.database);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Play Session"]) {
        [segue.destinationViewController setQuestionDatabase:[self.database objectForKey:@"questions"]];
    }
}

@end
