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

@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic) NSUInteger currentQuestionIndex;
@property (nonatomic, strong) NSString* selectedAnswerString;
@property (nonatomic) NSInteger score;

- (id)initWithQuestionsCount:(NSUInteger)count;
- (void)nextQuestion;
- (void)checkAnswer;

@end
