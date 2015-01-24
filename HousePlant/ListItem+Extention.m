//
//  ListItem+Extention.m
//  RoomEase
//
//  Created by Desmond McNamee on 2015-01-21.
//  Copyright (c) 2015 HousePlant. All rights reserved.
//

#import "ListItem+Extention.h"

@implementation ListItem (Extention)

- (void) copyAttributesFromListItem:(ListItem *) listItem {
    
    self.name = listItem.name;
    self.completedAt = listItem.completedAt;
    self.completedBy = listItem.completedBy;
    self.createdAt = listItem.createdAt;
    self.parseObjectId = listItem.parseObjectId;

}

@end
NSTimeInterval completedAt;
