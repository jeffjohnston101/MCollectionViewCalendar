//
//  MDayCollectionViewController.m
//  MCollectionViewCalendarTest
//
//  Created by Jeffrey Johnston on 10/9/13.
//  Copyright (c) 2013 Ill Corporation. All rights reserved.
//

#import "MDayCollectionViewController.h"
#import "MDayCollectionViewLayout.h"
#import "MDayViewCell.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@interface MDayCollectionViewController ()

@property (weak, nonatomic) IBOutlet MDayCollectionViewLayout *dayViewLayout;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation MDayCollectionViewController

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
    
	//self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView registerClass:[MDayViewCell class] forCellWithReuseIdentifier:@"DayCell"];
    self.collectionView.allowsMultipleSelection = YES;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    _tapGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_tapGestureRecognizer];
    //[self.view addGestureRecognizer:_panGestureRecognizer];
    

}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 480;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDayViewCell *dayCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
    
        if (dayCell.selected) {
            dayCell.halfHourImageView.image = [UIImage imageNamed:@"circle_blue"];
        }
        else {
            dayCell.halfHourImageView.image = [UIImage imageNamed:@"circle_schedule"];
        }

    return dayCell;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MDayViewCell *cell =(MDayViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.halfHourImageView.image = [UIImage imageNamed:@"circle_schedule"];
   
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     NSLog (@"Section and IndexPath for selected cell:      Section = %d, Item = %d", indexPath.section, indexPath.item);
}


#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.tapGestureRecognizer touchesBegan:touches withEvent:event];
    NSLog (@"touhesBegan:   %@", touches);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    [self.tapGestureRecognizer touchesMoved:touches withEvent:event];
    NSLog (@"touhesMoved:   %@", touches);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self.tapGestureRecognizer touchesEnded:touches withEvent:event];
    NSLog (@"touhesEnded:   %@", touches);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self.tapGestureRecognizer touchesCancelled:touches withEvent:event];
    NSLog (@"touhesCanceled:   %@", touches);
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


-(void) handleGesture:(UITapGestureRecognizer *)gesture {
     NSLog (@"Tap recognized");
}


#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.dayViewLayout.numberOfColumns = 10;
        //CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ? 45.0f : 25.0f;
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
