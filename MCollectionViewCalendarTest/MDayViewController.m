//
//  MDayViewController.m
//  MCollectionViewCalendarTest
//
//  Created by Jeffrey Johnston on 10/10/13.
//  Copyright (c) 2013 Ill Corporation. All rights reserved.
//

#import "MDayViewController.h"
#import "MDayCollectionViewLayout.h"
#import "MDayViewCell.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <QuartzCore/QuartzCore.h>

@interface MDayViewController ()

@property (weak, nonatomic) IBOutlet MDayCollectionViewLayout *dayViewLayout;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *sideScrollView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *sideLabel;
@property (strong, nonatomic) NSMutableArray *selectedDayCells;
@property (strong, nonatomic) UIView *selectedRectView;


@property (nonatomic) CGPoint _dragStartedAtPoint;
@property (nonatomic) CGRect _dragRect;



@end

@implementation MDayViewController

@synthesize topScrollView = _topScrollView, sideScrollView = _sideScrollView, topLabel = _topLabel, sideLabel = _sideLabel,
cellLongPressGestureRecognizer, _dragRect, _dragStartedAtPoint, selectedDayCells = _selectedDayCells, menuModalView, cancelButton, selectedRectView;

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
	// Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[MDayViewCell class] forCellWithReuseIdentifier:@"DayCell"];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.directionalLockEnabled = YES;
    
    _topScrollView.delegate = self;
    _sideScrollView.delegate = self;
    
    _selectedDayCells = [[NSMutableArray alloc] init];
    
    //[menuModalView setFrame:CGRectMake(0, 569, menuModalView.frame.size.width, menuModalView.frame.size.height)];

/*
    cellPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    cellPanGestureRecognizer.minimumNumberOfTouches = 1;
    cellPanGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:cellPanGestureRecognizer];
*/
    
    cellLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
    cellLongPressGestureRecognizer.delegate = self;
    cellLongPressGestureRecognizer.allowableMovement = 5.0f;
    cellLongPressGestureRecognizer.minimumPressDuration = 1.0;
    [self.collectionView addGestureRecognizer:cellLongPressGestureRecognizer];
    
    NSInteger offSet = 60;
    for (int i = 1; i <= 48; i++)
    {
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sideLabel.frame.origin.x, _sideLabel.frame.origin.y + offSet, _sideLabel.frame.size.width, _sideLabel.frame.size.height)];
        numberLabel.text = [NSString stringWithFormat:@"%d", i + 1];
        numberLabel.textColor = [UIColor whiteColor];
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        numberLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [_sideScrollView addSubview:numberLabel];
        offSet = offSet + 60;
    }
    
    NSInteger newOffSet = 54;
    NSArray *words = @[@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J"];
    for (int i = 0; i < words.count; i++)
    {
        UILabel *letterLabel = [[UILabel alloc] initWithFrame:CGRectMake(_topLabel.frame.origin.x + newOffSet, _topLabel.frame.origin.y, _topLabel.frame.size.width, _topLabel.frame.size.height)];
        letterLabel.text = [words objectAtIndex:i];
        letterLabel.textColor = [UIColor whiteColor];
        [letterLabel setTextAlignment:NSTextAlignmentCenter];
        letterLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [_topScrollView addSubview:letterLabel];
        newOffSet = newOffSet + 54;
    }
    
}

- (void) viewDidLayoutSubviews {
    CGSize topScrollViewContentSize = CGSizeMake( _topScrollView.frame.size.width * 10, _topScrollView.frame.size.height);
    CGSize sideScrollViewContentSize = CGSizeMake( _sideScrollView.frame.size.width, _sideScrollView.frame.size.height * 10);
    [_topScrollView setContentSize:topScrollViewContentSize];
    [_sideScrollView setContentSize:sideScrollViewContentSize];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint mainOffset = [self.collectionView contentOffset];
    [_topScrollView setContentOffset:CGPointMake(mainOffset.x, 0)];
    [_sideScrollView setContentOffset:CGPointMake(0, mainOffset.y)];
}

