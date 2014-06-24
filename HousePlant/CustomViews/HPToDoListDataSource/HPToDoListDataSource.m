//
//  HPToDoListDataSource.m
//  RoomEase
//
//  Created by Desmond McNamee on 2014-04-16.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPToDoListDataSource.h"
#import "HPListTableViewCell.h"

@implementation HPToDoListDataSource
{
    NSMutableArray *listItems;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!listItems) {
        listItems = [NSMutableArray arrayWithArray:[HPCentralData getToDoListEntriesAndForceReloadFromParse:NO]];
    }
    return listItems.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

@end
