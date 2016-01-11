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

// for replacement of labels with buttons
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, weak) UIButton *currentButton;


//// property to store the tap recognizer
//@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
// propert to store the panning recognizer
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
// property to store the pinch recognizer
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
// property to store long press recognizer
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;


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

        
        // &&&&&&&&&&&&& start of labels
        
//        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
//        
//        // Make the four labels
//        for (NSString *currentTitle in self.currrentTitles){
//            UILabel *label = [[UILabel alloc]init];
//            label.userInteractionEnabled = NO;
//            label.alpha = 0.25;
//            
//            NSUInteger currentTitleIndex = [self.currrentTitles indexOfObject:currentTitle]; // 0 through 3 in the array
//            NSLog(@"currentTitleIndexline 60...: %lu", currentTitleIndex);
//            
//            NSString *titleForThisLabel = [self.currrentTitles objectAtIndex:currentTitleIndex];
//            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
//            
//            
//            label.textAlignment = NSTextAlignmentCenter; //horizontal text alignment
//            label.font = [UIFont systemFontOfSize:10];
//            label.text = titleForThisLabel;
//            label.backgroundColor = colorForThisLabel;
//            label.textColor = [UIColor whiteColor];
//            
//            [labelsArray addObject:label];
//            NSLog(@"label value in currentTitle loop line 60..: %@", label.text);
//    
//        }
//        
//        self.labels = labelsArray;
//        
//        for (UILabel *thisLabel in self.labels) {
//            [self addSubview:thisLabel];
//        }
        
        
        // &&&&&&&&&&&&& end of labels
        
        
        
        
        
        
        // ********** start buttons instead of labels
        
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        
        // Make the four buttons
        for (NSString *currentTitle in self.currrentTitles){
            UIButton *button = [[UIButton alloc]init];
            button.userInteractionEnabled = NO;
            button.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currrentTitles indexOfObject:currentTitle]; // 0 through 3 in the array
            NSLog(@"currentTitleIndexline 60...: %lu", currentTitleIndex);
            
            NSString *titleForThisButton = [self.currrentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisButton = [self.colors objectAtIndex:currentTitleIndex];
            
            
            //button.textAlignment = NSTextAlignmentCenter; //horizontal text alignment
            //button.font = [UIFont systemFontOfSize:10];
            //button.text = titleForThisButton;
            [button setTitle:titleForThisButton forState:UIControlStateNormal];

            button.backgroundColor = colorForThisButton;
            //button.textColor = [UIColor whiteColor];
            
            [buttonsArray addObject:button];
            NSLog(@"button value in currentTitle loop line 60..: %@", button);
            NSLog(@"title for button ...: %@", titleForThisButton);
            
            
        }
        
        self.buttons = buttonsArray;
        
        for (UIButton *thisButton in self.buttons) {
            [self addSubview:thisButton];
        }
        
        
        // ************* end buttons instead labels
        
        
        
        
        
        
        
        

        
//        // tells the gesture recognizer which method to call when a tap is detected by using the tapFired
//        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
//        // tells the view (self) to route the touch events through this gesture recognizer
//        [self addGestureRecognizer:self.tapGesture];
        
        // initialize pan gesture
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        // initialize pinch gesture
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        
        // initialize long press gesture
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPressGesture];
      
        
    }

    return self;
    
}

//-(void) tapFired:(UITapGestureRecognizer *) recognizer{
//    if (recognizer.state == UIGestureRecognizerStateRecognized) { // check for the proper state; a tap was recognized
//        CGPoint location = [recognizer locationInView:self]; // calculates and stores x-y coordinates of the gestures location (with respect to self's bounds
//        UIView *tappedView = [self hitTest:location withEvent:nil]; // invoke hitTest to determine which view (button as a view in our case) recieved the tap
//        
//        if ([self.labels containsObject:tappedView]) { // check if the view that was tapped was one of our toolbar labels, and if so verify our delegate for compatibility before performing the appropriate method call
//            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
//                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
//                
//            }
//        }
//        
//        
//    }
//}

