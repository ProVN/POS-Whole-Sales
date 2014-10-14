//
//  POSCommon.h
//  pos
//
//  Created by Loc Tran on 2/28/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateTimePickerViewController.h"
#import "CustomerSelectViewViewController.h"
#import "Define.h"

@interface POSCommon : NSObject

+ (NSString *)formatCurrencyFromNumber:(NSNumber *)number;
+ (NSString *)formatCurrencyFromString:(NSString *)string;
+ (NSString *)formatNumberToString:(NSNumber *)number;
+ (NSString *)formatDateToString:(NSDate*) date;
+ (NSString *)formatDateTimeToString:(NSDate*) date;

+ (BOOL) isCurrencyCharacter:(NSString*) string;
+ (BOOL) isLandscapeMode;
+ (BOOL) isPortraitMode;
+ (void)showDateTimePicker:(UIViewController *)fromview selectedDate:(NSDate*)selectedDate  target:(id)target;
+ (void)showContactPicker:(UIViewController*) fromView contactType:(ContactType) contactType allowSelectAll:(BOOL) allowSelectAll target:(id)target;
+ (void)showError:(NSString*) title message:(NSString*) message;
+ (NSDate*) getMinTimeInDay:(NSDate*) date;
+ (NSDate*) getMaxTimeInDay:(NSDate*) date;

+ (NSDate*) getMinTimeInCurrentWeek;
+ (NSDate*) getMinTimeInCurrentMonth;
+ (NSDate*) getMinTimeInCurrentQuarter;
+ (NSDate*) getMinTimeInCurrentFinanceYear;

+ (NSDate*) getMaxTimeInCurrentWeek;
+ (NSDate*) getMaxTimeInCurrentMonth;
+ (NSDate*) getMaxTimeInCurrentQuarter;
+ (NSDate*) getMaxTimeInCurrentFinanceYear;

+ (int) getNumberOfDayInMonth:(NSDate*) date;
+ (void) showPopup:(UIViewController*) controller from:(UIViewController*) view;
+ (void) showChooserWithData:(NSMutableArray*) data from: (UIViewController*) view withTag:(NSInteger) tag;
@end
