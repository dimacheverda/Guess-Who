//
//  PlaySessionViewController.h
//  Expression
//
//  Created by Dima on 4/23/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaySession.h"

@interface PlaySessionViewController : UIViewController

@property (nonatomic, strong) PlaySession *playSession;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerOne;
@property (weak, nonatomic) IBOutlet UIButton *answerTwo;
@property (weak, nonatomic) IBOutlet UIButton *answerThree;
@property (weak, nonatomic) IBOutlet UIButton *answerFour;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
