//
//  HighscoreCell.h
//  Guess Who
//
//  Created by Dima on 7/15/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighscoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;

@end
