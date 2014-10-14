//
//  ProductDetailViewController.m
//  pos
//
//  Created by Loc Tran on 2/10/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "POSCategory.h"
#import "POSMetadata.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController {
    NSNumber *categoryId;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.txtPackingType.delegate = self;
    self.txtSize.delegate = self;
    self.subProductOf.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark User Defined
- (void) setData:(POSProduct *)product
{
    if(product == nil) return;
    _product = [[POSProduct alloc] init];
    [_product setValueWithObject:product];
    POSCategory* category = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].categories withId:product.CategoryId];
    if(category)
        self.subProductOf.text = category.Name;
    categoryId = product.CategoryId;
    self.txtName.text = _product.Name;
    self.txtPackingType.text = _product.PackType;
    self.txtSize.text = _product.Size;
    self.txtLevies.text = [NSString stringWithFormat:@"%.4f", [_product.Levies floatValue]];
    self.txtStatus.selectedSegmentIndex = _product.Status ? 0 : 1;
}

- (POSProduct*)getData
{
    _product.Name = self.txtName.text;
    _product.CategoryId = categoryId;
    _product.PackType = self.txtPackingType.text;
    if(self.txtOtherSize.text.length == 0)
        _product.Size = self.txtSize.text;
    else
        _product.Size = self.txtOtherSize.text;
    if(self.txtStatus.selectedSegmentIndex == 0)
        _product.Status = YES;
    else
        _product.Status = NO;
    return _product;
}

- (BOOL) isValidData
{
    if(self.txtName.text.length == 0)
    {
        [POSCommon showError:@"Error" message:@"Please input product name."];
        [self.txtName becomeFirstResponder];
        return NO;
    }
    else if(self.txtPackingType.text.length == 0)
    {
        [POSCommon showError:@"Error" message:@"Please select packing type."];
        [self.txtName becomeFirstResponder];
        return NO;
    }
    else if(self.txtSize.text.length == 0 && self.txtOtherSize.text == 0)
    {
        [POSCommon showError:@"Error" message:@"Please select packing size."];
        [self.txtName becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtPackingType){
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSMutableArray *metaData = [DBCaches sharedInstant].metaDatas;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Group=%@",@"Product Packing Type"];
        metaData = [[metaData filteredArrayUsingPredicate:predicate] mutableCopy];
        for (POSMetadata* item in metaData) {
            [data addObject:item.Value];
        }
        [POSCommon showChooserWithData:data from:self withTag:1];
        return NO;
    }
    else if(textField == self.txtSize) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSMutableArray *metaData = [DBCaches sharedInstant].metaDatas;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Group=%@",@"Product Size"];
        metaData = [[metaData filteredArrayUsingPredicate:predicate] mutableCopy];
        for (POSMetadata* item in metaData) {
            [data addObject:item.Value];
        }
        [POSCommon showChooserWithData:data from:self withTag:2];
        return NO;
    }
    else if(textField == self.subProductOf)
    {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSMutableArray *categories = [DBCaches sharedInstant].categories;
        for (POSCategory* category in categories) {
            [data addObject:category.Name];
        }
        [POSCommon showChooserWithData:data from:self withTag:3];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark DataTableViewControllerDelegate
- (void)dataTableViewControllerSelected:(NSIndexPath *)indexPath withTag:(NSInteger)tag
{
    switch (tag) {
        case 1:
        {
            NSMutableArray *metaData = [DBCaches sharedInstant].metaDatas;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Group=%@",@"Product Packing Type"];
            metaData = [[metaData filteredArrayUsingPredicate:predicate] mutableCopy];
            POSMetadata* meta = [metaData objectAtIndex:indexPath.row];
            self.txtPackingType.text = meta.Value;
            break;
        }
        case 2:
        {
            NSMutableArray *metaData = [DBCaches sharedInstant].metaDatas;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Group=%@",@"Product Size"];
            metaData = [[metaData filteredArrayUsingPredicate:predicate] mutableCopy];
            POSMetadata* meta = [metaData objectAtIndex:indexPath.row];
            self.txtSize.text = meta.Value;
            self.txtOtherSize.text = @"";
            break;
        }
        case 3:
        {
            NSMutableArray *categories = [DBCaches sharedInstant].categories;
            POSCategory *category = [categories objectAtIndex:indexPath.row];
            categoryId = category.Id;
            self.subProductOf.text = category.Name;
            break;
        }
        default:
            break;
    }
}
@end
