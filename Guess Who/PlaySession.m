//
//  PlaySession.m
//  Expression
//
//  Created by Dima on 4/24/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "PlaySession.h"

@interface PlaySession ()

@end

@implementation PlaySession

- (id)initWithQuestionsCount:(NSUInteger)count
{
    if (self) {
        self.currentQuestionIndex = 0;
        for (int i = 0; i < count; i++) {
            [self addQuestion];
            self.currentQuestionIndex++;
        }
        self.currentQuestionIndex = 0;
    }
    return self;
}

- (void)nextQuestion
{
    ++self.currentQuestionIndex;
}

- (NSInteger)score
{
    if (!_score) {
        _score = 0;
    }
    return _score;
}

- (void)addQuestion
{
    Question *question = [[Question alloc] init:self.currentQuestionIndex];
    if (!self.questions) {
        self.questions = [[NSMutableArray alloc] init];
    }
    [self.questions addObject:question];
}

- (void)checkAnswer
{
    Question *question = [self.questions objectAtIndex:self.currentQuestionIndex];
    NSString *rightAnswer = question.answer;
    if ([self.selectedAnswerString isEqualToString:rightAnswer]) {
        self.score += 10;
    }
}

@end
