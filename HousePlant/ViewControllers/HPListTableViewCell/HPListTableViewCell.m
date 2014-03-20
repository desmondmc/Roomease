//
//  HPListTableViewCell.m
//  RoomEase
//
//  Created by Desmond McNamee on 2014-03-17.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPListTableViewCell.h"

#define CLOSED_SLIDER_X 0
#define OPEN_SLIDER_X -64

@implementation HPListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    
    if (_mainCellView.frame.origin.x >= CLOSED_SLIDER_X && translation.x > 0) {
        return;
    }
    if (_mainCellView.frame.origin.x <= OPEN_SLIDER_X && translation.x < 0) {
        return;
    }
    
    if (_mainCellView.center.x + translation.x > 160) {
        _mainCellView.center = CGPointMake(160,
                                           _mainCellView.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        return;
    }
    if (_mainCellView.center.x + translation.x < 160 + OPEN_SLIDER_X ) {
        _mainCellView.center = CGPointMake(160 + OPEN_SLIDER_X,
                                           _mainCellView.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        return;
    }
    
    _mainCellView.center = CGPointMake(_mainCellView.center.x + translation.x,
                                       _mainCellView.center.y);


    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

- (IBAction)onDeletePress:(id)sender {
    NSLog(@"Press");
}
@end
