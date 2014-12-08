//
//  POSMetadata.m
//  pos
//
//  Created by Loc Tran on 3/3/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "POSMeta.h"
#import "POSCommon.h"

static POSMeta* _postMetainstant = nil;

@implementation TimeObject
- (TimeObject *)initWithMinDate:(NSDate *)minDateVal maxDate:(NSDate *)maxDateVal
{
    TimeObject* object = [[TimeObject alloc] init];
    object.minDate = [POSCommon getMinTimeInDay:minDateVal];
    object.maxDate = [POSCommon getMaxTimeInDay:maxDateVal];
    return object;
}

@end
@implementation POSMeta

+ (id)sharedInstance {
    if(_postMetainstant == nil)
    {
        _postMetainstant = [[POSMeta alloc] init];
    }
    return _postMetainstant;
}

- (id)init
{
    [self generatePaymentTypes];
    [self generateTimeListStr];
    [self generateTimeList];
    [self generateMetaType];
    [self generateMonthList];
    return self;
}

- (void) generatePaymentTypes
{
    self.paymentTypes = [[NSMutableArray alloc] init];
    [self.paymentTypes insertObject:@"Cash" atIndex:0];
    [self.paymentTypes insertObject:@"Cheque" atIndex:1];
    [self.paymentTypes insertObject:@"MCredit" atIndex:2];
    [self.paymentTypes insertObject:@"EFT" atIndex:3];
}

- (void) generateTimeListStr
{
    self.timeListStr = [[NSMutableArray alloc] init];
    [self.timeListStr addObject:@"This week"];
    [self.timeListStr addObject:@"This month"];
    [self.timeListStr addObject:@"This quarter"];
    [self.timeListStr addObject:@"This finance year"];

    [self.timeListStr addObject:@"Last week"];
    [self.timeListStr addObject:@"Last month"];
    [self.timeListStr addObject:@"Last quarter"];
    [self.timeListStr addObject:@"Last finance year"];
}

