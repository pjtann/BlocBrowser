//
//  ViewController.h
//  BlocBrowser
//
//  Created by PT on 12/3/15.
//  Copyright (c) 2015 PeterTanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// replaces the web view with a fresh one, erasing all history
// also updates the URL field and toolbar buttons approrpriately
-(void) resetWebView;



@end

