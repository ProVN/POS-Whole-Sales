//
//  POSCommon.m
//  pos
//
//  Created by Loc Tran on 2/28/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSCommon.h"
#import "DataTableViewController.h"

@implementation POSCommon

/*! Add comma to provided number */
+ (NSString *)formatCurrencyFromNumber:(NSNumber *)number
{
//    NSString* value = @"";
//    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
//    [fmt setCurrencySymbol:@"$"];
//    [fmt setNumberStyle:NSNumberFormatterCurrencyStyle];
//    [fmt setMinimumFractionDigits:2];
//    [fmt setMaximumIntegerDigits:2];
//    value = [fmt stringFromNumber:number];
    
    return [NSString stringWithFormat:@"$%.2f",[number floatValue]];
}
/*! Add comma to provided string */
+ (NSString *)formatCurrencyFromString:(NSString *)string
{
    return [POSCommon formatCurrencyFromNumber:[NSNumber numberWithInt:[string intValue]]];
}

+ (NSString *)formatNumberToString:(NSNumber *)number
{
    NSString* value = @"";
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    [fmt setDecimalSeparator:@"."];
    value = [fmt stringFromNumber:number];
    return value;    
}

/*! Check current character is allow in currency or not
 Please use this function only on shouldChangeCharactersInRange if UITextFieldDelegate
 */
+(BOOL) isCurrencyCharacter:(NSString *)string
{
    if(string.length == 0 || [string intValue] > 0 || [string isEqualToString:@"0"] || [string isEqualToString:@"."] || [string isEqualToString:@"-"])
        return YES;
    return NO;
}

/*! Check device is in landscape mode */
+ (BOOL)isLandscapeMode
{
    return UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

/*! Check device is in portrait mode */
+ (BOOL)isPortraitMode
{
    return UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

+ (NSString *)formatDateToString:(NSDate *)date
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd/MM/yyyy"];
    return [dateFormater stringFromDate:date];
}

+ (NSString *)formatDateTimeToString:(NSDate *)date
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd/MM/yyyy\nHH:mm"];
    return [dateFormater stringFromDate:date];
}

+ (void)showDateTimePicker:(UIViewController *)fromview selectedDate:(NSDate*)selectedDate  target:(id)target
{
    DateTimePickerViewController *vc = [[DateTimePickerViewController alloc] initWithNibName:@"DateTimePickerViewController" bundle:nil];
    vc.datetime = selectedDate;
    [vc setDelegate:fromview];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [fromview presentViewController:nav animated:YES completion:nil];
}

+ (void)showContactPicker:(UIViewController *)fromView contactType:(ContactType)contactType allowSelectAll:(BOOL)allowSelectAll target:(id)target
{
    CustomerSelectViewViewController *vc = [[CustomerSelectViewViewController alloc] initWithNibName:@"CustomerSelectViewViewController" bundle:nil];
    vc.contactType = contactType;
    vc.allowSelectAll = allowSelectAll;
    [vc setDelegate:target];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [fromView presentViewController:nav animated:YES completion:nil];

}

+ (void)showError:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
+ (NSDate *)getMaxTimeInDay:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsF = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    [compsF setHour:23];
    [compsF setMinute:59];
    [compsF setSecond:59];
    return [calendar dateFromComponents:compsF];
}

+ (NSDate *)getMinTimeInDay:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsF = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    [compsF setHour:0];
    [compsF setMinute:0];
    [compsF setSecond:0];
    return [calendar dateFromComponents:compsF];
}

+ (int)getNumberOfDayInMonth:(NSDate *)date
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:now];
    return days.length;
}


+ (NSDate *)getMinTimeInCurrentMonth
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsF = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [compsF setDay:1];
    NSDate *date = [calendar dateFromComponents:compsF];
    date = [self getMinTimeInDay:date];
    return date;
}


+ (NSDate *)getMinTimeInCurrentFinanceYear
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsF = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [compsF setDay:1];
    
    int month = [compsF month];
    int year = [compsF year];
    if(month < 3)
        [compsF setYear:year - 1];
    
    [compsF setMonth:3];
    
    NSDate *date = [calendar dateFromComponents:compsF];
    date = [self getMinTimeInDay:date];
    return date;
}

+ (NSDate *)getMaxTimeInCurrentMonth
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsF = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [compsF setDay:[self getNumberOfDayInMonth:now]];
    NSDate *date = [calendar dateFromComponents:compsF];
    date = [self getMaxTimeInDay:date];
    return date;
}

+ (NSDate *)getMaxTimeInCurrentFinanceYear
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsF = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    
    NSInteger month = [compsF month];
    NSInteger year = [compsF year];
    if(month >= 3)
        [compsF setYear:year + 1];
    [compsF setMonth:2];
    [compsF setDay:28];
    NSDate *date = [calendar dateFromComponents:compsF];
    date = [self getMaxTimeInDay:date];
    return date;
}

+ (void)showPopup:(UIViewController *)controller from:(UIViewController *)view
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [view presentViewController:nav animated:YES completion:nil];
}

+ (void) showChooserWithData:(NSMutableArray *)data from:(UIViewController *)view withTag:(NSInteger)tag
{
    DataTableViewController* controller = [[DataTableViewController alloc] initWithNibName:@"DataTableViewController" bundle:nil];
    [controller setDataSource:data];
   [controller setTarget:view];
   [controller setTag:tag];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [view presentViewController:nav animated:YES completion:nil];
}
@end