- (void) generateTimeList
{
    self.timeList = [[NSMutableArray alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    //THIS WEEK
    NSDate *startOfThisWeek;
    NSDate *endOfThisWeek;
    NSTimeInterval intervalThisWeek;
    [cal rangeOfUnit:NSWeekCalendarUnit startDate:&startOfThisWeek interval:&intervalThisWeek forDate:now];
    endOfThisWeek = [startOfThisWeek dateByAddingTimeInterval:intervalThisWeek-1];
    TimeObject *thisWeek = [[TimeObject alloc] initWithMinDate:startOfThisWeek maxDate:endOfThisWeek];
    [self.timeList addObject:thisWeek];
    
    //THIS MONTH
    NSDate *startOfThisMonth;
    NSDate *endOfThisMonth;
    NSTimeInterval intervalThisMonth;
    [cal rangeOfUnit:NSMonthCalendarUnit startDate:&startOfThisMonth interval:&intervalThisMonth forDate:now];
    endOfThisMonth = [startOfThisMonth dateByAddingTimeInterval:intervalThisMonth-1];
    TimeObject *thisMonth = [[TimeObject alloc] initWithMinDate:startOfThisMonth maxDate:endOfThisMonth];
    [self.timeList addObject:thisMonth];

    //THIS QUARTER
    NSDate *startOfThisQuater;
    NSDate *endOfThisQuater;
    NSTimeInterval intervalThisQuater;
    [cal rangeOfUnit:NSQuarterCalendarUnit startDate:&startOfThisQuater interval:&intervalThisQuater forDate:now];
    endOfThisQuater = [startOfThisQuater dateByAddingTimeInterval:intervalThisQuater-1];
    TimeObject *thisQuater = [[TimeObject alloc] initWithMinDate:startOfThisQuater maxDate:endOfThisQuater];
    [self.timeList addObject:thisQuater];
    
    //THIS FINANCE YEAR
    NSDate *startOfThisFinanceYear;
    NSDate *endOfThisFinanceYear;
    
    NSDateComponents *components = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    if(components.month < 7) {
        startOfThisFinanceYear = [NSDate date];
        NSDateComponents *startOfThisFinanceYear_components = [cal components:0 fromDate:startOfThisFinanceYear];
        [startOfThisFinanceYear_components setYear:components.year-1];
        [startOfThisFinanceYear_components setMonth:7];
        [startOfThisFinanceYear_components setDay:1];
        startOfThisFinanceYear = [cal dateFromComponents:startOfThisFinanceYear_components];
        
        endOfThisFinanceYear = [NSDate date];
        NSDateComponents *endOfThisFinanceYear_component = [cal components:0 fromDate:endOfThisFinanceYear];
        [endOfThisFinanceYear_component setYear:components.year];
        [endOfThisFinanceYear_component setMonth:6];
        [endOfThisFinanceYear_component setDay:30];
        endOfThisFinanceYear = [cal dateFromComponents:endOfThisFinanceYear_component];
    }
    else {
        startOfThisFinanceYear = [NSDate date];
        NSDateComponents *startOfThisFinanceYear_components = [cal components:0 fromDate:startOfThisFinanceYear];
        [startOfThisFinanceYear_components setYear:components.year];
        [startOfThisFinanceYear_components setMonth:7];
        [startOfThisFinanceYear_components setDay:1];
        startOfThisFinanceYear = [cal dateFromComponents:startOfThisFinanceYear_components];
        
        endOfThisFinanceYear = [NSDate date];
        NSDateComponents *endOfThisFinanceYear_component = [cal components:0 fromDate:endOfThisFinanceYear];
        [endOfThisFinanceYear_component setYear:components.year + 1];
        [endOfThisFinanceYear_component setMonth:6];
        [endOfThisFinanceYear_component setDay:30];
        endOfThisFinanceYear = [cal dateFromComponents:endOfThisFinanceYear_component];
    }
    TimeObject *thisFinanceYear = [[TimeObject alloc] initWithMinDate:startOfThisFinanceYear maxDate:endOfThisFinanceYear];
    [self.timeList addObject:thisFinanceYear];
    
    //LAST WEEK
    NSDate *startOfLastWeek;
    NSDate *endOfLastWeek = [startOfThisWeek dateByAddingTimeInterval:-1];
    NSTimeInterval intervalLastWeek;
    [cal rangeOfUnit:NSWeekCalendarUnit startDate:&startOfLastWeek interval:&intervalLastWeek forDate:endOfLastWeek];
    TimeObject *lastWeek = [[TimeObject alloc] initWithMinDate:startOfLastWeek maxDate:endOfLastWeek];
    [self.timeList addObject:lastWeek];
    
    
    //LAST MONTH
    NSDate *startOfLastMonth;
    NSDate *endOfLastMonth = [startOfThisMonth dateByAddingTimeInterval:-1];
    NSTimeInterval intervalLastMonth;
    [cal rangeOfUnit:NSMonthCalendarUnit startDate:&startOfLastMonth interval:&intervalLastMonth forDate:endOfLastMonth];
    TimeObject *lastMonth = [[TimeObject alloc] initWithMinDate:startOfLastMonth maxDate:endOfLastMonth];
    [self.timeList addObject:lastMonth];
    
    //LAST QUATER
    NSDate *startOfLastQuarter;
    NSDate *endOfLastQuarter = [startOfThisQuater dateByAddingTimeInterval:-1];
    NSTimeInterval intervalLastQuarter;
    [cal rangeOfUnit:NSQuarterCalendarUnit startDate:&startOfLastQuarter interval:&intervalLastQuarter forDate:endOfLastQuarter];
    TimeObject *lastQuarter = [[TimeObject alloc] initWithMinDate:startOfLastQuarter maxDate:endOfLastQuarter];
    [self.timeList addObject:lastQuarter];
    
    //LAST FINANCE YEAR
    NSDate *startOfLastFinanceYear;
    NSDate *endOfLastFinanceYear;
    NSDateComponents *startOfLastFinanceYear_component = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startOfThisFinanceYear];
    [startOfLastFinanceYear_component setYear:startOfLastFinanceYear_component.year - 1];
    startOfLastFinanceYear = [cal dateFromComponents:startOfLastFinanceYear_component];
    NSDateComponents *endOfLastFinanceYear_component = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:endOfThisFinanceYear];
    [endOfLastFinanceYear_component setYear:endOfLastFinanceYear_component.year - 1];
    endOfLastFinanceYear = [cal dateFromComponents:endOfLastFinanceYear_component];
    TimeObject *lastFinanceYear = [[TimeObject alloc] initWithMinDate:startOfLastFinanceYear maxDate:endOfLastFinanceYear];
    [self.timeList addObject:lastFinanceYear];

}

- (TimeObject *)getTimeObject:(NSInteger)index
{
    return [self.timeList objectAtIndex:index];
}

- (NSString *)getPaymentName:(NSInteger)paymentId
{
    return [self.paymentTypes objectAtIndex:paymentId];
}

