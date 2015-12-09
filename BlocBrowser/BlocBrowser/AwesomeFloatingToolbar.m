//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by PT on 12/6/15.
//  Copyright (c) 2015 PeterTanner. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar()

// properties to store the labels,colors, and titles and currentLabel to keep track of which label the user is currently touching/using
@property (nonatomic, strong) NSArray *currrentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;

@end


@implementation AwesomeFloatingToolbar

-(instancetype) initWithFourTitles:(NSArray *)titles{

// first call the superclass (UIView)' initializer to make sure we do that setup first
    self = [super init];
    
    if (self) {
        self.currrentTitles = titles;
        // the alpha property of UIColor represents opacity from 0 to 1 (0=transparent, 1=opaque)
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:225255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        // Make the four labels
        for (NSString *currentTitle in self.currrentTitles){
            UILabel *label = [[UILabel alloc]init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currrentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisLabel = [self.currrentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            
            label.textAlignment = NSTextAlignmentCenter; //horizontal text alignment
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorForThisLabel;
            label.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:label];
            NSLog(@"label value in currentTitle loop line 60..: %@", label.text);
    
        }
        
        self.labels = labelsArray;
        
        for (UILabel *thisLabel in self.labels) {
            [self addSubview:thisLabel];
        }
    }

    return self;
    
}

// this method will get called anytime a views frame is changed
-(void) layoutSubviews{
    
    // set the frames for the four labels; this loop goes left to right, then top to bottom
    
    for (UILabel *thisLabel in self.labels) {
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        // adjust labelX and labelY for each label
        if (currentLabelIndex < 2) {
            // 0 or 1, so on top
            labelY = 0;
            
        }else {
            // 2 or 3, so on bottom
            labelY = CGRectGetHeight(self.bounds) / 2;
            
        }
        
        if (currentLabelIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
            // 0 or 2, so on the left
            labelX = 0;
        }else{
            // 1 or 3, so on teh right
            labelX = CGRectGetWidth(self.bounds) / 2;
            
        }
        
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}


#pragma mark - Touch Handling
// this method takes a touch from the touch set, determines the touch's coordinates on the screen, finds the UIView at that location (hitTest:withEvent: only finds views with userInteractionEnabled == YES; we'll enable some buttons later), returns the label to whoever requested it

-(UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *) event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    
    if ([subview isKindOfClass:[UILabel class]]) {
        return (UILabel *) subview; // this is "casting" telling the compiler that we know that our return is a label
    }else{
        return nil;
    }
}

// When a touch begins, we'll dim the label to make it look highlighted. We'll also keep track of which label was most recently touched
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UILabel *label = [self labelFromTouches:touches withEvent:event];
    
    self.currentLabel = label;
    self.currentLabel.alpha = 0.5;
    
}

// When a touch moves, we'll check if the user is still touching the same label. If the user drags off the label, we'll reset the alpha. If they drag back on, we'll dim it again
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UILabel *label = [self labelFromTouches:touches withEvent:event];
    
    if (self.currentLabel != label) {
        // the label being touched is no longer the initial label
        self.currentLabel.alpha = 1;
    }else{
        // the label being touched is the initial label
        self.currentLabel.alpha = 0.5;
        
    }
}

// If the user lifts their finger, the touch is ended. In this case, check if their finger was lifted from the same label they started with. If so, print a log to the console and inform the delegate. Either way, reset the variables we're tracking to their initial values
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UILabel *label = [self labelFromTouches:touches withEvent:event];
    
    if (self.currentLabel == label) {
        NSLog(@"Label tapped: %@", self.currentLabel.text);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
            [self.delegate floatingToolbar:self didSelectButtonWithTitle:self.currentLabel.text];
            
        }
    }
    
    self.currentLabel.alpha = 1;
    self.currentLabel = nil;
    
}

// If the touch is cancelled, reset the same variables we did in touchesMoved:…:

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.currentLabel.alpha = 1;
    self.currentLabel = nil;
    
}

#pragma mark - Button Enabling

// handling the button enabling
-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title{
    NSUInteger index = [self.currrentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
