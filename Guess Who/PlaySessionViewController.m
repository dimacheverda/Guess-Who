//
//  PlaySessionViewController.m
//  Expression
//
//  Created by Dima on 4/23/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "PlaySessionViewController.h"
#include <QuartzCore/QuartzCore.h>

@interface PlaySessionViewController () {
    UIImage *buttonImageNormal;
    UIImage *buttonImageHighlighted;
    UIImage *buttonRightAnswer;
    UIImage *buttonWrongAnswer;
}

@property (nonatomic, strong) NSString *selectedButtonTitle;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger time;

@property (weak, nonatomic) IBOutlet UIImageView *questionBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerOne;
@property (weak, nonatomic) IBOutlet UIButton *answerTwo;
@property (weak, nonatomic) IBOutlet UIButton *answerThree;
@property (weak, nonatomic) IBOutlet UIButton *answerFour;
@property (weak, nonatomic) IBOutlet UIImageView *footerBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *timeProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *firstErrorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondErrorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdErrorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *clockImageView;

@end

@implementation PlaySessionViewController

#define BUTTON_NORMAL_GREEN @"myButtonNormalGreen"
#define BUTTON_HIGHLIGHTED_GREEN @"myButtonHighlightedGreen"
#define BUTTON_WRONG_ANSWER_RED @"myButtonWrongAnswerRed"
#define BUTTON_RIGHT_ANSWER_GREEN @"myButtonRightAnswerGreen"

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //setting up NavBar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //init data
    self.playSession = [[PlaySession alloc] initWithQuestionsDatabase:self.questionDatabase];
    [self refreshScore];
    [self.playSession nextQuestion];
    [self loadQuestion];
    
    //shadow
