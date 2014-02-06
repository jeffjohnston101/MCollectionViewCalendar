//
//  MDayViewCell.m
//  MCollectionViewCalendarTest
//
//  Created by Jeffrey Johnston on 10/9/13.
//  Copyright (c) 2013 Ill Corporation. All rights reserved.
//

#import "MDayViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MDayViewCell ()

@end

@implementation MDayViewCell

@synthesize halfHourImageView = _halfHourImageView,
sectionLabel, cellPanGestureRecognizer, cellSection;  //, cellLongPressGestureRecognizer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        //self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //self.layer.borderWidth = 1.0f;
        
        _halfHourImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _halfHourImageView.contentMode = UIViewContentModeScaleAspectFill;
        _halfHourImageView.clipsToBounds = YES;
        [self.contentView addSubview:_halfHourImageView];
        
        sectionLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        sectionLabel.textAlignment = NSTextAlignmentCenter;
        sectionLabel.textColor = [UIColor whiteColor];
        sectionLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [self.sectionLabel setHidden:YES];
        [self.contentView addSubview:sectionLabel];
        
        cellPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        cellPanGestureRecognizer.minimumNumberOfTouches = 1;
        cellPanGestureRecognizer.delegate = self;
        //[self addGestureRecognizer:cellPanGestureRecognizer];
        
        /*
        cellLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
        cellLongPressGestureRecognizer.delegate = self;
        cellLongPressGestureRecognizer.allowableMovement = 5.0f;
        cellLongPressGestureRecognizer.minimumPressDuration = 1.0;
        [self addGestureRecognizer:cellLongPressGestureRecognizer];
        */

    }
    return self;
}


-(void) handlePanGesture:(UIPanGestureRecognizer *)gesture {
    NSLog (@"PAN gesture recognized");
     _halfHourImageView.image = [UIImage imageNamed:@"circle_grey"];
    CGPoint location = [gesture locationInView:self];
    NSLog(@"location:  %@", NSStringFromCGPoint(location));
    
}

/*
-(void) handleLongPressGesture:(UILongPressGestureRecognizer *) gesture {
    NSLog(@"LONG PRESS gesture recognizer");
    _halfHourImageView.image = [UIImage imageNamed:@"circle_grey"];
}
*/

#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.cellPanGestureRecognizer touchesBegan:touches withEvent:event];
    //[self.cellLongPressGestureRecognizer touchesBegan:touches withEvent:event];
    NSLog (@"touhesBegan:   %@", touches);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self.cellPanGestureRecognizer touchesMoved:touches withEvent:event];
    //[self.cellLongPressGestureRecognizer touchesMoved:touches withEvent:event];
    //NSLog (@"touhesMoved:   %@", touches);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.cellPanGestureRecognizer touchesEnded:touches withEvent:event];
    //[self.cellLongPressGestureRecognizer touchesEnded:touches withEvent:event];
    NSLog (@"touhesEnded:   %@", touches);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self.cellPanGestureRecognizer touchesCancelled:touches withEvent:event];
    //[self.cellLongPressGestureRecognizer touchesCancelled:touches withEvent:event];
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



- (void)prepareForReuse
{
    [super prepareForReuse];
    self.halfHourImageView.image = nil;
    self.halfHourImageView.frame = self.contentView.bounds;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
