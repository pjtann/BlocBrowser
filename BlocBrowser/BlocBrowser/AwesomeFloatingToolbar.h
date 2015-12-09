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


@end // end of the protocol definition

// begin the defnition of the toolbar itself
@interface AwesomeFloatingToolbar : UIView

// indicates this class must be initialized with four titles using this intializer; takes an array of 4 titles as an argument
-(instancetype) initWithFourTitles:(NSArray *) titles;

// allows other classes to call this method to enable and disable the buttons
-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;













@end