-(IBAction) buttonFired:recognizer{
    
    NSLog(@"recognizer value line 190..: %@", recognizer);
    
    //if (recognizer.state == UIGestureRecognizerStateRecognized) { // check for the proper state; a tap was recognized
        CGPoint location = [recognizer locationInView:self]; // calculates and stores x-y coordinates of the gestures location (with respect to self's bounds
        UIView *tappedView = [self hitTest:location withEvent:nil]; // invoke hitTest to determine which view (button as a view in our case) recieved the tap

        if ([self.buttons containsObject:tappedView]) { // check if the view that was tapped was one of our toolbar labels, and if so verify our delegate for compatibility before performing the appropriate method call
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];

            }
        }


    //}
}


// this method will be invoked when a pan gesture has been detected. We're not looking for where the gesture occured as with the selecting of one of the toolbar buttons/views, but instead which direction the toolbar is traveling in. The Translation is how far the users fingers have moved in each direction since the touch event began. This is called many times during a pan gesture because it's really just a linear action of small pans traveling a few pixels at at time.
-(void) panFired:(UIPanGestureRecognizer *) recognizer{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
            
        }
        
        [recognizer setTranslation:CGPointZero inView:self]; // reseting the translation to zero so it can get the difference of each tiny little pan each time the method is called. As described above a pan is really many tiny linear pans moving a few pixels at a time.
        
    }
}


// method for pinch gesture to allow for resizing of the toolbar
-(void) pinchFired:(UIPinchGestureRecognizer *) recognizer{
    
    CGFloat previousScale = 0.0;
    CGPoint lastPoint;
    CGFloat newScale;
    
    if(recognizer.state == (UIGestureRecognizerStateBegan)){
        previousScale = 1.0;
        CGPoint lastPoint = [recognizer locationInView:self];
        
        NSLog(@"New Pinch to Resize Toolbar: %@", NSStringFromCGPoint(lastPoint));
        
    }
    
    if (recognizer.state == (UIGestureRecognizerStateChanged)) {
        CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        const CGFloat kMaxScale = 4.0;
        const CGFloat kMinScale = 1.0;
        
        newScale = 1 - (previousScale - [recognizer scale]); // new scale is in the range 0-1
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        recognizer.scale = newScale;
        
        CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
        
        [recognizer view].transform = transform;
        
        CGPoint point = [recognizer locationInView:[recognizer view]];
        CGAffineTransform transformTranslate = CGAffineTransformTranslate([[recognizer view] transform], point.x-lastPoint.x, point.y-lastPoint.y);
        
        [recognizer view].transform = transformTranslate;
        
        
    }
    
    
}

-(void) longPressFired:(UILongPressGestureRecognizer *) recognizer{
    
    NSUInteger newColorIndex = 0;

    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
     
        for (UILabel *myLabel in self.labels) {
            //NSUInteger currentTitleIndex = [self.currrentTitles indexOfObject:myLabel];
            UIColor *myColor = myLabel.backgroundColor;
            NSUInteger colorIndex = [self.colors indexOfObject:myColor];
            
            //NSUInteger colorIndex = [self.labels indexOfObject:myLabel];
            NSLog(@"colorIndex current value..: %lu", colorIndex);

            
            if (colorIndex == 0) {
                newColorIndex = colorIndex;
                newColorIndex++;
                UIColor *colorForThisLabel = [self.colors objectAtIndex:newColorIndex];
                NSLog(@"colorIndex current value..: %lu", colorIndex);
                NSLog(@"newColorIndex current value..: %lu", newColorIndex);
                myLabel.backgroundColor = colorForThisLabel;
                
            }
            if (colorIndex == 1) {
                newColorIndex = colorIndex;
                newColorIndex++;
                UIColor *colorForThisLabel = [self.colors objectAtIndex:newColorIndex];
                NSLog(@"colorIndex current value..: %lu", colorIndex);
                NSLog(@"newColorIndex current value..: %lu", newColorIndex);
                myLabel.backgroundColor = colorForThisLabel;
                
            }
            if (colorIndex == 2) {
                newColorIndex = colorIndex;
                newColorIndex++;
                UIColor *colorForThisLabel = [self.colors objectAtIndex:newColorIndex];
                NSLog(@"colorIndex current value..: %lu", colorIndex);
                NSLog(@"newColorIndex current value..: %lu", newColorIndex);
                myLabel.backgroundColor = colorForThisLabel;
                
            }
            if (colorIndex == 3) {
                newColorIndex = colorIndex;
                newColorIndex = 0;
                UIColor *colorForThisLabel = [self.colors objectAtIndex:newColorIndex];
                NSLog(@"colorIndex current value..: %lu", colorIndex);
                NSLog(@"newColorIndex current value..: %lu", newColorIndex);
                myLabel.backgroundColor = colorForThisLabel;
            
            }
            
        }

    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Long press being held down; do color rotating here.");
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"Long press ended.");
        
    }

    
    }
}