- (void) generateMetaType
{
    self.metaType = [[NSMutableArray alloc] init];
    [self.metaType addObject:@"Produce Packing Type"];
    [self.metaType addObject:@"Produce Size"];
    
}

- (NSString *)getMetaTypeName:(NSInteger)paymentId
{
    return [self.metaType objectAtIndex:paymentId];
}

- (NSInteger)getMetaTypeIndex:(NSString *)name
{
    for(int i = 0; i < self.metaType.count; i++){
        if([[self.metaType objectAtIndex:i] isEqualToString:name]){
            return i;
            break;
        }
    }
    return 0;
}

- (void) generateMonthList
{
    self.produceMonth = [[NSMutableArray alloc] init];
    self.produceMonthStr = [[NSMutableArray alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *last5Month = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit) fromDate:now];
    last5Month.day = 1;
    last5Month.month -= 4;
    if(last5Month.month < 0) {
        last5Month.month = 12;
        last5Month.year --;
    }
    [self.produceMonth addObject:[cal dateFromComponents:last5Month] ];
    [self.produceMonthStr addObject:[NSString stringWithFormat:@"%@ - %ld",[self getMonthString:last5Month.month], (long)last5Month.year]];

    
    NSDateComponents *last4Month = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit) fromDate:now];
    last4Month.day = 1;
    last4Month.month -= 3;
    if(last4Month.month < 0) {
        last4Month.month = 12;
        last4Month.year --;
    }
    [self.produceMonth addObject:[cal dateFromComponents:last4Month]];
    [self.produceMonthStr addObject:[NSString stringWithFormat:@"%@ - %ld",[self getMonthString:last4Month.month], (long)last4Month.year]];
    
    NSDateComponents *last3Month = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit) fromDate:now];
    last3Month.day = 1;
    last3Month.month -= 2;
    if(last3Month.month < 0) {
        last3Month.month = 12;
        last3Month.year --;
    }
    [self.produceMonth addObject:[cal dateFromComponents:last3Month]];
    [self.produceMonthStr addObject:[NSString stringWithFormat:@"%@ - %ld",[self getMonthString:last3Month.month], (long)last3Month.year]];
    
    NSDateComponents *last2Month = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit) fromDate:now];
    last2Month.day = 1;
    last2Month.month -= 1;
    if(last2Month.month < 0) {
        last2Month.month = 12;
        last2Month.year --;
    }
    [self.produceMonth addObject:[cal dateFromComponents:last2Month]];
    [self.produceMonthStr addObject:[NSString stringWithFormat:@"%@ - %ld",[self getMonthString:last2Month.month], (long)last2Month.year]];
    
    NSDateComponents *last1Month = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit) fromDate:now];
    last1Month.day = 1;
    [self.produceMonth addObject:[cal dateFromComponents:last1Month]];
    [self.produceMonthStr addObject:[NSString stringWithFormat:@"%@ - %ld",[self getMonthString:last1Month.month], (long)last1Month.year]];
    
    NSDateComponents *thisMonth = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit) fromDate:now];
    thisMonth.day = 1;
    thisMonth.month += 1;
    if(thisMonth.month > 12) {
        thisMonth.month = 1;
        thisMonth.year ++;
    }
    [self.produceMonthStr addObject:[NSString stringWithFormat:@"%@ - %ld",[self getMonthString:thisMonth.month], (long)thisMonth.year]];
    [self.produceMonth addObject:[cal dateFromComponents:thisMonth]];
}

- (NSString*) getMonthString :(NSInteger) month {
    NSString *monthStr =@"";
    switch (month) {
        case 1:
        {
            monthStr = @"January";
            break;
        }
        case 2:
        {
            monthStr = @"February";
            break;
        }
        case 3:
        {
            monthStr = @"March";
            break;
        }
        case 4:
        {
            monthStr = @"April";
            break;
        }
        case 5:
        {
            monthStr = @"May";
            break;
        }
        case 6:
        {
            monthStr = @"June";
            break;
        }
        case 7:
        {
            monthStr = @"July";
            break;
        }
        case 8:
        {
            monthStr = @"August";
            break;
        }
        case 9:
        {
            monthStr = @"September";
            break;
        }
        case 10:
        {
            monthStr = @"October";
            break;
        }
        case 11:
        {
            monthStr = @"November";
            break;
        }
        case 12:
        {
            monthStr = @"December";
            break;
        }
        default:
            break;
    }
    return monthStr;
}
@end
