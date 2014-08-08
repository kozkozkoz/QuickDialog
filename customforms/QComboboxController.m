//
//  QComboboxController.m
//  QuickDialog
//
//  Created by Oleg Kozynenko on 29/05/14.
//
//

#import "QComboboxController.h"
#import "QuickDialog.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface QComboboxController ()

@end

@implementation QComboboxController
{
    BOOL _viewOnScreen;
    BOOL _keyboardVisible;
    UITableView* _myTableView;
    NSIndexPath *prevSelectedRow;
}

@synthesize myTableView = _myTableView;
@synthesize mySearchBar = _mySearchBar;

@synthesize resultList = _resultList;
@synthesize resultListFiltered = _resultListFiltered;
@synthesize queryString = _queryString;

@synthesize resizeWhenKeyboardPresented = _resizeWhenKeyboardPresented;
@synthesize willDisappearCallback = _willDisappearCallback;
@synthesize entryElement = _entryElement;
@synthesize entryCell = _entryCell;


- (id)initWithTitle:(NSString *)title engine:(NSString*)engine showFilter:(BOOL)showFilter placeholder:(NSString*)placeholder selected:(NSDictionary*)selected item_title:(NSString*)item_title item_description:(NSString*)item_description items:(NSMutableArray*)items
{
    if ((self = [super init]))
    {
        NSLog(@"INICIANDO COMBOBOX: %lu",(unsigned long)items.count);
        
        self.searchUrl = @"http://78.47.69.173/search";
        
        if(items != nil && items.count>0){
            
            NSLog(@"RELLENO ITEMS: %@", items);
            self.resultList = items;
            
            /*dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });*/
        }
        
        self.items = items;
        self.engine = engine;
        self.filter = showFilter;
        self.placeholder = placeholder;
        self.selected = selected;
        self.item_title = item_title;
        self.item_description = item_description;
        
        self.title = (title!=nil) ? title : NSLocalizedString(@"Note", @"Note");
        
        CGRect myFrame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,
                                    self.view.bounds.size.width, 44.0f);
        
        if(self.filter){
        
            _mySearchBar = [[UISearchBar alloc] initWithFrame:myFrame];
            
            //set the delegate to self so we can listen for events
            _mySearchBar.delegate = self;
            
            //display the cancel button next to the search bar
            _mySearchBar.showsCancelButton = YES;
            
            _mySearchBar.showsCancelButton = NO;
            _mySearchBar.searchBarStyle = UISearchBarStyleMinimal;
            _mySearchBar.translucent = NO;
            _mySearchBar.backgroundColor = UIColorFromRGB(0xf5f5f5);
            _mySearchBar.barTintColor = UIColorFromRGB(0x2f2f2f);
            _mySearchBar.tintColor = UIColorFromRGB(0x2f2f2f);
        
            myFrame.origin.y += 44;
        }
        
        
        //add the search bar to the view
        //[self.view addSubview:self.mySearchBar];
        
        
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
    
    if(self.items.count == 0 && [self.engine isKindOfClass:[NSString class]] && ![self.engine isEqualToString:@""]){
        [self initCombobox];
    }
    
    if(self.entryElement.value != nil){
        
        NSInteger selectedIndex = [[self currentResultList] indexOfObject:self.entryElement.value];
        
        NSIndexPath *indexPathSelected = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
        
        [self.myTableView selectRowAtIndexPath:indexPathSelected animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    NSLog(@"curValuE: %@",self.entryElement.value);
    
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
    if(self.filter){
        [_mySearchBar becomeFirstResponder];
    }

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
    //[self.myTableView cellForRowAtIndexPath:prevSelectedRow].accessoryType = UITableViewCellAccessoryNone;
    
    //prevSelectedRow = [indexPath copy];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSLog(@"Recogido valor: %@",cell.textLabel.text);
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
    
    if(self.filter){
        [self handleSearch:searchBar];
        [_mySearchBar becomeFirstResponder];
    }

}

//user finished editing the search text
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

- (void)handleSearch:(UISearchBar *)searchBar{
    
    self.queryString = searchBar.text;
    [searchBar resignFirstResponder];

    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@",self.item_title ,self.queryString];
    self.resultListFiltered = [self.resultList filteredArrayUsingPredicate:resultPredicate];
    
    NSLog(@"Predicate result('%@ contains_c %@'): %@",self.item_title ,self.queryString,self.resultListFiltered);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTableView reloadData];
    });
    
}