//// this method will get called anytime a views frame is changed
//-(void) layoutSubviews{
//    
//    // set the frames for the four labels; this loop goes left to right, then top to bottom
//    
//    for (UILabel *thisLabel in self.labels) {
//        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
//        
//        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
//        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
//        CGFloat labelX = 0;
//        CGFloat labelY = 0;
//        
//        // adjust labelX and labelY for each label
//        if (currentLabelIndex < 2) {
//            // 0 or 1, so on top
//            labelY = 0;
//            
//        }else {
//            // 2 or 3, so on bottom
//            labelY = CGRectGetHeight(self.bounds) / 2;
//            
//        }
//        
//        if (currentLabelIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
//            // 0 or 2, so on the left
//            labelX = 0;
//        }else{
//            // 1 or 3, so on teh right
//            labelX = CGRectGetWidth(self.bounds) / 2;
//            
//        }
//        
//        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
//    }
//}





// this method will get called anytime a views frame is changed - &*&*&&*&&& for buttons
-(void) layoutSubviews{
    
    // set the frames for the four labels; this loop goes left to right, then top to bottom
    
    for (UIButton *thisButton in self.buttons) {
        NSUInteger currentButtonIndex = [self.buttons indexOfObject:thisButton];
        
        CGFloat buttonHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat buttonWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat buttonX = 0;
        CGFloat buttonY = 0;
        
        // adjust labelX and labelY for each label
        if (currentButtonIndex < 2) {
            // 0 or 1, so on top
            buttonY = 0;
            
        }else {
            // 2 or 3, so on bottom
            buttonY = CGRectGetHeight(self.bounds) / 2;
            
        }
        
        if (currentButtonIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
            // 0 or 2, so on the left
            buttonX = 0;
        }else{
            // 1 or 3, so on teh right
            buttonX = CGRectGetWidth(self.bounds) / 2;
            
        }
        
        thisButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    }
}











#pragma mark - Touch Handling
//// this method takes a touch from the touch set, determines the touch's coordinates on the screen, finds the UIView at that location (hitTest:withEvent: only finds views with userInteractionEnabled == YES; we'll enable some buttons later), returns the label to whoever requested it
//
//-(UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *) event {
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
//    UIView *subview = [self hitTest:location withEvent:event];
//    
//    if ([subview isKindOfClass:[UILabel class]]) {
//        return (UILabel *) subview; // this is "casting" telling the compiler that we know that our return is a label
//    }else{
//        return nil;
//    }
//}


// for buttons instead of labels
// this method takes a touch from the touch set, determines the touch's coordinates on the screen, finds the UIView at that location (hitTest:withEvent: only finds views with userInteractionEnabled == YES; we'll enable some buttons later), returns the label to whoever requested it

-(UIButton *) buttonFromTouches:(NSSet *)touches withEvent:(UIEvent *) event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    
    if ([subview isKindOfClass:[UIButton class]]) {
        return (UIButton *) subview; // this is "casting" telling the compiler that we know that our return is a label
    }else{
        return nil;
    }
}






#pragma mark - Button Enabling

//// handling the button enabling
//-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title{
//    NSUInteger index = [self.currrentTitles indexOfObject:title];
//    
//    if (index != NSNotFound) {
//        UILabel *label = [self.labels objectAtIndex:index];
//        label.userInteractionEnabled = enabled;
//        label.alpha = enabled ? 1.0 : 0.25;
//        
//    }
//}

// handling the button enabling - for buttons instead of labels
-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title{
    NSUInteger index = [self.currrentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *button = [self.buttons objectAtIndex:index];
        button.userInteractionEnabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
        
    }
}




@end
