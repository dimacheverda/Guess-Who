//
//  Question.m
//  Expression
//
//  Created by Dima on 4/24/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "Question.h"



@implementation Question

- (id)init:(NSUInteger)questionIndex
{
    if (self) {
        NSArray *questions = @[@"Who is USA president?",
                               @"Who invented electricity?",
                               @"Who played Batman in 'Batman' movie?",
                               @"Who developed 'Family Guy'"];
        
        NSArray *variants = @[@[@"Bill Clinton", @"Bill Gates", @"Barack Obama", @"George Bush"],
                              @[@"Tomas Edison", @"Nicola Tesla", @"Henry Ford", @"William Right"],
                              @[@"Hugh Jackman", @"Cristian Bale", @"Jason Statham", @"Chris Pine"],
                              @[@"Seth Green", @"Chery Chevapravadrumrong", @"Seth MacFarlane", @"Mathew Grooning"]];
        
        NSArray *anwsers = @[@"Barack Obama",
                             @"Tomas Edison",
                             @"Cristian Bale",
                             @"Seth MacFarlane"];
        NSArray *completition = @[@0.0, @0.46, @0.9, @0.8];
        
        self.question = [questions objectAtIndex:questionIndex];
        self.answer = [anwsers objectAtIndex:questionIndex];
        self.variants = [variants objectAtIndex:questionIndex];
        self.completition = [[completition objectAtIndex:questionIndex] unsignedIntegerValue];
    }
    return self;
}

@end
