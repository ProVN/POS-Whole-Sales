//
//  GridTableViewCell.h
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridTableViewCell : UITableViewCell

typedef enum {
    GridCellValueTypeDate,
    GridCellValueTypeDateInline,
    GridCellValueId,
    GridCellValueName,
    GridCellValueBoolean,
    GridCellValueNumber,
    GridCellValueMoney
}kGridCellValueType;

@property(nonatomic,strong) NSArray* values;
@property(nonatomic,strong) NSArray* colSpans;
@property(nonatomic,strong) NSArray* colTypes;
@property(nonatomic, assign) BOOL isHeader;
@property(nonatomic, assign) BOOL isEnable;

-(void) drawCell:(CGFloat) maxWith;

@end
