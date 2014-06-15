//
//  QAutocompleteTestElement.h
//  QuickDialog
//
//  Created by Oleg Kozynenko on 22/04/14.
//
//

#import "QEntryElement.h"
@class QAutocompleteSearchElement;
@protocol QuickDialogEntryElementDelegate;

@interface QAutocompleteSearchElement : QEntryElement

@property(nonatomic, assign) id<QuickDialogEntryElementDelegate> delegate;

- (QAutocompleteSearchElement *)initWithTitle:(NSString *)title value:(NSString *)text;

@property(nonatomic, strong) NSString *engine;
@property(nonatomic, strong) NSDictionary *value;
@property(nonatomic, strong) NSString *item_title;
@property(nonatomic, strong) NSString *item_description;
@property(nonatomic, assign) BOOL isAutocomplete;

@end
