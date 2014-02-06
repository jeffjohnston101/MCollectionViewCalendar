//
//  MDayCollectionViewLayout.m
//  MCollectionViewCalendarTest
//
//  Created by Jeffrey Johnston on 10/9/13.
//  Copyright (c) 2013 Ill Corporation. All rights reserved.
//

#import "MDayCollectionViewLayout.h"

static NSString * const MDayViewCellKind = @"DayCell";

@interface MDayCollectionViewLayout ()
@property (strong, nonatomic) NSDictionary *layoutInfo;
@end

@implementation MDayCollectionViewLayout


- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    self.itemSize = CGSizeMake(50.0f, 50.0f);
    self.interItemSpacingY = 10.0f;
    self.numberOfColumns = 10;
    
    //[self.collectionView setPagingEnabled:NO];
}


#pragma mark - Layout

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForDayAtIndexPath:indexPath];
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    newLayoutInfo[MDayViewCellKind] = cellLayoutInfo;
    self.layoutInfo = newLayoutInfo;
}


#pragma mark - Private

- (CGRect)frameForDayAtIndexPath:(NSIndexPath *)indexPath
{
        NSInteger row = indexPath.section / self.numberOfColumns;
        NSInteger column = indexPath.section % self.numberOfColumns;
        CGFloat spacingX = self.collectionView.bounds.size.width * 2 - self.itemInsets.left - self.itemInsets.right - (self.numberOfColumns * self.itemSize.width);
        
        if (self.numberOfColumns > 1)
        {
            spacingX = spacingX / (self.numberOfColumns - 1);
        }
        
        CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
        CGFloat originY = floor(self.itemInsets.top + (self.itemSize.height + self.interItemSpacingY) * row);
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}



-(CGPoint) targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //NSLog (@"proposedContentOffset.x value:  %f", proposedContentOffset.x);
    //NSLog (@"proposedContentOffset.y value:  %f", proposedContentOffset.y);
    CGFloat offsetAdjustmentX = MAXFLOAT;
    CGFloat offsetAdjustmentY = MAXFLOAT;
    CGFloat targetX = proposedContentOffset.x + self.interItemSpacingY + self.itemInsets.left + self.itemInsets.right + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    CGFloat targetY = proposedContentOffset.y + self.interItemSpacingY  + (CGRectGetHeight(self.collectionView.bounds) / 2.0); //+ self.itemInsets.top + self.itemInsets.bottom
    //NSLog (@"targetX value:  %f", targetX);
    //NSLog (@"targetY value:  %f", targetY);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    //CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    //NSLog(@"targetRect:   %@", NSStringFromCGRect(targetRect));
    
    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];
    
    for(UICollectionViewLayoutAttributes *layoutAttributes in array) {
        
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            CGFloat itemX = layoutAttributes.frame.origin.x;
            CGFloat itemY = layoutAttributes.frame.origin.y;
           
            if (ABS(itemX - targetX) < ABS(offsetAdjustmentX)) {
                offsetAdjustmentX = itemX - targetX;
                 //NSLog (@"offsetAdjustmentX value:  %f", offsetAdjustmentX);
            }
            if (ABS(itemY - targetY) < ABS(offsetAdjustmentY))
                offsetAdjustmentY = itemY - targetY;
                //NSLog (@"offsetAdjustmentY value:  %f", offsetAdjustmentY);
        }
    }
    
    //diagnostics
    NSLog (@"offsetAdjustmentX:  %f", offsetAdjustmentX);
    NSLog (@"offsetAdjustmentY:  %f", offsetAdjustmentY);
    CGPoint temp = CGPointMake(proposedContentOffset.x + offsetAdjustmentX, proposedContentOffset.y + offsetAdjustmentY);
    NSLog(@"temp:  %@", NSStringFromCGPoint(temp));
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustmentX, proposedContentOffset.y + offsetAdjustmentY);
    //return CGPointZero;
}



- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier, NSDictionary *elementsInfo, BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[MDayViewCellKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
        NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
        
        // make sure we count another row if one is only partially filled
        if ([self.collectionView numberOfSections] % self.numberOfColumns) {
            rowCount++;
        }
        
        CGFloat height = self.itemInsets.top + rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY + self.itemInsets.bottom;
    
    return CGSizeMake(self.collectionView.bounds.size.width * 2, height);
}


#pragma mark - Properties

- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;
    
    _itemInsets = itemInsets;
    
    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, itemSize)) return;
    
    _itemSize = itemSize;
    
    [self invalidateLayout];
}

- (void)setInterItemSpacingY:(CGFloat)interItemSpacingY
{
    if (_interItemSpacingY == interItemSpacingY) return;
    
    _interItemSpacingY = interItemSpacingY;
    
    [self invalidateLayout];
}

- (void)setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (_numberOfColumns == numberOfColumns) return;
    
    _numberOfColumns = numberOfColumns;
    
    [self invalidateLayout];
}



@end
