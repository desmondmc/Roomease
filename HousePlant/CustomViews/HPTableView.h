//
//  HPTableView.h
//  RoomEase
//
//  Created by Desmond McNamee on 2014-04-03.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMPAvatarView/AMPAvatarView.h>

@interface HPTableView : UITableView

- (void) checkCellWithCell:(UITableViewCell *)cell;

- (void) uncheckCellWithCell:(UITableViewCell *)cell;

@end
