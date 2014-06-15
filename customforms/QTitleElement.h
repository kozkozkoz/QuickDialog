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

#import "QTableViewCell.h"
#import "QElement.h"

@class QSection;
@class QuickDialogTableView;
@class QuickDialogController;

/**
 
 QElement – an element object maps one-to-one map to a UITableViewCell, although it includes more functionality, like being able to read values from the cells and having multiple types. QuickDialog provides many different built-in element types, like the ButtonElement and the EntryElement, but you can also create your custom one.
 
 */

@interface QTitleElement : QElement

@property (nonatomic, strong) NSString *title;

- (QTitleElement *)initWithTitle:(NSString *)title;

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller;

@end
