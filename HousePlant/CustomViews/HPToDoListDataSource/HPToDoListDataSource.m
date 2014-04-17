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
        listItems = [NSMutableArray arrayWithArray:[HPCentralData getToDoListEntries]];
    }
    return listItems.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!listItems) {
        listItems = [NSMutableArray arrayWithArray:[HPCentralData getToDoListEntries]];
    }
    HPListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hpListTableViewCell"];
    
    if (cell == nil) {
        //There was no reusablecell to dequeue
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HPListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    HPListEntry *entry = [listItems objectAtIndex:indexPath.row];
    cell.entryTitle.text = entry.description;
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:entry.dateAdded
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    cell.entryDate.text = dateString;
    cell.entryTime.text = @"";

    
    return cell;
}

@end
