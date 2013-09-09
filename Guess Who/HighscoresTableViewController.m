//
//  HighscoresTableViewController.m
//  Guess Who
//
//  Created by Dima on 5/30/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "HighscoresTableViewController.h"
#import "HighscoreCell.h"
#include <QuartzCore/QuartzCore.h>

@interface HighscoresTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *highscoresArray;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation HighscoresTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadHighscoresToArray];
    
    //view main background color
    [self.view setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:250.0/255.0 blue:233.0/255.0 alpha:1.0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //shadow
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        CALayer* shadowLayer = [self createShadowWithFrame:CGRectMake(0, 44, 320, 5)];
//        [self.view.layer addSublayer:shadowLayer];
//    }
    
    //setting NavBar
    self.toolbar.tintColor = [UIColor colorWithRed:116.0/255.0 green:150.0/255.0 blue:96.0/255.0 alpha:1.0];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

//-(CALayer *)createShadowWithFrame:(CGRect)frame
//{
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = frame;
//    
//    UIColor* lightColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
//    UIColor* darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//    
//    gradient.colors = [NSArray arrayWithObjects:(id)darkColor.CGColor, (id)lightColor.CGColor, nil];
//    
//    return gradient;
//}

- (void)loadHighscoresToArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"highscores"]) {
        NSMutableArray *arrayFromDisk = [defaults objectForKey:@"highscores"];
        self.highscoresArray = arrayFromDisk;
    } else {
        self.highscoresArray = [[NSMutableArray alloc] init];
    }
    NSLog(@"\n\n\nhighscore %@ \n\n\n", self.highscoresArray);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.highscoresArray.count;
}

- (HighscoreCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HighscoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *score = [NSString stringWithFormat:@"%@", [[self.highscoresArray objectAtIndex:indexPath.row] objectForKey:@"score"]];
    NSString *streak = [NSString stringWithFormat:@"%@", [[self.highscoresArray objectAtIndex:indexPath.row] objectForKey:@"streak"]];
    
    [cell.scoreLabel setText:score];
    [cell.streakLabel setText:streak];
    
    return cell;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearButtonPressed:(id)sender
{
    
}

@end
