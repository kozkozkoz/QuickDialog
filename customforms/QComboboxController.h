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
#import "QComboboxElement.h"

@class QAutocompleteSearchController;
@class QMultilineElement;
@class QEntryTableViewCell;

@interface QComboboxController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *myTableView;

@property (nonatomic, strong, readonly) UISearchBar *mySearchBar;
@property (nonatomic, strong) NSMutableArray *resultList;
@property (nonatomic, strong) NSArray *resultListFiltered;


@property (nonatomic, strong) NSString *queryString;

@property (nonatomic, assign) BOOL isAutocomplete;
@property (nonatomic, strong) NSString *searchUrl;

@property (nonatomic, strong) NSString *engine;
@property(nonatomic, assign) BOOL filter;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) NSDictionary *selected;
@property(nonatomic, strong) NSString *placeholder;

@property(nonatomic, strong) NSString *item_title;
@property(nonatomic, strong) NSString *item_description;

@property(nonatomic, assign) BOOL resizeWhenKeyboardPresented;

@property(nonatomic, copy) void (^willDisappearCallback)();

@property(nonatomic, strong) QComboboxElement *entryElement;

@property(nonatomic, strong) QEntryTableViewCell *entryCell;

- (id)initWithTitle:(NSString *)title engine:(NSString*)engine showFilter:(BOOL)showFilter placeholder:(NSString*)placeholder selected:(NSDictionary*)selected item_title:(NSString*)item_title item_description:(NSString*)item_description items:(NSMutableArray*)items;

@end
