//
//  PlaySession.h
//  Expression
//
//  Created by Dima on 4/24/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface PlaySession : NSObject

@property (nonatomic, strong) NSMutableArray *questionDatabase;
@property (nonatomic, strong) Question *currentQuestion;
@property (nonatomic) NSUInteger currentQuestionIndex;
@property (nonatomic, strong) NSString* selectedAnswerString;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger numberOfWrongAnswers;
@property (nonatomic) NSInteger currentStreak;
@property (nonatomic) NSInteger longestStreak;

- (id)initWithQuestionsDatabase:(NSMutableArray *)questionDatabase;
- (void)nextQuestion;
- (BOOL)checkAnswerWithTime:(NSInteger)time;
@end
