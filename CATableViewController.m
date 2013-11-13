//
//  CATableViewController.m
//
//  Created by Carter Appleton on 11/12/13.
//  Copyright (c) 2013 Carter Appleton. All rights reserved.
//

#import "CATableViewController.h"

typedef enum{
	CAPullRefreshPulling = 0,
	CAPullRefreshNormal,
} CAPullRefreshState;

@interface CATableViewController ()

@property (nonatomic, assign) CAPullRefreshState state;
@property (nonatomic, assign) CGFloat scrollViewInitialOffset;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation CATableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.minDisplacementActivateRefresh = 65;
    self.refreshHeaderHeight = 60;
    self.state = CAPullRefreshNormal;
    self.scrollViewInitialOffset = INT16_MIN;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // Grab the initial offset of the scrollView in case someone else is messing with it
    if(self.scrollViewInitialOffset == INT16_MIN)
    {
        self.scrollViewInitialOffset = scrollView.contentOffset.y;
        self.scrollView = scrollView;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Check if we're refreshing data
    BOOL loading = [self tableViewRefreshingData:self.tableView];
    
    // If we're refreshing keep the header in view
    if (loading)
    {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, self.refreshHeaderHeight);
		scrollView.contentInset = UIEdgeInsetsMake(self.scrollViewInitialOffset - offset, 0.0f, 0.0f, 0.0f);
	}
    
    // If we're dragging, check if we've passed the refresh displacement and update view accordingly
    else if (scrollView.isDragging)
    {
        // Get the scroll view offset
        CGFloat verticalOffset = scrollView.contentOffset.y;
        
        // Find our real check displacement
        CGFloat minDisplacement = self.scrollViewInitialOffset - self.minDisplacementActivateRefresh;
        
        // If we haven't passed the refresh displacement
		if (self.state == CAPullRefreshPulling && verticalOffset > minDisplacement && verticalOffset < 0.0f && !loading)
        {
			[self setState:CAPullRefreshNormal];
            [self tableView:self.tableView willTriggerRefresh:NO];
		}
        
        // If we have passed the refresh displacement
        else if (_state == CAPullRefreshNormal && verticalOffset < minDisplacement && !loading)
        {
			[self setState:CAPullRefreshPulling];
            [self tableView:self.tableView willTriggerRefresh:YES];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // Check if we're refreshing data
	BOOL loading = [self tableViewRefreshingData:self.tableView];
    
    // Get the scroll view offset
    CGFloat verticalOffset = scrollView.contentOffset.y;
    
    // Find our real check displacement
    CGFloat minDisplacement = self.scrollViewInitialOffset - self.minDisplacementActivateRefresh;
	
    // If the scroll view was released below the refresh displacement
	if (verticalOffset <= minDisplacement && !loading)
    {
        [self tableViewDidTriggerRefresh:self.tableView];
		
        // Animate in the offset
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(self.refreshHeaderHeight - self.scrollViewInitialOffset, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void) tableView:(UITableView *)tableView willTriggerRefresh:(BOOL)willRefresh
{
    
}


- (void) tableViewDidTriggerRefresh:(UITableView *)tableView
{

}

- (BOOL) tableViewRefreshingData:(UITableView *)tableView
{
    return NO;
}

- (void) tableViewFinishedRefreshingData:(UITableView *)tableView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.scrollView setContentInset:UIEdgeInsetsMake(-self.scrollViewInitialOffset, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
    
    [self setState:CAPullRefreshNormal];
    [self tableView:self.tableView willTriggerRefresh:NO];
}

@end
