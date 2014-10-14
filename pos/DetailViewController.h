//
//  DetailViewController.h
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

- (IBAction)products:(id)sender;
- (IBAction)sales:(id)sender;
- (IBAction)purchases:(id)sender;
- (IBAction)customers:(id)sender;
- (IBAction)payments:(id)sender;
- (IBAction)suppliers:(id)sender;
- (IBAction)reports:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
