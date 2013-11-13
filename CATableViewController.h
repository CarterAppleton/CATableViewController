//
//  CATableViewController.h
//
//  Created by Carter Appleton on 11/12/13.
//  Adapted from https://github.com/enormego/EGOTableViewPullRefresh
//  Copyright (c) 2013 Carter Appleton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CATableViewController : UITableViewController

// How far the table must be pulled before a refresh will be triggered
@property (nonatomic, assign) CGFloat minDisplacementActivateRefresh;

// How much of the header view will be visible while it's refreshing
@property (nonatomic, assign) CGFloat refreshHeaderHeight;

// Touches have stopped and we start loading
- (void) tableViewDidTriggerRefresh:(UITableView *)tableView;

// Touches are still going, if they are released then we refresh (if willRefresh is true)
- (void) tableView:(UITableView *)tableView willTriggerRefresh:(BOOL)willRefresh;

// True if we are still refreshing table view data
- (BOOL) tableViewRefreshingData:(UITableView *)tableView;

// Call when you finish loading data
- (void) tableViewFinishedRefreshingData:(UITableView *)tableView;

@end