//    CALayer* shadowLayer = [self createShadowWithFrame:CGRectMake(0, 0, 320, 5)];
//    [self.view.layer addSublayer:shadowLayer];
    
    //setting buttons state images and colors
    buttonImageNormal = [[UIImage imageNamed:BUTTON_NORMAL_GREEN]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    buttonImageHighlighted = [[UIImage imageNamed:BUTTON_HIGHLIGHTED_GREEN]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.answerOne setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [self.answerTwo setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [self.answerThree setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [self.answerFour setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [self.answerOne setBackgroundImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    [self.answerTwo setBackgroundImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    [self.answerThree setBackgroundImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    [self.answerFour setBackgroundImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    [self.answerOne setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.answerTwo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.answerThree setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.answerFour setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    //view main background color
//    [self.view setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:250.0/255.0 blue:233.0/255.0 alpha:1.0]];
    
    //footerColor
    UIImage *footerImage = [[UIImage imageNamed:@"footerImage"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    self.footerBackgroundImageView.image = footerImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self adjustForIPhone5];
    
    self.screenName = @"Play Session screen";
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(CALayer *)createShadowWithFrame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    
    UIColor* lightColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    UIColor* darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    gradient.colors = [NSArray arrayWithObjects:(id)darkColor.CGColor, (id)lightColor.CGColor, nil];
    
    return gradient;
}

- (void)adjustForIPhone5
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    if ((screenRect.size.height == 568.0) || (screenRect.size.height == 548.0))
    {
        screenRect = self.questionBackgroundImageView.frame;
        screenRect.size.height += 22.0;
        self.questionBackgroundImageView.frame = screenRect;
        
        screenRect = self.questionLabel.frame;
        screenRect.size.height += 22.0;
        self.questionLabel.frame = screenRect;
        
        screenRect = self.answerOne.frame;
        screenRect.origin.y += 44.0;
        self.answerOne.frame = screenRect;
        
        screenRect = self.answerTwo.frame;
        screenRect.origin.y += 44.0;
        self.answerTwo.frame = screenRect;
        
        screenRect = self.answerThree.frame;
        screenRect.origin.y += 44.0;
        self.answerThree.frame = screenRect;
        
        screenRect = self.answerFour.frame;
        screenRect.origin.y += 44.0;
        self.answerFour.frame = screenRect;
        
        screenRect = self.footerBackgroundImageView.frame;
        screenRect.origin.y += 88.0;
        self.footerBackgroundImageView.frame = screenRect;
        
        screenRect = self.scoreLabel.frame;
        screenRect.origin.y += 88.0;
        self.scoreLabel.frame = screenRect;
        
        screenRect = self.timeProgressView.frame;
        screenRect.origin.y += 88.0;
        self.timeProgressView.frame = screenRect;
        
        screenRect = self.firstErrorImageView.frame;
        screenRect.origin.y += 88.0;
        self.firstErrorImageView.frame = screenRect;
        
        screenRect = self.secondErrorImageView.frame;
        screenRect.origin.y += 88.0;
        self.secondErrorImageView.frame = screenRect;
        
        screenRect = self.thirdErrorImageView.frame;
        screenRect.origin.y += 88.0;
        self.thirdErrorImageView.frame = screenRect;
        
        screenRect = self.streakLabel.frame;
        screenRect.origin.y += 88.0;
        self.streakLabel.frame = screenRect;
        
        screenRect = self.clockImageView.frame;
        screenRect.origin.y += 88.0;
        self.clockImageView.frame = screenRect;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self stopTimer];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadQuestion
{
    self.questionLabel.text = self.playSession.currentQuestion.question;
    self.navigationItem.title = [NSString stringWithFormat:@"Question №%d", self.playSession.currentQuestionIndex];
    [self shuffleAnswers:self.playSession.currentQuestion.variants];
    [self initTimer];
}

- (void)shuffleAnswers:(NSArray *)variants
{
    NSMutableArray *used = [[NSMutableArray alloc] initWithObjects:@0, @0, @0, @0, nil];
    int index = arc4random() % 4;
    
    [self.answerOne setTitle:[variants objectAtIndex:index] forState:UIControlStateNormal];
    [used replaceObjectAtIndex:index withObject:@1];

    while ([[used objectAtIndex:index] isEqual:@1]) {
        index = arc4random() % 4;
    }
    [self.answerTwo setTitle:[variants objectAtIndex:index] forState:UIControlStateNormal];
    [used replaceObjectAtIndex:index withObject:@1];
    
    while ([[used objectAtIndex:index] isEqual:@1]) {
        index = arc4random() % 4;
    }
    [self.answerThree setTitle:[variants objectAtIndex:index] forState:UIControlStateNormal];
    [used replaceObjectAtIndex:index withObject:@1];
    
    while ([[used objectAtIndex:index] isEqual:@1]) {
        index = arc4random() % 4;
    }
    [self.answerFour setTitle:[variants objectAtIndex:index] forState:UIControlStateNormal];
    [used replaceObjectAtIndex:index withObject:@1];
}

- (IBAction)answerButtonPressed:(UIButton *)sender
{
    self.selectedButtonTitle = sender.titleLabel.text;    
    
    self.playSession.selectedAnswerString = self.selectedButtonTitle;
    [self stopTimer];
    BOOL isAnswerRight = [self.playSession checkAnswerWithTime:self.time];
    
    [self refreshScore];
    
    buttonRightAnswer = [[UIImage imageNamed:BUTTON_RIGHT_ANSWER_GREEN]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    buttonWrongAnswer = [[UIImage imageNamed:BUTTON_WRONG_ANSWER_RED]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];

    if (isAnswerRight) {
        [self setImageBackground:buttonRightAnswer forButton:sender];
    } else {
        [self setImageBackground:buttonWrongAnswer forButton:sender];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self
                                   selector:@selector(completeChecking)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)completeChecking
{
    [NSThread sleepForTimeInterval:0.2];
    [self setImageBackground:buttonImageNormal forButton:self.answerOne];
    [self setImageBackground:buttonImageNormal forButton:self.answerTwo];
    [self setImageBackground:buttonImageNormal forButton:self.answerThree];
    [self setImageBackground:buttonImageNormal forButton:self.answerFour];
    
    [self checkErrors];
    
    if (self.playSession.numberOfWrongAnswers < 3) {
        [self.playSession nextQuestion];
        [self loadQuestion];
    } else {
        [self terminateSession];
    }
}

- (void)setImageBackground:(UIImage *)image forButton:(UIButton *)button
{
    [button setBackgroundImage:image forState:UIControlStateNormal];
}

#define TIME_FOR_ANSWER 30;

- (void)terminateSession
{
    self.questionLabel.text = @"The End";
    [self performSegueWithIdentifier:@"Show Summary" sender:self];
}

- (void)initTimer
{
    self.time = 1 + TIME_FOR_ANSWER;
    [self timerTick];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                selector:@selector(timerTick)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerTick
{
    if (!(self.time == 0)) {
        self.time--;
    }
    
    //adjusting progress bar color
    [self.timeProgressView setProgress:self.time/30.0];
    
    if (self.time <= 0.0) {
        [self stopTimer];
        [self terminateSession];
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    [self.timeProgressView setProgress:self.time/30.0];
}

- (void)refreshScore
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.playSession.score]];
    [self.streakLabel setText:[NSString stringWithFormat:@"Streak: %d", self.playSession.currentStreak]];
}

#define errorEnabledImage @"errorEnabled"

- (void)checkErrors
{
    if (self.playSession.numberOfWrongAnswers >= 1) {
        self.firstErrorImageView.image = [UIImage imageNamed:errorEnabledImage];
    }
    if (self.playSession.numberOfWrongAnswers >= 2) {
        self.secondErrorImageView.image = [UIImage imageNamed:errorEnabledImage];
    }
    if (self.playSession.numberOfWrongAnswers >= 3) {
        self.thirdErrorImageView.image = [UIImage imageNamed:errorEnabledImage];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Summary"]) {
        [segue.destinationViewController setScore:self.playSession.score];
        [segue.destinationViewController setLongestStreak:self.playSession.longestStreak];
    }
}

@end