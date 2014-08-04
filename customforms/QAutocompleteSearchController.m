//
//  QAutocompleteTestController.m
//  QuickDialog
//
//  Created by Oleg Kozynenko on 22/04/14.
//
//

#import "QAutocompleteSearchController.h"
#import "QuickDialog.h"
#import "SVProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface QAutocompleteSearchController ()

@end

@implementation QAutocompleteSearchController{
    BOOL _viewOnScreen;
    BOOL _keyboardVisible;
    UITableView* _myTableView;
    UNIUrlConnection *searchRequest;
}

@synthesize myTableView = _myTableView;
@synthesize mySearchBar = _mySearchBar;

@synthesize resultList = _resultList;
@synthesize queryString = _queryString;

@synthesize resizeWhenKeyboardPresented = _resizeWhenKeyboardPresented;
@synthesize willDisappearCallback = _willDisappearCallback;
@synthesize entryElement = _entryElement;
@synthesize entryCell = _entryCell;


- (id)initWithTitle:(NSString *)title andEngine:(NSString*)engine isAutocomplete:(BOOL)isAutocompleter item_title:(NSString*)itemTitle item_description:(NSString*)itemDescription
{
    if ((self = [super init]))
    {
        NSLog(@"INICIANDO AUTOCOMPLETE-SEARCH WITH ENGINE: %@",engine);
        
        self.searchUrl = @"http://78.47.69.173/search";
        self.isAutocomplete = isAutocompleter;
        self.searchEngine = engine;
        self.item_title = itemTitle;
        self.item_description = itemDescription;
        
        [[SVProgressHUD appearance] setHudBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
        [[SVProgressHUD appearance] setHudForegroundColor:[UIColor blackColor]];
        [[SVProgressHUD appearance] setHudFont:[UIFont fontWithName:@"MuseoSansRounded-500" size:16]];
        [[SVProgressHUD appearance] setHudStatusShadowColor:[UIColor clearColor]];
        
        self.title = (title!=nil) ? title : NSLocalizedString(@"Note", @"Note");
        
        CGRect myFrame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,
                                    self.view.bounds.size.width, 44.0f);
        
        _mySearchBar = [[UISearchBar alloc] initWithFrame:myFrame];
        
        //set the delegate to self so we can listen for events
        _mySearchBar.delegate = self;
        
        /*
        //display the cancel button next to the search bar
        _mySearchBar.showsCancelButton = YES;
        
        _mySearchBar.showsCancelButton = NO;
        _mySearchBar.searchBarStyle = UISearchBarStyleMinimal;
        _mySearchBar.translucent = NO;
        _mySearchBar.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _mySearchBar.barTintColor = UIColorFromRGB(0x2f2f2f);
        _mySearchBar.tintColor = UIColorFromRGB(0x2f2f2f);*/
        
        
        
        //add the search bar to the view
        //[self.view addSubview:self.mySearchBar];
        
        myFrame.origin.y += 44;
        myFrame.size.height = self.view.bounds.size.height - 44;
        _myTableView = [[UITableView alloc] initWithFrame:myFrame style:UITableViewStylePlain];
        
        //set the table view delegate and the data source
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        //set table view resize attribute
        _myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //set background view and color
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.backgroundView = nil;
        
    }
    return self;
}

- (void)loadView
{
    //[self.autocompleteTextField addSubview:self.mySearchBar];
    self.myTableView.tableHeaderView = self.mySearchBar;
    self.view = _myTableView;
}

- (void)viewDidAppear:(BOOL)animated{
    
    //[_autocompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)keyboardDidShowWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, -60);
                                 break;
                         }
                         CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         [self.view setCenter:newCenter];
                         //[self.author setAlpha:0];
                         //[self.demoTitle setAlpha:0];
                         //[self.typeSwitch setAlpha:0];
                         
                     }
                     completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    _viewOnScreen = YES;
    [_mySearchBar becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"Will disapear");
    _viewOnScreen = NO;
    if (_willDisappearCallback !=nil){
        _willDisappearCallback();
    }
    [super viewWillDisappear:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.entryElement.textValue = cell.textLabel.text;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - TableView and Search Bar Delegates

//search button was tapped
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(self.isAutocomplete){
        if(searchText.length > 0){
            [self handleSearch:searchBar];
        }
        
    }
    
    [_mySearchBar becomeFirstResponder];
}

