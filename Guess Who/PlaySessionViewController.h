//
//  PlaySessionViewController.h
//  Expression
//
//  Created by Dima on 4/23/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaySession.h"

@interface PlaySessionViewController : UIViewController

@property (nonatomic, strong) PlaySession *playSession;
@property (nonatomic ,strong) NSMutableArray *questionDatabase;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end
