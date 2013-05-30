//
//  HighscoresTableViewController.m
//  Guess Who
//
//  Created by Dima on 5/30/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "HighscoresTableViewController.h"

@interface HighscoresTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *highscoresArray;

@end

@implementation HighscoresTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadHighscoresToArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadHighscoresToArray
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
    
    self.highscoresArray = (NSMutableArray *)[NSPropertyListSerialization
                                             propertyListFromData:plistXML
                                             mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                             format:&format
                                             errorDescription:&errorDesc];
    if (!self.highscoresArray) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
//    NSLog(@"%@", self.highscoresArray);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.highscoresArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *score = [NSString stringWithFormat:@"%@", [[self.highscoresArray objectAtIndex:indexPath.row] objectForKey:@"score"]];
    NSString *streak = [NSString stringWithFormat:@"%@", [[self.highscoresArray objectAtIndex:indexPath.row] objectForKey:@"streak"]];
    
    [cell.textLabel setText:score];
    [cell.detailTextLabel setText:streak];
    
    return cell;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
