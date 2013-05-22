//
//  Question.m
//  Expression
//
//  Created by Dima on 4/24/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "Question.h"

@implementation Question

- (id)initWithQuestionID:(NSUInteger)questionID fromQuestionDatabase:(NSArray *)questionDatabase
{
    if (self) {
        self.question = [[questionDatabase objectAtIndex:questionID] valueForKey:@"question"];
        self.answer = [[questionDatabase objectAtIndex:questionID] valueForKey:@"answer"];
        self.variants = [[questionDatabase objectAtIndex:questionID] valueForKey:@"variants"];
    }
    return self;
}

@end
