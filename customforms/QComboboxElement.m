//
//  QComboboxElement.m
//  QuickDialog
//
//  Created by Oleg Kozynenko on 29/05/14.
//
//

#import "QComboboxElement.h"
#import "QComboboxController.h"
#import "QuickDialog.h"

@implementation QComboboxElement

@synthesize delegate = _delegate;
@synthesize engine;
@synthesize filter;
@synthesize items;
@synthesize selected;
@synthesize placeholder;
@synthesize item_title;
@synthesize item_description;


- (QEntryElement *)init {
    
    self = [super init];
    if (self) {
        self.presentationMode = QPresentationModePopover;
    }
    
    return self;
}


- (QComboboxElement *)initWithTitle:(NSString *)title value:(NSString *)text
{
    if ((self = [super initWithTitle:title Value:nil])) {
        self.textValue = text;
        self.presentationMode = QPresentationModePopover;
    }
    
    return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    QEntryTableViewCell *cell = (QEntryTableViewCell *) [super getCellForTableView:tableView controller:controller];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = self.enabled ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
    cell.textField.enabled = NO;
    cell.textField.textAlignment = UITextAlignmentRight;
    
    //cell.accessoryType = [_radioElement.selectedIndexes containsObject:selected] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    NSLog(@"Self.value2: %@", self.value);
    
    return cell;
}


- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Self.value1: %@", self.value);
    
    QComboboxController *textController = [[QComboboxController alloc] initWithTitle:self.title engine:self.engine showFilter:self.filter placeholder:self.placeholder selected:self.selected item_title:self.item_title item_description:self.item_description items:self.items];
    
    textController.entryElement = self;
    textController.entryCell = (QEntryTableViewCell *) [tableView cellForElement:self];
    
    /*textController.resizeWhenKeyboardPresented = YES;
     textController.autocompleteTextField.text = self.textValue;
     textController.autocompleteTextField.autocapitalizationType = self.autocapitalizationType;
     textController.autocompleteTextField.autocorrectionType = self.autocorrectionType;
     textController.autocompleteTextField.keyboardAppearance = self.keyboardAppearance;
     textController.autocompleteTextField.keyboardType = self.keyboardType;
     textController.autocompleteTextField.secureTextEntry = self.secureTextEntry;
     textController.autocompleteTextField.autocapitalizationType = self.autocapitalizationType;
     textController.autocompleteTextField.returnKeyType = self.returnKeyType;*/
    //textController.autocompleteTextField.editable = self.enabled;
    
    __weak QComboboxElement *weakSelf = self;
	__weak QComboboxController *weakTextController = textController;

    
    textController.willDisappearCallback = ^ {
        
            if([weakTextController.queryString length] > 0){
                
                if([weakTextController.resultListFiltered count] > 0){
                    if(weakTextController.myTableView.indexPathForSelectedRow != nil){
                        weakSelf.textValue = [[weakTextController.resultListFiltered objectAtIndex:weakTextController.myTableView.indexPathForSelectedRow.row] valueForKey:weakSelf.item_title];
                
                        weakSelf.value = [weakTextController.resultListFiltered objectAtIndex:weakTextController.myTableView.indexPathForSelectedRow.row];
                    }
                }
                
            }else{
                    if([weakTextController.resultList count] > 0){
                        if(weakTextController.myTableView.indexPathForSelectedRow != nil){
                            weakSelf.textValue = [[weakTextController.resultList objectAtIndex:weakTextController.myTableView.indexPathForSelectedRow.row] valueForKey:weakSelf.item_title];
                        
                            weakSelf.value = [weakTextController.resultList objectAtIndex:weakTextController.myTableView.indexPathForSelectedRow.row];
                        }
                    }

            }
        
        //[tableView cellForElement:weakSelf].detailTextLabel.backgroundColor = [UIColor redColor];
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    
    NSLog(@"Self.value: %@", self.value);
    
    [controller displayViewController:textController withPresentationMode:self.presentationMode];
}

- (void)fetchValueIntoObject:(id)obj
{
	if (_key == nil) {
		return;
	}
    
    if( self.textValue != nil && ![self.textValue isEqualToString:@""] && [self.value isKindOfClass:[NSDictionary class]] ){
        [obj setObject:self.value forKey:_key];
    }
}

- (BOOL)canTakeFocus {
    return NO;
}

@end
