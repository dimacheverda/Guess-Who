//
//  SummaryViewController.h
//  Expression
//
//  Created by Dima on 4/24/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryViewController : UIViewController

@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger longestStreak;

@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *longestStreakLabel;

@end