/*
-(void) handlePanGesture:(UIPanGestureRecognizer *)gesture {
    NSLog (@"PAN gesture recognized");
    //_halfHourImageView.image = [UIImage imageNamed:@"circle_grey"];
    CGPoint location = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:(location)];
    MDayViewCell *currentCell = (MDayViewCell *)[self.collectionView cellForItemAtIndexPath:(indexPath)];
    NSLog(@"currentCell:   %@", currentCell);
    NSLog(@"location:  %@", NSStringFromCGPoint(location));
    
}
*/
-(void) handleLongPressGesture:(UILongPressGestureRecognizer *) gesture {

    //get location of touch and the cell index in collection view
    CGPoint location = [gesture locationInView:self.collectionView];
    NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:location];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
                [self setModalState];
                [_selectedDayCells removeAllObjects];
                NSLog(@"Began location value: %@", NSStringFromCGPoint(location));
                _dragStartedAtPoint = location;
                MDayViewCell *cell = (MDayViewCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexPath];
                cell.halfHourImageView.image = [UIImage imageNamed:@"circle_grey"];
                cell.sectionLabel.text = [NSString stringWithFormat:@"%d", selectedIndexPath.section];
                [cell.sectionLabel setHidden:NO];
            break;
        }
        case UIGestureRecognizerStateEnded: {
                 self.collectionView.scrollEnabled = YES;
                 NSLog(@"Final bounds for _dragRect:     %@", NSStringFromCGRect(_dragRect));
                 for (MDayViewCell *cell in [[self collectionView] visibleCells])
                 {
                     if (CGRectIntersectsRect(_dragRect, cell.frame) || CGRectContainsRect(_dragRect, cell.frame)) {
                        cell.halfHourImageView.image = [UIImage imageNamed:@"circle_blue"];
                        cell.sectionLabel.text = [NSString stringWithFormat:@"%d", cell.cellSection];
                        [cell.sectionLabel setHidden:NO];
                        [_selectedDayCells addObject:cell];
                     }
                 }
            NSArray *sortecCells = [self sortArrayBySection:_selectedDayCells];
            [self addShapeToView: sortecCells];
            [_selectedDayCells removeAllObjects];
            break;
        }
        case UIGestureRecognizerStateCancelled:
                 self.collectionView.scrollEnabled = YES;
            break;
        case UIGestureRecognizerStateChanged: {
            
                CGPoint touchPoint = location;
                CGPoint startPoint = (CGPoint){MIN(touchPoint.x, _dragStartedAtPoint.x), MIN(touchPoint.y, _dragStartedAtPoint.y)};
                CGSize  dragSize   = (CGSize) {MAX(touchPoint.x, _dragStartedAtPoint.x) - startPoint.x, MAX(touchPoint.y, _dragStartedAtPoint.y) - startPoint.y};
        
                _dragRect = (CGRect){startPoint, dragSize};
            
                for (MDayViewCell *cell in [[self collectionView] visibleCells])
                {
                    if (CGRectIntersectsRect(_dragRect, cell.frame) || CGRectContainsRect(_dragRect, cell.frame)) {
                            cell.halfHourImageView.image = [UIImage imageNamed:@"circle_grey"];
                            cell.sectionLabel.text = [NSString stringWithFormat:@"%d", cell.cellSection];
                            [cell.sectionLabel setHidden:NO];
                        } else {
                            cell.halfHourImageView.image = [UIImage imageNamed:@"circle_schedule"];
                            [cell.sectionLabel setHidden:YES];
                        }
                }
            break;
        }
        default:
            break;
    }
}

-(void) addShapeToView: (NSArray *) sorted {
    
    MDayViewCell *endCell = [sorted objectAtIndex:0];
    MDayViewCell *startCell = [sorted lastObject];

    selectedRectView = [[UIView alloc] initWithFrame:CGRectMake(startCell.frame.origin.x,
                                                                startCell.frame.origin.y,
                                                                (endCell.frame.origin.x + 50) - startCell.frame.origin.x ,
                                                                (endCell.frame.origin.y + 50) - startCell.frame.origin.y)];
    [selectedRectView.layer setMasksToBounds:YES];
    [selectedRectView.layer setCornerRadius:25.0];
    selectedRectView.backgroundColor = [UIColor  lightGrayColor];
    selectedRectView.alpha = 0.9;
    //selectedRectView.layer.borderColor = [UIColor blueColor].CGColor;
    //selectedRectView.layer.borderWidth = 1.0f;
    [self.collectionView addSubview:selectedRectView];
}



