//
//  QComboboxElement.h
//  QuickDialog
//
//  Created by Oleg Kozynenko on 29/05/14.
//
//

#import "QEntryElement.h"
@class QComboboxElement;
@protocol QuickDialogEntryElementDelegate;

@interface QComboboxElement : QEntryElement

@property(nonatomic, assign) id<QuickDialogEntryElementDelegate> delegate;

- (QComboboxElement *)initWithTitle:(NSString *)title value:(NSString *)text;

- (void)fillValueFromObject:(id)params;

@property(nonatomic, strong) NSString *engine;

@property(nonatomic, assign) BOOL filter;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) NSDictionary *selected;
@property(nonatomic, strong) NSString *placeholder;

@property(nonatomic, strong) NSDictionary *value;

@property(nonatomic, strong) NSString *item_title;
@property(nonatomic, strong) NSString *item_description;



@end
