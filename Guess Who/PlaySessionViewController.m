//
//  PlaySessionViewController.m
//  Expression
//
//  Created by Dima on 4/23/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "PlaySessionViewController.h"


@interface PlaySessionViewController ()

@property (nonatomic, strong) NSString *selectedButtonTitle;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic) NSInteger time;

@property (weak, nonatomic) IBOutlet UIImageView *questionBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerOne;
@property (weak, nonatomic) IBOutlet UIButton *answerTwo;
@property (weak, nonatomic) IBOutlet UIButton *answerThree;
@property (weak, nonatomic) IBOutlet UIButton *answerFour;
@property (weak, nonatomic) IBOutlet UILabel *currentQuestionIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstErrorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondErrorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdErrorImageView;

@end


@implementation PlaySessionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.playSession = [[PlaySession alloc] initWithQuestionsDatabase:self.questionDatabase];
    [self refreshScore];
    [self.playSession nextQuestion];
    [self loadQuestion];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"greenButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.answerOne setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.answerTwo setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.answerThree setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.answerFour setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [self.questionBackgroundImageView setImage:buttonImage];
    
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-pattern"]]];
    
}

- (void)loadQuestion
{
    self.questionLabel.text = self.playSession.currentQuestion.question;
    [self shuffleAnswers:self.playSession.currentQuestion.variants];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Question №%d", self.playSession.currentQuestionIndex];
//    self.currentQuestionIndexLabel.text = [NSString stringWithFormat:@"Question №%d", self.playSession.currentQuestionIndex];
    
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
    [self.playSession checkAnswerWithTime:self.time];
    [self refreshScore];
    [self checkErrors];
    
    //    NSLog(@"%d", self.playSession.numberOfWrongAnswers);
    
    if (self.playSession.numberOfWrongAnswers < 3) {
        [self.playSession nextQuestion];
        [self loadQuestion];
    } else {
        //        [NSThread sleepForTimeInterval:2.0];
        self.questionLabel.text = @"The End";
        [self performSegueWithIdentifier:@"Show Summary" sender:self];
    }
}

#define TIME_FOR_ANSWER 30;

- (void)initTimer
{
    self.time = 1 + TIME_FOR_ANSWER;
    [self timerTick];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerTick
{
    if (!(self.time == 0)) {
        self.time--;
    }
    NSString* timeNow = [NSString stringWithFormat:@"Time: %02d", self.time];
//    NSLog(@"%@", timeNow);
    self.timeLabel.text = timeNow;
}

- (void)stopTimer
{
    [self.timer invalidate];
    NSString* timeNow = [NSString stringWithFormat:@"Time: %02d", self.time];
    self.timeLabel.text= timeNow;
}

- (void)refreshScore
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.playSession.score]];
}


- (void)checkErrors
{
    if (self.playSession.numberOfWrongAnswers >= 1) {
        self.firstErrorImageView.image = [UIImage imageNamed:@"error_image"];
    }
    if (self.playSession.numberOfWrongAnswers >= 2) {
        self.secondErrorImageView.image = [UIImage imageNamed:@"error_image"];
    }
    if (self.playSession.numberOfWrongAnswers >= 3) {
        self.thirdErrorImageView.image = [UIImage imageNamed:@"error_image"];
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