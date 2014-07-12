//
// Copyright 2011 ESCOZ Inc  - http://escoz.com
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//


#import <UIKit/UIKit.h>
#import "QAutocompleteSearchElement.h"
#import "UNIRest.h"

@class QAutocompleteSearchController;
@class QMultilineElement;
@class QEntryTableViewCell;

@interface QAutocompleteSearchController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *myTableView;

@property (nonatomic, strong, readonly) UISearchBar *mySearchBar;
@property (nonatomic, strong) NSMutableArray *resultList;


@property (nonatomic, strong) NSString *queryString;

@property (nonatomic, assign) BOOL isAutocomplete;
@property (nonatomic, strong) NSString *searchUrl;
@property (nonatomic, strong) NSString *searchEngine;
@property (nonatomic, strong) NSString *item_title;
@property (nonatomic, strong) NSString *item_description;



@property(nonatomic, assign) BOOL resizeWhenKeyboardPresented;

@property(nonatomic, copy) void (^willDisappearCallback)();

@property(nonatomic, strong) QAutocompleteSearchElement *entryElement;

@property(nonatomic, strong) QEntryTableViewCell *entryCell;

- (id)initWithTitle:(NSString *)title andEngine:(NSString*)engine isAutocomplete:(BOOL)isAutocomplete item_title:(NSString*)itemTitle item_description:(NSString*)itemDescription;

@end
