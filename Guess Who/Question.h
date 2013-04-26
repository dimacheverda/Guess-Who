//
//  Question.h
//  Expression
//
//  Created by Dima on 4/24/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSArray *variants;
@property (nonatomic) NSUInteger completition;

- (id)init:(NSUInteger)questionIndex;

@end
