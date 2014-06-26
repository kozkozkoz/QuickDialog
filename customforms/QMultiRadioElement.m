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

#import "QBindingEvaluator.h"
#import "QMultiRadioElement.h"
#import "QMultiRadioItemElement.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation QMultiRadioElement {
    QSection *_internalRadioItemsSection;
}

@synthesize items = _items;
@synthesize item_title = _item_title;
@synthesize item_description = _item_description;

@synthesize selectedItems = _selectedItems;
@synthesize selectedIndexes = _selectedIndexes;


// borrar
@synthesize values = _values;

- (void)createElements {
    
    NSLog(@"ITEMS: %@",self.items);
    NSLog(@"ITEM-title: %@",self.item_title);
    NSLog(@"ITEM-desc: %@",self.item_description);
    
    self.selectedIndexes = [[NSMutableArray alloc] init];
    
    _sections = nil;
    _internalRadioItemsSection = [[QSection alloc] init];
    _parentSection = _internalRadioItemsSection;

    [self addSection:_parentSection];

    for (NSUInteger i=0; i< [_items count]; i++){
        [_parentSection addElement:[[QMultiRadioItemElement alloc] initWithIndex:i RadioElement:self]];
    }
}

-(void)setItems:(NSArray *)items {
    _items = items;
    [self createElements];
}

- (NSArray *)selectedItems
{
  NSMutableArray *selectedItems = [NSMutableArray array];
  for (NSNumber *index in _selectedIndexes) {
    [selectedItems addObject:[_items objectAtIndex:[index unsignedIntegerValue]]];
  }
  return selectedItems;
}

- (QMultiRadioElement *)initWithItems:(NSArray *)stringArray selectedIndexes:(NSArray*)selected {
    self = [self initWithItems:stringArray selectedIndexes:selected title:nil];
    return self;
}

- (void)fetchValueIntoObject:(id)obj {
	if (_key==nil)
		return;
	
	[obj setValue:self.selectedItems forKey:_key];
}

- (QMultiRadioElement *)initWithItems:(NSArray *)stringArray selectedIndexes:(NSArray*)selected title:(NSString *)title {
    self = [super init];
    if (self!=nil){
      self.items = stringArray;
      
      if (selected!=nil) {
        self.selectedIndexes = [selected mutableCopy];
      } else {
        self.selectedIndexes = [NSMutableArray array]; 
      }
      self.title = title;
    }
    return self;
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)path {
    if (self.sections==nil)
            return;

    [controller displayViewControllerForRoot:self];
}


- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    QEntryTableViewCell *cell = (QEntryTableViewCell *) [super getCellForTableView:tableView controller:controller];
  
    NSString *selectedValue = nil;
    if ([_selectedIndexes count] > 0) {
        
        NSMutableArray *a = [NSMutableArray array];
        [self.selectedItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [a addObject:[obj valueForKey:self.item_title]];
        }];
        
        selectedValue = [a componentsJoinedByString:@", "];
    }

    if (self.title == NULL){
        cell.textField.text = selectedValue;
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
    } else {
        cell.textLabel.text = _title;
        cell.textField.text = selectedValue;
        cell.imageView.image = nil;
        
        if(self.strQty == nil){
            self.strQty = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x + 270, 12, 21, 21)];
            self.strQty.backgroundColor = cell.backgroundColor;
            self.strQty.textColor = UIColorFromRGB(0xdddddd);
            self.strQty.textAlignment = UITextAlignmentRight;
        }
        
        [cell addSubview:self.strQty];
        [self.strQty setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.selectedItems.count]];
        
        
        //cell.accessoryView = strQty;
    }
    cell.textField.textAlignment = UITextAlignmentRight;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textField.userInteractionEnabled = NO;
    return cell;
}



@end
