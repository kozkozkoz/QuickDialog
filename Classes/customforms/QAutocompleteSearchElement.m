//
//  QAutocompleteTestElement.m
//  QuickDialog
//
//  Created by Oleg Kozynenko on 22/04/14.
//
//

#import "QAutocompleteSearchElement.h"
#import "QAutocompleteSearchController.h"
#import "QuickDialog.h"

@implementation QAutocompleteSearchElement

@synthesize delegate = _delegate;
@synthesize engine;
@synthesize isAutocomplete;


- (QEntryElement *)init {
    self = [super init];
    if (self) {
        self.presentationMode = QPresentationModePopover;
    }
    
    return self;
}

- (QAutocompleteSearchElement *)initWithTitle:(NSString *)title value:(NSString *)text
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
    cell.selectionStyle = self.enabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    cell.textField.enabled = NO;
    cell.textField.textAlignment = self.appearance.labelAlignment;
    
    return cell;
}


- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath
{
    QAutocompleteSearchController *textController = [[QAutocompleteSearchController alloc] initWithTitle:self.title andEngine:self.engine isAutocomplete:self.isAutocomplete item_title:self.item_title item_description:self.item_description];

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
    
    __weak QAutocompleteSearchElement *weakSelf = self;
	__weak QAutocompleteSearchController *weakTextController = textController;
    textController.willDisappearCallback = ^ {
        NSLog(@"-> will disappear called: %@",[[weakTextController.resultList objectAtIndex:weakTextController.myTableView.indexPathForSelectedRow.row] valueForKey:@"name"]);
        
        weakSelf.textValue = [[weakTextController.resultList objectAtIndex:weakTextController.myTableView.indexPathForSelectedRow.row] valueForKey:@"name"];
        
         weakSelf.value = [weakTextController.resultList objectAtIndex:weakTextController.myTableView.indexPathForSelectedRow.row];
        //[[tableView cellForElement:weakSelf] setNeedsDisplay];
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    [controller displayViewController:textController withPresentationMode:self.presentationMode];
}

- (void)fetchValueIntoObject:(id)obj
{
	if (_key == nil) {
		return;
	}
    
    if( [self.value isKindOfClass:[NSDictionary class]] ){
        [obj setObject:self.value forKey:_key];
    }
}

- (BOOL)canTakeFocus {
    return NO;
}


@end
