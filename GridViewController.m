//
//  GridViewController.m
//  XY25Grid
//
//  Created by Xiaoqian Yang on 3/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

#import "GridViewController.h"
#import <UIKit/UIKit.h>
#import <Masonry.h>

#define Top_Margin 30
#define Inter_Paddin 10
#define Grid_Width self.view.frame.size.width / 5
#define View_Width self.view.frame.size.width
#define View_Height self.view.frame.size.height
#define Button_Width 100
#define Button_Height 30
#define Label_Width 100

@interface GridViewController()
@property (nonatomic, strong) NSArray * originalButtons;
@property (nonatomic, strong) NSMutableArray * buttons;
@property (nonatomic, strong) UIButton * random;
@property (nonatomic) BOOL shouldFireTimerWhenViewAppears;
@end

@implementation GridViewController

- (id) init {
    if (self = [super init]) {
        self.buttons = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttons = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 25; ++i) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Grid_Width, Grid_Width)];
        button.tag = i;
        //button.titleLabel.text = [NSString stringWithFormat:@"%d",i];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blueColor]];
        [button setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        button.layer.borderWidth = 1;
        [button setEnabled:NO];
        
        [button addTarget:self action:@selector(gridTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttons addObject:button];
        
        [self.view addSubview:button];
    }
    
    _originalButtons = [NSArray arrayWithArray:_buttons];
    
    _random = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Button_Width, Button_Height)];
    [_random setTitle:NSLocalizedString(@"Start",nil) forState:UIControlStateNormal];
    [_random setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _random.backgroundColor = [UIColor yellowColor];
    [_random addTarget:self action:@selector(randomTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_random];
    [_random mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(Top_Margin + Button_Height + Inter_Paddin + Grid_Width*5 + Inter_Paddin);
        make.left.equalTo(self.view.mas_left).with.offset(Inter_Paddin);
        make.width.equalTo(@(Button_Width));
        make.height.equalTo(@(Button_Height));
        
    }];
    
    [self placeButtons];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Button_Width, Button_Height)];
    [_tipsLabel setBackgroundColor:[UIColor whiteColor]];
    [_tipsLabel setTextColor:[UIColor blackColor]];
    [_tipsLabel setText:NSLocalizedString(@"Press Start to begin",nil)];
    [self.view addSubview:_tipsLabel];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(Top_Margin);
        make.left.equalTo(self.view.mas_left).with.offset(Inter_Paddin);
        make.width.equalTo(@(View_Width - Label_Width));
        make.height.equalTo(@(Button_Height));
    }];

    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Button_Width, Button_Height)];
    [_timeLabel setBackgroundColor:[UIColor whiteColor]];
    [_timeLabel setTextColor:[UIColor redColor]];
    [_timeLabel setText:NSLocalizedString(@"0s", nil)];
    [_timeLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(Top_Margin);
        make.right.equalTo(self.view.mas_right).with.offset(-Inter_Paddin);
        make.width.equalTo(@(Label_Width));
        make.height.equalTo(@(Button_Height));
    }];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.shouldFireTimerWhenViewAppears = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
//    if ([self.timer isValid]) {
//        [self.timer invalidate];
//        self.shouldFireTimerWhenViewAppears = YES;
//    }
}

-(void)viewWillAppear:(BOOL)animated {
//    if (self.shouldFireTimerWhenViewAppears) {
//        [self.timer fire];
//        self.shouldFireTimerWhenViewAppears = NO;
//    }
}

#pragma mark IBAction

- (IBAction)gridTouched:(id)sender {
    if((UIButton*)sender == _nextButtonShouldBeTouched) {
        if (_nextButtonShouldBeTouched.tag == [_originalButtons count]) {
            [self setNextButtonShouldBeTouched:nil];
            [self removeTimer];
        }
        else {
            [self setNextButtonShouldBeTouched:[_originalButtons objectAtIndex:_nextButtonShouldBeTouched.tag]];
        }
    }
}

- (IBAction)randomTouched:(id)sender {
    for (int i = 0; i < [_buttons count]; i++) {
        int nElements = [_buttons count] - i;
        int n = (arc4random() % nElements) + i;
        [_buttons exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    [self placeButtons];
    
    [self setNextButtonShouldBeTouched:[_originalButtons objectAtIndex:0]];
    [self removeTimer];
    [self startTimer];
}

#pragma mark helpMethod

- (void) placeButtons {
    for (int i = 0; i < [_buttons count]; i++) {
        UIButton * button = _buttons[i];
        //[button mas_remakeConstraints:^(MASConstraintMaker *make) {
        //}];
    }

    for (int i = 0; i < [_buttons count]; i++) {
        int leftOffSet = i % 5 * Grid_Width;
        int topOffSet = Top_Margin + Button_Height + Inter_Paddin + (int)(i / 5) * Grid_Width;

        UIButton * button = _buttons[i];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(topOffSet);
            make.left.equalTo(self.view.mas_left).with.offset(leftOffSet);
            make.width.equalTo(@(Grid_Width));
            make.height.equalTo(@(Grid_Width));
        }];
    }
}

- (NSArray *) buttons {
    return _buttons;
}

- (NSArray *) originalButtons {
    return _originalButtons;
}

- (void)setNextButtonShouldBeTouched :(UIButton *) nextButtonShouldBeTouched {
    if (!nextButtonShouldBeTouched) {
        _nextButtonShouldBeTouched = nil;
        [_tipsLabel setText:NSLocalizedString(@"Well done",nil)];
    }
    else {
        _nextButtonShouldBeTouched = nextButtonShouldBeTouched;
        [_tipsLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Please Touch %ld",nil), (long)_nextButtonShouldBeTouched.tag]];
    }
    
    //set background color
//    if (nextButtonShouldBeTouched) {
//        [nextButtonShouldBeTouched setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
//        
//        //set previours button to normal background color;
//        int index = [_originalButtons indexOfObject:nextButtonShouldBeTouched];
//        if (index > 0) {
//            [[_originalButtons objectAtIndex:index] setBackgroundImage:nil forState:UIControlStateHighlighted];
//        }
//    }
//    else {
//        [[_originalButtons lastObject] setBackgroundImage:nil forState:UIControlStateHighlighted];
//    }

    if (nextButtonShouldBeTouched) {
        [nextButtonShouldBeTouched setEnabled:YES];
        
        //set previours button to normal background color;
        int index = [_originalButtons indexOfObject:nextButtonShouldBeTouched];
        if (index > 0) {
            [(UIButton*)[_originalButtons objectAtIndex:index-1] setEnabled:NO];
        }
    }
    else {
        [(UIButton*)[_originalButtons lastObject] setEnabled:NO];
    }
    
}

- (void)startTimer {
    //fire timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
    self.timeUsed = 0;
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

-(void)addTime {
    self.timeLabel.text = [NSString stringWithFormat:@"%d s",++self.timeUsed];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, Grid_Width, Grid_Width);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
