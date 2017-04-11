//
//  GridViewController.h
//  XY25Grid
//
//  Created by Xiaoqian Yang on 3/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GridViewController : UIViewController

@property (nonatomic, strong) UIButton * nextButtonShouldBeTouched;
@property (nonatomic, strong) UILabel * tipsLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic) int timeUsed;

- (NSArray *) buttons;
- (NSArray *) originalButtons;
- (IBAction)randomTouched:(id)sender;
- (IBAction)gridTouched:(id)sender;
@end
