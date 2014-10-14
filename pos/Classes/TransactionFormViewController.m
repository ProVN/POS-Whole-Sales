//
//  SalesFormViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "TransactionFormViewController.h"
#import "LessTransportViewController.h"
#import "CustomerSelectViewViewController.h"
#import "DBManager.h"
#import "POSProduct.h"
#import "POSSaleInvoice.h"
#import "POSSaleInvoiceDetail.h"
#import "POSSaleInvoicePayment.h"
#import "POSPurchase.h"
#import "POSPurchasePayment.h"
#import "POSCollectionFlowLayout.h"
#import "ProductCollectionViewCell.h"
#import "GridTableViewCell.h"
#import "HeaderView.h"
#import "POSMeta.h"
#import "POSCustomer.h"
#import "POSSupplier.h"
#import "POSCategory.h"
#import "POSPurchaseDetail.h"
#import "BillViewController.h"

@interface TransactionFormViewController ()

@end

@implementation TransactionFormViewController
{
    float total;
    float payment;
    float balance;
    float discount;
    float gst;
    NSArray* colSpans;
    NSArray* colTypes;
    NSInteger itemProcessing;
    UIAlertView *loadingAlert;
    CGRect keyboardFrame;
    NSDate *selectedDate;
}

#pragma mark UIViewController Overwrite
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        editingIndex = -1;
        colSpans = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:3],
                    [NSNumber numberWithInt:1],
                    nil];
        colTypes = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:GridCellValueTypeDate],
                    [NSNumber numberWithInt:GridCellValueId],
                    [NSNumber numberWithInt:GridCellValueName],
                    [NSNumber numberWithInt:GridCellValueMoney],
                    nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtCustomer.delegate = self;
    self.txtIssuedDate.delegate = self;
    
    UIColor *backgroundColor = [UIColor clearColor];
    
    POSCollectionFlowLayout *paymentLayout = [[POSCollectionFlowLayout alloc] init];
    paymentCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:paymentLayout];
    [paymentCollection registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"Cells"];
    [paymentCollection setBackgroundColor:backgroundColor];
    paymentCollection.dataSource = self;
    paymentCollection.delegate = self;
    
    POSCollectionFlowLayout *productLayout = [[POSCollectionFlowLayout alloc] init];
    productCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:productLayout];
    [productCollection registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"Cells"];
    [productCollection setBackgroundColor:backgroundColor];
    productCollection.dataSource = self;
    productCollection.delegate = self;
    
    POSCollectionFlowLayout *subProductLayout = [[POSCollectionFlowLayout alloc] init];
    subproductCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:subProductLayout];
    [subproductCollection registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"Cells"];
    [subproductCollection setBackgroundColor:backgroundColor];
    subproductCollection.dataSource = self;
    subproductCollection.delegate = self;
    
    self.itemCartView.layer.borderColor = [self mainColor].CGColor;
    self.itemCartView.layer.borderWidth = 1;
    self.itemCartView.layer.cornerRadius = 5;
    
    self.productView.layer.borderColor = [self mainColor].CGColor;
    self.productView.layer.borderWidth = 1;
    self.productView.layer.cornerRadius = 5;
    
    
    self.txtDescription.layer.borderColor = [self mainColor].CGColor;
    self.txtDescription.layer.borderWidth = 1;
    self.txtDescription.layer.cornerRadius = 5;
    self.txtDescription.delegate = self;
    
    [self.holderView addSubview:self.itemView];
    
    
    //Add ProductCollectionView to ViewController
    [self.itemCartView addSubview:paymentCollection];
    [self.productView addSubview:productCollection];
    
    //Generate data
    productSource = [DBCaches sharedInstant].categories;
    subProductSource = [[NSMutableArray alloc] init];

    if(transaction)
    {
        switch (transactionType) {
            case TransactionTypeSale:
            {
                POSSaleInvoice* saleInvoice = (POSSaleInvoice*)transaction;
                issuedDate = saleInvoice.IssuedTime;
                contact = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].customers withId:saleInvoice.CustID];
                self.txtDescription.text = saleInvoice.Memo;
                self.txtCreditService.on = saleInvoice.CreditService;
                
                [self.txtGst setOn:saleInvoice.IsGstIncluded];
                
                self.txtCustomer.text = [(POSCustomer*)contact CompanyName];
                NSString* saleNo = saleInvoice.SaleInvoiceRef;
                self.lblTransactionID.text = saleNo;
                break;
            }
            case TransactionTypePurchase:
            {
                
                POSPurchase* purchase = (POSPurchase*) transaction;
                issuedDate = purchase.IssuedTime;
                contact = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].suppliers withId:purchase.SupplierID];
                self.txtDescription.text = purchase.Memo;
                [self.txtGst setOn:purchase.IsGstIncluded];
                self.txtCreditService.on = purchase.CreditService;
                self.txtCustomer.text = [(POSCustomer*)contact CompanyName];
                NSString* purNo = purchase.PurchaseRef;
                self.lblTransactionID.text = purNo;
                break;
            }
            default:
                break;
        }
        deletedItems = [[NSMutableArray alloc] init];
        deletedLessTransports = [[NSMutableArray alloc] init];
        deletedPayments = [[NSMutableArray alloc] init];
        [self requestData];
        
    }
    else
    {
        self.lblTransactionID.hidden = YES;
        if(itemSource == nil)
            itemSource = [[NSMutableArray alloc] init];
        if(lessTransportSource == nil)
            lessTransportSource = [[NSMutableArray alloc] init];
        if(paymentSource == nil)
            paymentSource = [[NSMutableArray alloc] init];
        if(issuedDate == nil)
            issuedDate = [NSDate date];
    }
    
    self.txtIssuedDate.text = [POSCommon formatDateToString:issuedDate];
    //Add navigation button
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doSave)];
    UIBarButtonItem *btnPrint = [[UIBarButtonItem alloc] initWithTitle:@"Print Only" style:UIBarButtonItemStylePlain target:self action:@selector(doPrint)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:btnPrint, btnSave, nil];
    
    //Add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.bottomView.layer.zPosition = 999;
    [self.bottomView setBackgroundColor:[UIColor whiteColor]];
    self.txtDiscount.delegate = self;
    [self initDragAndDrop];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    [self calculateTotal];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dateTimePickerSaved:(NSDate *)date tag:(int)tag
{
    issuedDate = date;
    self.txtIssuedDate.text = [POSCommon formatDateToString:date];
}

