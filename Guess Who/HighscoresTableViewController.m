//
//  HighscoresTableViewController.m
//  Guess Who
//
//  Created by Dima on 5/30/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "HighscoresTableViewController.h"
#import "HighscoreCell.h"
#import "EmptyCell.h"
#include <QuartzCore/QuartzCore.h>

@interface HighscoresTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *highscoresArray;

@end

@implementation HighscoresTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadHighscoresToArray];
    [self.navigationItem setTitle:@"Highscores"];
    
    //setting up NavBar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //view main background color
//    [self.view setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:250.0/255.0 blue:233.0/255.0 alpha:1.0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

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
    if (self.highscoresArray.count == 0) {
        return 1;
    }
    return self.highscoresArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *EmptyCellIdentifier = @"EmptyCell";
    NSLog(@"%d", self.highscoresArray.count);
    if (self.highscoresArray.count == 0) {
        EmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier forIndexPath:indexPath];
        return emptyCell;
    }
    else {
        HighscoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *score = [NSString stringWithFormat:@"%@", [[self.highscoresArray objectAtIndex:indexPath.row] objectForKey:@"score"]];
        NSString *streak = [NSString stringWithFormat:@"%@", [[self.highscoresArray objectAtIndex:indexPath.row] objectForKey:@"streak"]];
        
        [cell.scoreLabel setText:score];
        [cell.streakLabel setText:streak];
        
        return cell;
    }
}

- (IBAction)clearButtonPressed:(id)sender
{
    // Save the array
    NSArray *array = [[NSArray alloc] init];
    self.highscoresArray = array;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.highscoresArray forKey:@"highscores"];
    [defaults synchronize];
    [self.tableView reloadData];
    
    NSLog(@"\n\n\nsummary %@ \n\n\n", self.highscoresArray);

}

@end