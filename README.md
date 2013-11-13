CATableViewController
=====================

A simple UITableViewController for custom drag to refresh actions and views

-------------
To Implement:

1) Subclass CATableViewController
2) Create your own header view and add it to the table
3) Implement the 4 methods in the header of CATableViewController
4) Update your header view accordingly!

Notes on methods:

- (void) tableViewDidTriggerRefresh:(UITableView *)tableView;
    - Called when the user has pulled down past displacementUntilRefreshDone and released
    - This should trigger a data refresh (or some action) and update the header view to let them know
    
- (void) tableView:(UITableView *)tableView willTriggerRefresh:(BOOL)willRefresh;
    - Called when the user has pulled down past displacementUntilRefreshDone or pushed back up past displacementUntilRefreshDone
    - willRefresh will be true if we're going to refresh on release (maybe have header say "release to refresh")
    - willRefresh will be false if we're not going to refresh on release (header -> "pull to refresh")

- (BOOL) tableViewRefreshingData:(UITableView *)tableView;
    - Return true if you're still refreshing data

- (void) tableViewFinishedRefreshingData:(UITableView *)tableView
    - Call this when you're done refreshing the data, this will hide the header view
    - Be sure to call [super tableViewFinishedRefreshingData:] so CATableViewController can hide the header
  
  
