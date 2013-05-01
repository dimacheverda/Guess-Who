//
//  PlaySessionViewController.m
//  Expression
//
//  Created by Dima on 4/23/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "PlaySessionViewController.h"


@interface PlaySessionViewController ()

@property (nonatomic) NSString* selectedButtonTitle;
@property (weak, nonatomic) IBOutlet UILabel *currentQuestionIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


- (IBAction)answerButtonTouchDown;

@end

@implementation PlaySessionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.playSession = [[PlaySession alloc] initWithQuestionsCount:4];
    [self loadQuestion];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshScore];
}

- (void)loadQuestion
{
    [self.answerOne setHighlighted:NO];
    [self.answerTwo setHighlighted:NO];
    [self.answerThree setHighlighted:NO];
    [self.answerFour setHighlighted:NO];
    
    Question *question = [self.playSession.questions objectAtIndex:self.playSession.currentQuestionIndex];
    self.questionLabel.text = question.question;
    
    [self shuffleAnswers:question.variants];
    
    self.progressView.progress = self.playSession.currentQuestionIndex / 4.0;
    self.currentQuestionIndexLabel.text = [NSString stringWithFormat:@"%d/10", (self.playSession.currentQuestionIndex + 1)];
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
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
}

- (void)refreshScore
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.playSession.score]];
}

- (IBAction)nextButtonPressed:(id)sender
{
    self.playSession.selectedAnswerString = self.selectedButtonTitle;
    [self.playSession checkAnswer];
    [self refreshScore];
    if (self.playSession.currentQuestionIndex < 3) {
        [self.playSession nextQuestion];
        [self loadQuestion];
    } else {
        self.progressView.progress = 1.0;
        self.questionLabel.text = @"The End";
        [self performSegueWithIdentifier:@"Show Summary" sender:self];
    }
}

@end
