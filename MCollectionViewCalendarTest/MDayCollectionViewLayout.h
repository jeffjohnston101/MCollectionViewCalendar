//
//  MDayCollectionViewLayout.h
//  MCollectionViewCalendarTest
//
//  Created by Jeffrey Johnston on 10/9/13.
//  Copyright (c) 2013 Ill Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDayCollectionViewLayout :  UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;

@end