//user finished editing the search text
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //[self handleSearch:searchBar];
}

//do our search on the remote server using HTTP request
- (void)handleSearch:(UISearchBar *)searchBar {
    
    [SVProgressHUD showWithStatus:@"Searching"];
    
    //check what was passed as the query String and get rid of the keyboard
    
    NSLog(@"User searched for %@", searchBar.text);
    self.queryString = searchBar.text;
    
    if(!self.isAutocomplete){
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchBar resignFirstResponder];
        });
    }
    
    
    //setup the remote server URI
    
    NSString *myUrlString = [NSString stringWithFormat:@"%@/%@/%@",self.searchUrl,self.searchEngine,self.queryString];
    
    NSString* webStringURL = [myUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"SEARCH URL: %@", myUrlString);
    
    if(searchRequest){
        NSLog(@"Request canceled");
        [searchRequest cancel];
    }
    
    searchRequest = [[UNIRest get:^(UNISimpleRequest* request) {
        [request setUrl:webStringURL];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        // This is the asyncronous callback block
        //NSInteger* code = [response code];
        //NSDictionary* responseHeaders = [response headers];
        UNIJsonNode* body = [response body];
        //NSData* rawBody = [response rawBody];
        //NSLog(@"rawBody: %@",[[ [body JSONArray] objectAtIndex:0] objectForKey:@"message"]);
        [self parseResponse:[body JSONObject]];
    }];
    
}

//parse our JSON response from the server and load the NSMutableArray of countries
- (void) parseResponse:(NSDictionary *) jsonObject {
    
    if (jsonObject != nil){
        NSLog(@"Successfully deserialized...");
        
        NSString *success = [jsonObject objectForKey:@"status"];
        if([success isEqual:@"OK"]){
            self.resultList = [jsonObject objectForKey:@"results"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            });
        }
        else {
            NSLog(@"ERROR: request devuelve status error");
            //[self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
}

//number of rows in a given section of a table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    
    NSInteger numberOfRows = 0;
    //get the count from the array
    if ([tableView isEqual:self.myTableView]){
        numberOfRows = self.resultList.count;
    }
    //if user searched for something and found nothing just add a row to display a message
    if(numberOfRows == 0 && [self.queryString length] > 0){
        numberOfRows = 1;
    }else if(numberOfRows == 0){
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        numberOfRows = 0;
    }else{
         self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    NSLog(@"Rows: %li", (long)numberOfRows);
    return numberOfRows;
}


//asks the data source for a cell to insert in a particular location of the table view
- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *myCellView = nil;
    
    if ([tableView isEqual:self.myTableView]){
        
        static NSString *TableViewCellIdentifier = @"CountryCells";
        //create a reusable table-view cell object located by its identifier
        myCellView = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
        if (myCellView == nil){
            myCellView = [[UITableViewCell alloc]
                          initWithStyle:UITableViewCellStyleValue1
                          reuseIdentifier:TableViewCellIdentifier];
        }
        
        myCellView.accessoryType = UITableViewCellAccessoryNone;
        
        //if there are countries to display
        if(self.resultList.count > 0){
            NSDictionary *countryInfo = [self.resultList objectAtIndex:indexPath.row];
            NSLog(@"Result item: %@",countryInfo);
            
            NSString *title = [countryInfo  valueForKey:self.item_title];
            NSString *description = [countryInfo  valueForKey:self.item_description];
            
            if([title isKindOfClass:[NSString class]]){
                myCellView.textLabel.text = [NSString stringWithFormat:@"%@",title];
                myCellView.textLabel.adjustsFontSizeToFitWidth = YES;
                myCellView.textLabel.minimumScaleFactor = .8f;
            }
            if([description isKindOfClass:[NSString class]]){
                myCellView.detailTextLabel.text = description;
            }
            
           
        }
        //display message to user
        else {
            myCellView.textLabel.text = @"No Results found, try again!";
            myCellView.detailTextLabel.text = @"";
        }
        
        //set the table view cell style
        [myCellView setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return myCellView;
}

//user tapped on the cancel button
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