- (NSArray *) sortArrayBySection: (NSMutableArray *) array {
    NSArray *sorted = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        if ([obj1 isKindOfClass:[MDayViewCell class]] && [obj2 isKindOfClass:[MDayViewCell class]]) {
            MDayViewCell *s1 = obj1;
            MDayViewCell *s2 = obj2;
            
            if (s1.cellSection > s2.cellSection) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if (s1.cellSection < s2.cellSection) {
                return (NSComparisonResult)NSOrderedDescending;
            }
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSLog(@"Descending array sorted by section:     %@", sorted);
    return sorted;
}



-(void) setModalState
{
    self.collectionView.scrollEnabled = NO;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [menuModalView setFrame:CGRectMake(0, 468, menuModalView.frame.size.width, menuModalView.frame.size.height)];
                         [_topScrollView setAlpha: 0.75f];
                         [_sideScrollView setAlpha: 0.75f];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


- (IBAction)cancelButtonPressed:(id)sender {
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [menuModalView setFrame:CGRectMake(0, 568, menuModalView.frame.size.width, menuModalView.frame.size.height)];
                         [_topScrollView setAlpha: 1.0f];
                         [_sideScrollView setAlpha: 1.0f];
                     }
                     completion:^(BOOL finished) {
                         [selectedRectView removeFromSuperview];
                         self.collectionView.scrollEnabled = YES;
                     }];
}


#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //[self.cellPanGestureRecognizer touchesBegan:touches withEvent:event];
    [self.cellLongPressGestureRecognizer touchesBegan:touches withEvent:event];
    NSLog (@"touhesBegan:   %@", touches);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    //[self.cellPanGestureRecognizer touchesMoved:touches withEvent:event];
    [self.cellLongPressGestureRecognizer touchesMoved:touches withEvent:event];
    //NSLog (@"touhesMoved:   %@", touches);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    //[self.cellPanGestureRecognizer touchesEnded:touches withEvent:event];
    [self.cellLongPressGestureRecognizer touchesEnded:touches withEvent:event];
    NSLog (@"touhesEnded:   %@", touches);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    //[self.cellPanGestureRecognizer touchesCancelled:touches withEvent:event];
    [self.cellLongPressGestureRecognizer touchesCancelled:touches withEvent:event];
}

#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 480;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDayViewCell *dayCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
    dayCell.cellSection = indexPath.section;
    
    if (dayCell.selected) {
        dayCell.halfHourImageView.image = [UIImage imageNamed:@"circle_blue"];
        dayCell.sectionLabel.text = [NSString stringWithFormat:@"%d", indexPath.section];
        [dayCell.sectionLabel setHidden:NO];
    }
    else {
        dayCell.halfHourImageView.image = [UIImage imageNamed:@"circle_schedule"];
        [dayCell.sectionLabel setHidden:YES];
    }
    
    //[collectionView.panGestureRecognizer requireGestureRecognizerToFail:dayCell.cellPanGestureRecognizer];
    
    return dayCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MDayViewCell *cell = (MDayViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.halfHourImageView.image = [UIImage imageNamed:@"circle_blue"];
    cell.sectionLabel.text = [NSString stringWithFormat:@"%d", indexPath.section];
    [cell.sectionLabel setHidden:NO];

    //diagnostics - Grabbing current frame for selected cell
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellRect = attributes.frame;
    NSLog (@"Section and Item for selected cell:      Section = %d, Item = %d", indexPath.section, indexPath.item);
    NSLog (@"Selected Cell's FrameX and FrameY:        FrameX: %f, FrameY: %f", cellRect.origin.x, cellRect.origin.y);
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    MDayViewCell *cell =(MDayViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.halfHourImageView.image = [UIImage imageNamed:@"circle_schedule"];
    [cell.sectionLabel setHidden:YES];
}


#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.dayViewLayout.numberOfColumns = 10;
        self.dayViewLayout.itemInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    } else {
        self.dayViewLayout.numberOfColumns = 5;
        self.dayViewLayout.itemInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