#pragma mark -
#pragma mark User Defined

-(void) keyboardWillShow:(NSNotification*) notification
{
    NSDictionary *info = [notification userInfo];
    keyboardFrame = [[info valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frame = self.bottomView.frame;
    double animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if([POSCommon isLandscapeMode])
    {   self.bottomView.layer.borderColor = self.mainColor.CGColor;
        self.bottomView.layer.borderWidth = 2.0f;
        frame.origin.y -= keyboardFrame.size.width;
    }
    else {
        frame.origin.y -= keyboardFrame.size.height;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.bottomView.frame = frame;
    [UIView commitAnimations];
}
-(void) keyboardWillHide:(NSNotification*) notification
{
    CGRect frame = self.bottomView.frame;
    if([POSCommon isLandscapeMode])
    {
        frame.origin.y += keyboardFrame.size.width;
    }
    else {
        frame.origin.y += keyboardFrame.size.height;
    }
    
    NSDictionary *info = [notification userInfo];
    self.bottomView.layer.borderColor = [UIColor clearColor].CGColor;
    self.bottomView.layer.borderWidth = 0.0f;
    double animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.bottomView.frame = frame;
    [UIView commitAnimations];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Init ProductCollectionView
    [self reloadLayouts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self reloadLayouts];
}

#pragma mark-
#pragma mark IBAction Function
- (IBAction)tabItemPaymentChanged:(id)sender {
    if(self.tabItemPayMent.selectedSegmentIndex == 0) {
        [self.btnAddTransportPayment setTitle:@"Add Less Tranport" forState:UIControlStateNormal];
        [self.paymentView removeFromSuperview];
        [self.holderView addSubview:self.itemView];
        [self initDragAndDrop];
    }
    else {
        self.helper = nil;
        [self.btnAddTransportPayment setTitle:@"Add payment" forState:UIControlStateNormal];
        [self.itemView removeFromSuperview];
        [self.holderView addSubview:self.paymentView];
    }
}

- (IBAction)tabProductsValueChanged:(id)sender {
    if(self.tabProducts.selectedSegmentIndex == 0)
    {
        [subproductCollection removeFromSuperview];
        [self.productView addSubview:productCollection];
    }
    else
    {
        [productCollection removeFromSuperview];
        [self.productView addSubview:subproductCollection];
        [self initDragAndDrop];
    }
}

- (IBAction)btnAddTransportPaymentTouched:(id)sender {
    if(self.tabItemPayMent.selectedSegmentIndex == 0) {
        LessTransportViewController *vc = [[LessTransportViewController alloc] initWithNibName:@"LessTransportViewController" bundle:nil];
        [vc setLessTransport:nil target:self];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        PaymentFormViewController *vc = [[PaymentFormViewController alloc] initWithNibName:@"PaymentFormViewController" bundle:nil];
        [vc setPaymentItem:nil transactionType:transactionType target:self];
        vc.balance = [NSNumber numberWithFloat:balance];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

#pragma mark -
#pragma mark User defined private functions
- (void) initDragAndDrop
{
    self.helper = [[I3DragBetweenHelper alloc] initWithSuperview:self.view
                                                         srcView:subproductCollection
                                                         dstView:paymentCollection];
    self.helper.delegate = self;
    self.helper.isDstRearrangeable = YES;
    self.helper.isSrcRearrangeable = NO;
    self.helper.doesSrcRecieveDst = NO;
    self.helper.doesDstRecieveSrc = YES;
    self.helper.hideDstDraggingCell = YES;
    self.helper.hideSrcDraggingCell = NO;
}

- (void) reloadLayouts
{
    CGRect itemCartRect = self.itemCartView.frame;
    itemCartRect.size.width = self.holderView.frame.size.width;
    self.itemCartView.frame= itemCartRect;
    
    CGRect paymentCartRect = self.paymentCartView.frame;
    paymentCartRect.size.width = self.holderView.frame.size.width;
    self.paymentCartView.frame = paymentCartRect;
    
    CGRect productRect = self.productView.frame;
    productRect.size.width = self.holderView.frame.size.width;
    self.productView.frame = productRect;
    
    CGRect subRect = CGRectMake(0, -10, itemCartRect.size.width, itemCartRect.size.height);
    paymentCollection.frame = subRect;
    subRect = CGRectMake(0, 0, productRect.size.width, productRect.size.height);
    productCollection.frame = subRect;
    subproductCollection.frame = subRect;
}

- (void) calculateTotal
{
    if(transactionType == TransactionTypeSale)
    {
        total = 0;
        payment= 0;
        for(POSSaleInvoiceDetail *invoice in itemSource)
            total += [invoice.TotalAmount floatValue];
        for(POSLessTransport *lesTransport in lessTransportSource)
            total += [lesTransport.TotalTransport floatValue];
        for(POSSaleInvoicePayment *saleInvoicePayment in paymentSource)
            payment += [saleInvoicePayment.PaymentAmount floatValue];
        balance = total + gst - payment - discount;
    }
    else {
        total = 0;
        payment= 0;
        for(POSPurchaseDetail *invoice in itemSource)
            total += [invoice.TotalAmount floatValue];
        for(POSPurchasePayment *saleInvoicePayment in paymentSource)
            payment += [saleInvoicePayment.PaymentAmount floatValue];
        balance = total + gst - payment - discount;
    }
    
    if([self.txtGst isOn]) {
        gst = total/11;
    }
    else
    {
        gst = 0;
    }
    
    self.lblTotal.text = [POSCommon formatCurrencyFromNumber:[NSNumber numberWithFloat:total]];
    self.lblPayment.text = [POSCommon formatCurrencyFromNumber:[NSNumber numberWithFloat:payment]];
    self.lblBalance.text = [POSCommon formatCurrencyFromNumber:[NSNumber numberWithFloat:balance]];
    self.txtGstValue.text = [POSCommon formatCurrencyFromNumber:[NSNumber numberWithFloat:gst]];
}

-(void) doSave
{
    if([self isValidContent])
    {
        [loadingAlert setMessage:@"Saving..."];
        [loadingAlert show];
        [self saveData];
    }
}

- (BOOL)deletedDataSynchonized
{
    if(deletedItems.count > 0)
    {
        if(transactionType == TransactionTypeSale)
        {
            [loadingAlert setMessage:@"Delete Sale Invoice Items..."];
            POSSaleInvoiceDetail* obj = [deletedItems lastObject];
            [deletedItems removeLastObject];
            [[DBManager sharedInstant] deleteData:kDbSaleInvoiceDetails item:obj title:nil message:nil target:self];
        }
        else
        {
            //TODO:
        }
        return NO;
    }
    else if(deletedLessTransports.count > 0)
    {
        if(transactionType == TransactionTypeSale)
        {
            [loadingAlert setMessage:@"Delete Sale Invoice Less Transport..."];
            POSLessTransport* obj = [deletedLessTransports lastObject];
            [deletedLessTransports removeLastObject];
            [[DBManager sharedInstant] deleteData:kDbLessTransports item:obj title:nil message:nil target:self];
        }
        else
        {
            //TODO:
        }
        return NO;
    }
    else if(deletedPayments.count > 0)
    {
        if(transactionType == TransactionTypeSale)
        {
            [loadingAlert setMessage:@"Delete Sale Invoice Payment..."];
            POSSaleInvoicePayment* obj = [deletedPayments lastObject];
            [deletedPayments removeLastObject];
            [[DBManager sharedInstant] deleteData:kDbSaleInvoicePayments item:obj title:nil message:nil target:self];
        }
        else
        {
            //TODO:
        }
        return NO;
    }
    else
    {
        [loadingAlert setMessage:@"Delete Completed..."];
        return YES;
    }
}

- (void)saveData
{
    if(![self deletedDataSynchonized])
        return;
    [loadingAlert setMessage:@"Saving Sale Invoice..."];
    step = TransactionFormStepTransaction;
    if(transactionType == TransactionTypeSale)
    {
        POSCustomer *customer = (POSCustomer*)contact;
        POSSaleInvoice *saleInvoice = (POSSaleInvoice*) transaction;
        if(saleInvoice == nil)
        {
            saleInvoice = [[POSSaleInvoice alloc] init];
            saleInvoice.UserID = [DBManager sharedInstant].currentUser.Id;
            saleInvoice.AddedTime = [NSDate date];
            saleInvoice.SaleInvoiceRef = @"";
        }
        saleInvoice.CustID = customer.Id;
        saleInvoice.IssuedTime = issuedDate;
        saleInvoice.TotalAmount = [NSNumber numberWithFloat:total];
        saleInvoice.TotalPayment = [NSNumber numberWithFloat:payment];
        saleInvoice.Balance = [NSNumber numberWithFloat:balance];
        saleInvoice.Status = YES;
        saleInvoice.UpdatedTime = [NSDate date];
        saleInvoice.IsGstIncluded = self.txtGst.on;
        saleInvoice.IsLessTransport = NO;
        saleInvoice.Discount = [NSNumber numberWithFloat:discount];
        saleInvoice.CreditService = self.txtCreditService.on;
        saleInvoice.Memo = self.txtDescription.text;;
        [[DBManager sharedInstant] saveData:kDbSaleInvoices item:saleInvoice target:self];
    }
    else
    {
        POSSupplier *supplier = (POSSupplier*)contact;
        POSPurchase *purchase = (POSPurchase*) transaction;
        if(purchase == nil)
        {
            purchase = [[POSPurchase alloc] init];
            purchase.UserID = [DBManager sharedInstant].currentUser.Id;
            purchase.AddedTime = [NSDate date];
            purchase.PurchaseRef = @"";
        }
        purchase.SupplierID = supplier.Id;
        purchase.IssuedTime = issuedDate;
        purchase.TotalAmount = [NSNumber numberWithFloat:total];
        purchase.TotalPayment = [NSNumber numberWithFloat:payment];
        purchase.Balance = [NSNumber numberWithFloat:balance];
        purchase.Status = YES;
        purchase.UpdatedTime = [NSDate date];
        purchase.IsGstIncluded = self.txtGst.on;
        purchase.IsLessTransport = NO;
        purchase.Discount = [NSNumber numberWithFloat:discount];
        purchase.CreditService = self.txtCreditService.on;
        purchase.Memo = self.txtDescription.text;;
        [[DBManager sharedInstant] saveData:kDbPurchases item:purchase target:self];
    }
}

-(BOOL) isValidContent
{
    NSString *title = nil;
    if(transactionType == TransactionTypeSale)
        title = @"Sale Order";
    else
        title = @"Purchase Order";
    
    NSString *message = nil;
    if(contact == nil)
    {
        if(transactionType == TransactionTypeSale)
            message = @"choose a customer";
        else
            message = @"choose a supplier";
    }
    else if(itemSource.count == 0)
    {
        message = @"choose as least one item";
    }
    if(message)
    {
        message = [NSString stringWithFormat:@"Please %@ to make a %@",message, title];
        [POSCommon showError:title message:message];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark User defined public functions
-(void) requestData
{
    NSPredicate *predicate = nil;
    if(transactionType == TransactionTypeSale)
    {
        predicate = [NSPredicate predicateWithFormat:@"SaleInvoiceID=%@", transaction.Id];
        itemSource = [[[DBCaches sharedInstant].saleInvoiceDetails filteredArrayUsingPredicate:predicate] mutableCopy];

        lessTransportSource = [[[DBCaches sharedInstant].lessTransport filteredArrayUsingPredicate:predicate] mutableCopy];
        
        paymentSource = [[[DBCaches sharedInstant].saleInvoicePayments filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"PurchaseID=%@", transaction.Id];
        itemSource = [[[DBCaches sharedInstant].purchaseDetail filteredArrayUsingPredicate:predicate] mutableCopy];
        
        lessTransportSource = [[NSMutableArray alloc] init];
        
        paymentSource = [[[DBCaches sharedInstant].purchasePayments filteredArrayUsingPredicate:predicate] mutableCopy];
    }
}

-(void) setTransaction:(POSObject *)transactionObj type:(TransactionType)type
{
    transactionType = type;
    switch (transactionType) {
        case TransactionTypeSale:
            self.title =@"Sale Order's information";
            break;
        case TransactionTypePurchase:
            self.title =@"Purchase Order's information";
            break;
        default:
            break;
    }
    loadingAlert = [[UIAlertView alloc] initWithTitle:self.title message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    if(transactionObj)
        transaction = transactionObj;
}
#pragma mark -
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == self.txtCustomer)
    {
        if(transactionType == TransactionTypeSale)
            [POSCommon showContactPicker:self contactType:ContactTypeCustomer allowSelectAll:NO target:self];
        else if(transactionType == TransactionTypePurchase)
            [POSCommon showContactPicker:self contactType:ContactTypeSuppplier allowSelectAll:NO target:self];
        return NO;
    }
    else if(textField == self.txtIssuedDate)
    {
        [POSCommon showDateTimePicker:self selectedDate:issuedDate target:nil];
        return NO;
    }
    else if(textField == self.txtDiscount)
    {
        if(discount == 0)
            textField.text = @"";
        else
            textField.text = [NSString stringWithFormat:@"%2f",discount];
            
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.txtDiscount)
    {
        if([POSCommon isCurrencyCharacter:string]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.txtDiscount)
    {
        discount = [self.txtDiscount.text floatValue];
        [self calculateTotal];
        self.txtDiscount.text = [POSCommon formatCurrencyFromNumber:[NSNumber numberWithFloat:discount]];
    }
}

#pragma mark -
#pragma mark UICollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if(collectionView == paymentCollection)
        return 2;
    else
        return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == paymentCollection)
    {
        if(section == 0)
            return [itemSource count];
        else
            return [lessTransportSource count];
    }
    else if(collectionView == productCollection)
        return [productSource count];
    else
        return [subProductSource count];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
     if(collectionView == paymentCollection) {
         [paymentCells addObject:cell];
     }
     else if(collectionView == productCollection){
         [productCells addObject:cell];
     }
     else if(collectionView == subproductCollection) {
         [subProductCells addObject:cell];
     }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView == paymentCollection) {
        if(indexPath.section == 0) {
            ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cells" forIndexPath:indexPath];
            if([paymentCells count])
            {
                cell = [paymentCells lastObject];
                [paymentCells removeLastObject];
            }
            else
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cells" forIndexPath:indexPath];
            
            if(transactionType == TransactionTypeSale)
            {
                POSSaleInvoiceDetail *invoiceDetails = [itemSource objectAtIndex:indexPath.item];
                POSProduct *product = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].products withId:invoiceDetails.ProductID];
                
                cell.displayname = product.Name;
                cell.cornerText = [NSString stringWithFormat:@"x%d",[invoiceDetails.Quantity intValue]];
                cell.price = invoiceDetails.SalePrice;
                cell.amount = invoiceDetails.TotalAmount;
                [cell applyProductSkin];
            }
            else
            {
                POSPurchaseDetail *invoiceDetails = [itemSource objectAtIndex:indexPath.item];
                POSProduct *product = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].products withId:invoiceDetails.ProductID];
                
                cell.displayname = product.Name;
                cell.cornerText = [NSString stringWithFormat:@"x%d",[invoiceDetails.Quantity intValue]];
                cell.price = invoiceDetails.PurchasePrice;
                cell.amount = invoiceDetails.TotalAmount;
                [cell applyProductSkin];

            }
            return cell;
        }
        else
        {
            ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cells" forIndexPath:indexPath];
            if([paymentCells count])
            {
                cell = [paymentCells lastObject];
                [paymentCells removeLastObject];
            }
            else
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cells" forIndexPath:indexPath];
            POSLessTransport *lessTransport = [lessTransportSource objectAtIndex:indexPath.item];
            NSString *price = [POSCommon formatCurrencyFromNumber:lessTransport.TransportPrice];
            cell.displayname = [NSString stringWithFormat:@"Less Transport\n%@",price];
            cell.cornerText = [NSString stringWithFormat:@"x%d", [lessTransport.Quantity intValue]];
            cell.amount = lessTransport.TotalTransport;
            [cell applyTransportSkin];
            return cell;
        }
    }
    
    else if(collectionView == productCollection) {
        ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cells" forIndexPath:indexPath];
        if([productCells count])
        {
            cell = [productCells lastObject];
            [productCells removeLastObject];
        }
        else
        {
            cell = [productCollection dequeueReusableCellWithReuseIdentifier:@"Cells" forIndexPath:indexPath];
        }
        
        POSCategory *category = [productSource objectAtIndex:indexPath.item];
        cell.displayname = category.Name;
        [cell applyProductSkin];
        return cell;
    }
    else
    {
        ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cells"forIndexPath:indexPath];
//        if([subProductCells count])
//        {
//            cell = [subProductCells lastObject];
//            [subProductCells removeLastObject];
//        }
//        else
//        {
            cell = [productCollection dequeueReusableCellWithReuseIdentifier:@"Cells" forIndexPath:indexPath];
//        }
        
        POSProduct *product = [subProductSource objectAtIndex:indexPath.item];
        cell.displayname = product.Name;
        [cell applyProductSkin];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == productCollection)
    {
        self.tabProducts.selectedSegmentIndex = 1;
        subProductCells = [[NSMutableArray alloc] init];
        POSCategory *category = [productSource objectAtIndex:indexPath.item];
        subProductSource = [[NSMutableArray alloc] init];
        [subproductCollection clearsContextBeforeDrawing];
        [subproductCollection reloadData];
        
        subProductSource = [POSProduct filterWithCategoryId:[DBCaches sharedInstant].products categoryId:category.Id];
        subProductSource = [POSProduct filterWithStatus:subProductSource status:YES];
        
        [productCollection removeFromSuperview];
        
        id ds = subproductCollection.dataSource;
        
        POSCollectionFlowLayout *subProductLayout = [[POSCollectionFlowLayout alloc] init];
//        subproductCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:subProductLayout];
//        [subproductCollection registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"Cells"];
//        [subproductCollection setBackgroundColor:[UIColor clearColor]];
//        subproductCollection.dataSource = ds;
//        subproductCollection.delegate = ds;
        
        [subproductCollection reloadData];
        [self.productView addSubview:subproductCollection];
        [self.tabProducts setEnabled:YES forSegmentAtIndex:1];
        [self initDragAndDrop];
    }
    else if(collectionView == paymentCollection)
    {
        if(indexPath.section == 0)
        {
            if(transactionType == TransactionTypeSale)
            {
                POSSaleInvoiceDetail *invoiceDetails = [itemSource objectAtIndex:indexPath.item];
                editingIndex = indexPath.item;
                SaleInvoiceDetailsInput *view = [[SaleInvoiceDetailsInput alloc] initWithNibName:@"SaleInvoiceDetailsInput" bundle:nil];
                view.transactionType = transactionType;
                [view setSaleInvoiceDetails:invoiceDetails target:self];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
                view.title = @"";
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                [self presentViewController:nav animated:YES completion:nil];
                
            }
            else
            {
                POSPurchaseDetail *invoiceDetails = [itemSource objectAtIndex:indexPath.item];
                editingIndex = indexPath.item;
                SaleInvoiceDetailsInput *view = [[SaleInvoiceDetailsInput alloc] initWithNibName:@"SaleInvoiceDetailsInput" bundle:nil];
                view.transactionType = transactionType;
                [view setSaleInvoiceDetails:invoiceDetails target:self];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
                view.title = @"";
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
        else
        {
            POSLessTransport *lessTransport = [lessTransportSource objectAtIndex:indexPath.item];
            LessTransportViewController *vc = [[LessTransportViewController alloc] initWithNibName:@"LessTransportViewController" bundle:nil];
            editingIndex = indexPath.item;
            [vc setLessTransport:lessTransport target:self];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [paymentSource removeObjectAtIndex:indexPath.row];
    [self.paymentCartView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return paymentSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    NSArray *values = [[NSArray alloc] initWithObjects:
                  @"Date",
                  @"Payment Type",
                  @"Description",
                  @"Amount",
                  nil];
    header.values = values;
    header.colSpans = colSpans;
    [header drawCell:self.view.frame.size.width - 36];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridTableViewCell *cell = [[GridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSArray* values;
    switch (transactionType)
    {
        case TransactionTypeSale:
        {
            POSSaleInvoicePayment *paymentObj = [paymentSource objectAtIndex:indexPath.row];
            NSString *paymentType = [[POSMeta sharedInstance] getPaymentName:[paymentObj.PaymentType integerValue]];
            values = [[NSArray alloc] initWithObjects:
                      paymentObj.PaymentTime,
                      paymentType,
                      paymentObj.Description,
                      paymentObj.PaymentAmount,
                      nil];
            break;
        }
        case TransactionTypePurchase:
        {
            POSPurchasePayment *paymentObj = [paymentSource objectAtIndex:indexPath.row];
            NSString *paymentType = [[POSMeta sharedInstance] getPaymentName:[paymentObj.PaymentType integerValue]];
            values = [[NSArray alloc] initWithObjects:
                      paymentObj.PaymentTime,
                      paymentType,
                      paymentObj.Description,
                      paymentObj.PaymentAmount,
                      nil];
            break;
        }
        default:
            break;
    }
    cell.values = values;
    cell.colSpans = colSpans;
    cell.colTypes = colTypes;
    [cell drawCell:self.view.frame.size.width - 32];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingIndex = indexPath.row;
    PaymentFormViewController *vc = [[PaymentFormViewController alloc] initWithNibName:@"PaymentFormViewController" bundle:nil];
    id paymentObj = [paymentSource objectAtIndex:indexPath.row];
    [vc setPaymentItem:paymentObj transactionType:transactionType target:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark i3DragAndDropDelegate
//User try to add the product from product list to payment list
-(void) droppedOnDstAtIndexPath:(NSIndexPath*) to fromSrcIndexPath:(NSIndexPath*)from
{
    fromIndex = (from.item);
    if(to == nil) to = [NSIndexPath indexPathForItem:itemSource.count inSection:0];
    toIndex = (to.item);
    POSProduct* product = [subProductSource objectAtIndex:fromIndex];
    SaleInvoiceDetailsInput *view = [[SaleInvoiceDetailsInput alloc] initWithNibName:@"SaleInvoiceDetailsInput" bundle:nil];
    view.transactionType = transactionType;
    if(transactionType == TransactionTypeSale){
        POSSaleInvoiceDetail *currentInvoice = nil;
        if(itemSource.count)
        {
            NSInteger index = 0;
            for(POSSaleInvoiceDetail *invoice in itemSource)
            {
                if([invoice.ProductID intValue] == [product.Id intValue])
                {
                    editingIndex = index;
                    currentInvoice = invoice;
                    break;
                }
                index++;
            }
        }
        if(currentInvoice)
        {
            [view setSaleInvoiceDetails:currentInvoice target:self];
        }
        else
        {
            editingIndex = -1;
            [view setProduct:product target:self];
        }
    }
    else {
        POSPurchaseDetail *currentInvoice = nil;
        if(itemSource.count)
        {
            NSInteger index = 0;
            for(POSPurchaseDetail *invoice in itemSource)
            {
                if([invoice.ProductID intValue] == [product.Id intValue])
                {
                    editingIndex = index;
                    currentInvoice = invoice;
                    break;
                }
                index++;
            }
        }
        if(currentInvoice)
        {
            [view setSaleInvoiceDetails:currentInvoice target:self];
        }
        else
        {
            editingIndex = -1;
            [view setProduct:product target:self];
        }
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    view.title = product.Name;
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}


//User try to delete the product on payment list
- (BOOL)droppedOutsideAtPoint:(CGPoint)pointIn fromDstIndexPath:(NSIndexPath *)from
{
    @try
    {
        fromIndex = (from.item);
        if(from.section == 0)
        {
            POSObject* obj = [itemSource objectAtIndex:fromIndex];
            if(obj.Id)
            {
                [deletedItems addObject:obj];
            }
            [itemSource removeObjectAtIndex:fromIndex];
        }
        else
        {
            POSObject* obj = [lessTransportSource objectAtIndex:fromIndex];
            if(obj.Id)
            {
                [deletedLessTransports addObject:obj];
            }
            [lessTransportSource removeObjectAtIndex:fromIndex];
        }
        [paymentCollection deleteItemsAtIndexPaths:@[from]];
    }
    @catch (NSException *e){
        NSLog(@"Exception %@",e);
    }
    return NO;
}

-(BOOL) isCellAtIndexPathDraggable:(NSIndexPath*) index inContainer:(UIView*) container;
{
    if(container == subproductCollection)
    {
//        POSProduct *product = [subProductSource objectAtIndex:index.item];
//        if([product.StockOnHand intValue] == 0) return NO;
    }
    return YES;
}

#pragma mark
#pragma mark SaleInvoiceDetailInputDelegate
- (void)saleInvoiceDetailsInputSaved:(POSObject*)saleInvoiceDetails
{
    if(editingIndex == -1)
    {
        [itemSource insertObject:saleInvoiceDetails atIndex:toIndex];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
        [paymentCollection insertItemsAtIndexPaths:@[indexPath]];
    }
    else
    {
        [itemSource setObject:saleInvoiceDetails atIndexedSubscript:editingIndex];
        [paymentCollection reloadItemsAtIndexPaths:[paymentCollection indexPathsForVisibleItems]];
        [paymentCollection reloadData];
        editingIndex = -1;
    }
    [self calculateTotal];
}
- (void)saleInvoiceDetailsInputCanceled
{
    return;
}

#pragma mark
#pragma mark LessTransportViewDelegate
- (void)lessTransportViewControllerSaved:(POSLessTransport *)lessTransport
{
    if(editingIndex == -1)
    {
        [lessTransportSource addObject:lessTransport];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lessTransportSource.count-1 inSection:1];
        [paymentCollection insertItemsAtIndexPaths:@[indexPath]];

    }
    else
    {
        [lessTransportSource setObject:lessTransport atIndexedSubscript:editingIndex];
        [paymentCollection reloadItemsAtIndexPaths:[paymentCollection indexPathsForVisibleItems]];
        [paymentCollection reloadData];
        editingIndex = -1;
    }
    [self calculateTotal];
}

- (void) lessTransportViewControllerCanceled
{
     return;
}

#pragma mark -
#pragma mark PaymentInputDelegate
- (void)paymentInputSaved:(id)paymentItem
{
    if(editingIndex == -1)
    {
        [paymentSource addObject:paymentItem];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:paymentSource.count-1 inSection:0];
        [self.paymentCartView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [paymentSource setObject:paymentItem atIndexedSubscript:editingIndex];
        [self.paymentCartView reloadRowsAtIndexPaths:[self.paymentCartView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
        [self.paymentCartView reloadData];
        editingIndex = -1;
    }
    [self calculateTotal];

}
- (void)paymentInputCanceled
{
    
}

#pragma mark
#pragma mark DateTimePickerDelegate
- (void)dateTimePickerSaved:(NSDate *)date
{
    issuedDate = date;
    self.txtIssuedDate.text = [POSCommon formatDateToString:issuedDate];
}
- (void)dateTimePickerCanceled
{
    
}

#pragma mark
#pragma mark ContactSelectDelegate
- (void)contactSelectChanged:(id)contactObj
{
    contact = contactObj;
    switch (transactionType) {
        case TransactionTypeSale:
        {
            POSCustomer* customer = contactObj;
            self.txtCustomer.text = customer.CompanyName;
            break;
        }
        case TransactionTypePurchase:
        {
            POSSupplier* supplier = contactObj;
            self.txtCustomer.text = supplier.CompanyName;
        }
        default:
            break;
    }
}

-(void) insertTransactionDetail
{
    if(transactionType == TransactionTypeSale)
    {
        [loadingAlert setMessage:@"Saving Sale Invoice Items..."];
        POSSaleInvoiceDetail *detail = [itemSource objectAtIndex:itemProcessing];
        detail.SaleInvoiceID = transaction.Id;
        [[DBManager sharedInstant] saveData:kDbSaleInvoiceDetails item:detail title:nil message:nil target:self];
    }
    else if(transactionType == TransactionTypePurchase)
    {
        [loadingAlert setMessage:@"Saving Purchase Items..."];
        POSPurchaseDetail *detail = [itemSource objectAtIndex:itemProcessing];
        detail.PurchaseID = transaction.Id;
        [[DBManager sharedInstant] saveData:kDbPurchaseDetails item:detail title:nil message:nil target:self];
    }
    itemProcessing++;
}

-(void) insertTransactionLessTransport
{
    if(transactionType == TransactionTypeSale)
    {
        [loadingAlert setMessage:@"Saving Sale Invoice Less Transport..."];
        POSLessTransport *lessTransport = [lessTransportSource objectAtIndex:itemProcessing];
        lessTransport.SaleInvoiceID = transaction.Id;
        [[DBManager sharedInstant] saveData:kDbLessTransports item:lessTransport title:nil message:nil target:self];
    }
    itemProcessing++;
}

-(void) insertTransactionPayment
{
    if(transactionType == TransactionTypeSale)
    {
        [loadingAlert setMessage:@"Saving Sale Invoice Payment..."];
        POSSaleInvoicePayment *paymentObj = [paymentSource objectAtIndex:itemProcessing];
        paymentObj.SaleInvoiceID = transaction.Id;
        [[DBManager sharedInstant] saveData:kDbSaleInvoicePayments item:paymentObj title:nil message:nil target:self];
    }
    else if(transactionType == TransactionTypePurchase)
    {
        [loadingAlert setMessage:@"Saving Purchase Payment..."];
        POSPurchasePayment *paymentObj = [paymentSource objectAtIndex:itemProcessing];
        paymentObj.PurchaseID = transaction.Id;
        [[DBManager sharedInstant] saveData:kDbPurchasePayments item:paymentObj title:nil message:nil target:self];
    }
    itemProcessing++;
}

#pragma mark
#pragma mark DBDelegate

- (void)saveDataCompleted:(POSObject *)insertedItem
{
    switch (step) {
        case TransactionFormStepTransaction:
        {
            transaction = insertedItem;
            itemProcessing = 0;
            [self insertTransactionDetail];
            step = TransactionFormStepTransactionDetail;
            NSLog(@"Save transaction type %d with Id=%@ completed\n",transactionType, insertedItem.Id);
            NSLog(@"Next step will save transaction details.");
            break;
        }
        case TransactionFormStepTransactionDetail:
        {
            NSLog(@"Save transaction details type %d TransactionID=%@ with Id=%@ completed (%d/%d)",transactionType, transaction.Id, insertedItem.Id, itemProcessing, itemSource.count);
            if(itemProcessing < itemSource.count)
            {
                [self insertTransactionDetail];
            }
            else
            {
                itemProcessing = 0;
                if(lessTransportSource.count)
                {
                    NSLog(@"Next step will save transaction transport.");
                    step = TransactionFormStepTransactionTransport;
                    [self insertTransactionLessTransport];
                }
                else if(paymentSource.count)
                {
                    NSLog(@"Next step will save transaction payment.");
                    step = TransactionFormStepTransactionPayment;
                    [self insertTransactionPayment];
                }
                else
                {
                    step = TransactionFormStepTransactionCompleted;
                }
            }
            break;
        }
        case TransactionFormStepTransactionTransport:
        {
            NSLog(@"Save transaction transport type %d TransactionID=%@ with Id=%@ completed (%d/%d)",transactionType, transaction.Id, insertedItem.Id, itemProcessing, lessTransportSource.count);
            if(itemProcessing < lessTransportSource.count)
            {
                [self insertTransactionLessTransport];
            }
            else
            {
                itemProcessing = 0;
                if(paymentSource.count)
                {
                    NSLog(@"Next step will save transaction payment.");
                    step = TransactionFormStepTransactionPayment;
                    [self insertTransactionPayment];
                }
                else
                {
                    step = TransactionFormStepTransactionCompleted;
                }
            }
            break;
        }
        case TransactionFormStepTransactionPayment:
        {
            NSLog(@"Save transaction payment type %d TransactionID=%@ with Id=%@ completed (%d/%d)",transactionType, transaction.Id, insertedItem.Id, itemProcessing, paymentSource.count);
            if(itemProcessing < paymentSource.count)
            {
                [self insertTransactionPayment];
            }
            else
            {
                itemProcessing = 0;
                step = TransactionFormStepTransactionCompleted;
            }
            break;
        }
        case TransactionFormStepTransactionCompleted:
        default:
            break;
    }
    if(step == TransactionFormStepTransactionCompleted)
    {
        [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        if(self.printInvoice.on)
        {
            [self doPrint];
        }
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"***** END SAVE TRANSACTION *****");
    }
}

- (void) doPrint
{
    BillViewController *view = [[BillViewController alloc] initWithNibName:@"BillViewController" bundle:nil];
    view.transactionType = transactionType;
    view.data = itemSource;
    view.paid = [POSCommon formatCurrencyFromNumber:[NSNumber numberWithFloat:payment]];
    if(transactionType == TransactionTypeSale) {
        
        view.gst = @"$0.00";
        view.invoiceNo = [(POSSaleInvoice*)transaction SaleInvoiceRef];
        POSCustomer * customer = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].customers withId:([(POSSaleInvoice*) transaction CustID])];
        
        view.customerName = customer.CompanyName;
        view.invoiceCredit = [(POSSaleInvoice*) transaction CreditService];
        view.invoiceDate = [(POSSaleInvoice*) transaction IssuedTime];
        view.toFrom = @"To";
        
    }
    else{
        view.gst =  @"$0.00";
        view.invoiceNo = [(POSPurchase*)transaction PurchaseRef];
        POSSupplier * customer = [[DBCaches sharedInstant] getObjectInCaches:[DBCaches sharedInstant].suppliers withId:([(POSPurchase*) transaction SupplierID])];
        view.customerName = customer.CompanyName;
        view.invoiceCredit = [(POSPurchase*) transaction CreditService];
        view.invoiceDate = [(POSPurchase*) transaction IssuedTime];
        view.toFrom = @"From";
    }
    
    
    view.balance = [POSCommon formatCurrencyFromNumber:[NSNumber numberWithFloat:balance]];
    view.contact = [[DBManager sharedInstant].currentUser FullName];
    view.dismount =[POSCommon formatCurrencyFromNumber:[NSNumber numberWithFloat:discount]];
    view.total =[POSCommon formatCurrencyFromNumber:[NSNumber numberWithFloat:total]];
    
    [POSCommon showPopup:view from:self];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)deleteDataCompleted:(id)objectId
{
    [self saveData];
}

- (void)requestFailed:(NSError *)message
{
    [POSCommon showError:@"Error" message:[NSString stringWithFormat:@"%@",message]];
}
#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView == self.txtDescription)
    {
        if([textView.text isEqualToString:@"Comment here"]){
            textView.text = @"";
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == self.txtDescription)
    {
        if([textView.text isEqualToString:@""]){
            textView.text = @"Comment here";
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
}

- (IBAction)switchChanged:(id)sender {
    [self calculateTotal];
}
@end
