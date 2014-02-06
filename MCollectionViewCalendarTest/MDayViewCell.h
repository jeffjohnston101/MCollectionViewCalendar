//
//  MDayViewCell.h
//  MCollectionViewCalendarTest
//
//  Created by Jeffrey Johnston on 10/9/13.
//  Copyright (c) 2013 Ill Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDayViewCell : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *halfHourImageView;
@property (nonatomic) NSInteger cellSection;
@property (strong, nonatomic) IBOutlet UILabel *sectionLabel;

@property (strong, nonatomic) UIPanGestureRecognizer *cellPanGestureRecognizer;
//@property (strong, nonatomic) UILongPressGestureRecognizer *cellLongPressGestureRecognizer;




@end
