//
//  PlaySession.m
//  Expression
//
//  Created by Dima on 4/24/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "PlaySession.h"

@interface PlaySession ()

@property (nonatomic, strong) NSMutableSet *usedQuestionsID;

@end

@implementation PlaySession

- (id)initWithQuestionsDatabase:(NSMutableArray *)questionDatabase
{
    if (self) {
        self.questionDatabase = questionDatabase;
    }
//    NSLog(@"%@", self.questionDatabase);
    return self;
}

#define COUNT 10

- (void)nextQuestion
{
    ++self.currentQuestionIndex;
    if (self.usedQuestionsID.count == COUNT) {
        [self.usedQuestionsID setSet:nil];
    }
    NSUInteger randomIndex = arc4random() % COUNT;
    while ([self.usedQuestionsID intersectsSet:[NSSet setWithObject:[NSNumber numberWithUnsignedInteger:randomIndex]]]) {
        randomIndex = arc4random() % COUNT;
    }
    [self.usedQuestionsID addObject:[NSNumber numberWithUnsignedInteger:randomIndex]];
    
    Question *currentQuestion = [[Question alloc] initWithQuestionID:randomIndex fromQuestionDatabase:self.questionDatabase];
    
    self.currentQuestion = currentQuestion;
//    NSLog(@"%@", self.currentQuestion.question);
//    NSLog(@"%@", self.currentQuestion.answer);
//    NSLog(@"%@", self.currentQuestion.variants);
//    NSLog(@"%@", self.usedQuestionsID);
}

- (NSMutableSet *)usedQuestionsID
{
    if (!_usedQuestionsID)
        _usedQuestionsID = [[NSMutableSet alloc] init];
    return _usedQuestionsID;
}

- (NSInteger)score
{
    if (!_score) {
        _score = 0;
    }
    return _score;
}

- (NSUInteger)currentQuestionIndex
{
    if (!_currentQuestionIndex) {
        _currentQuestionIndex = 0;
    }
    return _currentQuestionIndex;
}

- (NSInteger)numberOfWrongAnswers
{
    if (!_numberOfWrongAnswers) {
        _numberOfWrongAnswers = 0;
    }
    return _numberOfWrongAnswers;
}

#define TIME_MULTIPLIER 10;

- (void)checkAnswerWithTime:(NSInteger)time
{
//    NSLog(@"%d", time);
    if ([self.selectedAnswerString isEqualToString:self.currentQuestion.answer]) {
        self.score += 1000;
        self.score += time * TIME_MULTIPLIER;
    } else self.numberOfWrongAnswers++;
}

@end
