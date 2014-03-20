//
//  HPListTableViewCell.h
//  RoomEase
//
//  Created by Desmond McNamee on 2014-03-17.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPListTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>
- (IBAction)onDeletePress:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *mainCellView;

@end
