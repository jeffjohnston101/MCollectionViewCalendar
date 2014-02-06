//
//  MDayViewController.h
//  MCollectionViewCalendarTest
//
//  Created by Jeffrey Johnston on 10/10/13.
//  Copyright (c) 2013 Ill Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDayViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>


//@property (strong, nonatomic) UIPanGestureRecognizer *cellPanGestureRecognizer;
@property (strong, nonatomic) UILongPressGestureRecognizer *cellLongPressGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIView *menuModalView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


- (IBAction)cancelButtonPressed:(id)sender;

@end
