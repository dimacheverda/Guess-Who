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

@property (weak, nonatomic) IBOutlet UIButton *answerOne;
@property (weak, nonatomic) IBOutlet UIButton *answerTwo;
@property (weak, nonatomic) IBOutlet UIButton *answerThree;
@property (weak, nonatomic) IBOutlet UIButton *answerFour;
@property (weak, nonatomic) IBOutlet UILabel *currentQuestionIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)answerButtonTouchDown;

@end


@implementation PlaySessionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.playSession = [[PlaySession alloc] initWithQuestionsDatabase:self.questionDatabase];
    [self refreshScore];
    [self.playSession nextQuestion];
    [self loadQuestion];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadQuestion
{
    [self answerButtonTouchDown];
    self.questionLabel.text = self.playSession.currentQuestion.question;
    [self shuffleAnswers:self.playSession.currentQuestion.variants];
    self.currentQuestionIndexLabel.text = [NSString stringWithFormat:@"№%d", self.playSession.currentQuestionIndex];
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

- (IBAction)answerButtonTouchDown
{
    [self.answerOne setHighlighted:NO];
    [self.answerTwo setHighlighted:NO];
    [self.answerThree setHighlighted:NO];
    [self.answerFour setHighlighted:NO];
}

- (void)highlightButton:(UIButton *)button
{
    [self.answerOne setHighlighted:NO];
    [self.answerTwo setHighlighted:NO];
    [self.answerThree setHighlighted:NO];
    [self.answerFour setHighlighted:NO];
    [button setHighlighted:YES];
}

- (IBAction)answerButtonPressed:(UIButton *)sender
{
    self.selectedButtonTitle = sender.titleLabel.text;
//    NSLog(@"%@", self.selectedButtonTitle);
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
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
    NSString* timeNow = [NSString stringWithFormat:@"%02d", self.time];
//    NSLog(@"%@", timeNow);
    self.timeLabel.text = timeNow;
}

- (void)stopTimer
{
    [self.timer invalidate];
    NSString* timeNow = [NSString stringWithFormat:@"%02d", self.time];
    self.timeLabel.text= timeNow;
}

- (void)refreshScore
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.playSession.score]];
}

- (IBAction)nextButtonPressed:(id)sender
{
    self.playSession.selectedAnswerString = self.selectedButtonTitle;
    [self stopTimer];
    [self.playSession checkAnswerWithTime:self.time];
    [self refreshScore];
    
//    NSLog(@"%d", self.playSession.numberOfWrongAnswers);
    
    if (self.playSession.numberOfWrongAnswers < 3) {
        [self.playSession nextQuestion];
        [self loadQuestion];
    } else {
        [NSThread sleepForTimeInterval:2.0];
        self.questionLabel.text = @"The End";
        [self performSegueWithIdentifier:@"Show Summary" sender:self];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Summary"]) {
        
    }
}

@end