//do our search on the remote server using HTTP request
- (void)initCombobox{
    
    //setup the remote server URI
    
    NSString *myUrlString = [NSString stringWithFormat:@"%@/%@",self.searchUrl,self.engine];
    
    NSLog(@"Engine URL: %@",myUrlString);
    
    //pass the query String in the body of the HTTP post
    //NSString *body = @"";
    
    NSString* webStringURL = [myUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *myUrl = [NSURL URLWithString:webStringURL];
    
    //make the HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:myUrl];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    //[urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         
         //we got something in reponse to our request lets go ahead and process this
         if ([data length] >0 && error == nil){
             [self parseResponse:data];
         }
         else if ([data length] == 0 && error == nil){
             NSLog(@"Empty Response, not sure why?");
         }
         else if (error != nil){
             NSLog(@"Not again, what is the error = %@", error);
         }
     }];
    
}

//parse our JSON response from the server and load the NSMutableArray of countries
- (void) parseResponse:(NSData *) data {
    
    NSString *myData = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"JSON data = %@", myData);
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:NSJSONReadingAllowFragments
                     error:&error];
    if (jsonObject != nil && error == nil){
        NSLog(@"Successfully deserialized...");
        
        NSString *success = [jsonObject objectForKey:@"status"];
        if([success isEqual:@"OK"]){
            
            self.resultList = [jsonObject objectForKey:@"results"];
            
            NSLog(@"Result list: %@",self.resultList);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
}

//number of rows in a given section of a table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    
    NSInteger numberOfRows = [self currentResultList].count;
    
    if(numberOfRows == 0 && [self.queryString length] > 0){
        numberOfRows = 1;
    }
    
    return numberOfRows;
}

-(NSArray *)currentResultList {
	return ([self.queryString length] > 0) ? self.resultListFiltered : self.resultList;
}


//asks the data source for a cell to insert in a particular location of the table view
- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"cellForRowAtIndexPath.indexPath: %@",indexPath);
    UITableViewCell *myCellView = nil;

    static NSString *TableViewCellIdentifier = @"CountryCells";
    //create a reusable table-view cell object located by its identifier
    myCellView = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (myCellView == nil){
        myCellView = [[UITableViewCell alloc]
                      initWithStyle:UITableViewCellStyleValue1
                      reuseIdentifier:TableViewCellIdentifier];
    }
    
    if([self currentResultList].count > 0){
        
        NSLog(@"%@ <-> %@",indexPath,[self.myTableView indexPathForSelectedRow]);
        if([indexPath compare:[self.myTableView indexPathForSelectedRow]] == NSOrderedSame){
            myCellView.accessoryType = UITableViewCellAccessoryCheckmark;
            myCellView.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            myCellView.accessoryType = UITableViewCellAccessoryNone;
        }
        
        NSDictionary *item = [[self currentResultList] objectAtIndex:indexPath.row];
        
        NSString *title = @"";
        NSString *description = @"";
        
        if(self.engine!=nil && ![self.engine isEqual:@""]){
            title = ![self.item_title isEqual:@""] ? [item  valueForKey:self.item_title] : @"";
            description = ![self.item_description isEqual:@""] ? [item  valueForKey:self.item_description] : @"";
        }else{
            title = [item  valueForKey:@"text"];
        }
        
        
        myCellView.textLabel.text = [NSString stringWithFormat:@"%@",title];
        myCellView.detailTextLabel.text = description;
    }else{
        myCellView.textLabel.text = @"No Results found, try again!";
        myCellView.detailTextLabel.text = @"";
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
