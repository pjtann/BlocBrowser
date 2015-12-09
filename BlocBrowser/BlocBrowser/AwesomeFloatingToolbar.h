//
//  AwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by PT on 12/6/15.
//  Copyright (c) 2015 PeterTanner. All rights reserved.
//

#import <UIKit/UIKit.h>

// declaring the class here before the @interface promises to the compiler that we will define what the class is later down below the @interface section
@class AwesomeFloatingToolbar;

// this begins the definition of the protocol; implementing this protocol allows for classes being informed when one of the titles is pressed
@protocol AwesomeFloatingToolbarDelegate <NSObject>

// this makes what follows optional methods to implement
@optional

-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;

// a delegate method to indicate that the toolbar wishes to be moved around due to the panGesture and the direction it wishes to move and then the view controller can decide whether or not to actually move the toolbar or not. This is done through a delegate rather than allowing the toolbar to move itself around in the superview because the toolbar doesn't know about all the other objects and the superview. Changes made by an object should only affect themelves and objects they own as per best practices; this way the object in this case the toolbar will not collide with other objects it doesn't know anthign about or control
-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;


@end // end of the protocol definition

// begin the defnition of the toolbar itself
@interface AwesomeFloatingToolbar : UIView

// indicates this class must be initialized with four titles using this intializer; takes an array of 4 titles as an argument
-(instancetype) initWithFourTitles:(NSArray *) titles;

// allows other classes to call this method to enable and disable the buttons
-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;












@end
