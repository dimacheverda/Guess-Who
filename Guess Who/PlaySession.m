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
@property (nonatomic) NSUInteger COUNT;

@end

@implementation PlaySession

- (id)initWithQuestionsDatabase:(NSMutableArray *)questionDatabase
{
    if (self) {
        self.COUNT = questionDatabase.count;
        self.questionDatabase = questionDatabase;
        self.currentStreak = 0;
        self.longestStreak = 0;
    }
    return self;
}

- (void)nextQuestion
{
    ++self.currentQuestionIndex;
    if (self.usedQuestionsID.count == self.COUNT) {
        [self.usedQuestionsID setSet:nil];
    }
    NSUInteger randomIndex = arc4random() % self.COUNT;
    while ([self.usedQuestionsID intersectsSet:[NSSet setWithObject:[NSNumber numberWithUnsignedInteger:randomIndex]]]) {
        randomIndex = arc4random() % self.COUNT;
    }
    [self.usedQuestionsID addObject:[NSNumber numberWithUnsignedInteger:randomIndex]];
    
    Question *currentQuestion = [[Question alloc] initWithQuestionID:randomIndex fromQuestionDatabase:self.questionDatabase];
    
    self.currentQuestion = currentQuestion;
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

#define TIME_MULTIPLIER 21;
#define RIGHT_ANSWER_SCORE 957;
#define STREAK_BONUS 49;

- (BOOL)checkAnswerWithTime:(NSInteger)time
{
    if ([self.selectedAnswerString isEqualToString:self.currentQuestion.answer]) {
        self.currentStreak++;
        self.score += RIGHT_ANSWER_SCORE;
        self.score += time * TIME_MULTIPLIER;
        self.score += self.currentStreak * STREAK_BONUS;
        if (self.currentStreak > self.longestStreak) {
            self.longestStreak = self.currentStreak;
        }
        return YES;
    } else {
        self.numberOfWrongAnswers++;
        self.currentStreak = 0;
        return NO;
    }
}

@end
