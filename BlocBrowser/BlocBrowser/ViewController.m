//
//  ViewController.m
//  BlocBrowser
//
//  Created by PT on 12/3/15.
//  Copyright (c) 2015 PeterTanner. All rights reserved.
//
// The pragma marks are a special comment that create a break in the code that creates
// a table of contents type look in the class navigator line at top of this coding window.
// It uses that comment as a header for a section, bolds it, and places lines above and
// below that section in the class navigator
//

#import "ViewController.h"
#import <WebKit/WebKit.h> // needed for the WKWebView property
#import "AwesomeFloatingToolbar.h"

// these definitions automatically replace the KWebBrowser...String with the NSLocalized.... anywhere we use them
#define KWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define KWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define KWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define KWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")

@interface ViewController () <WKNavigationDelegate, UITextFieldDelegate, AwesomeFloatingToolbarDelegate> // The navigation delegate declares that the controller conforms to WKNavigationDelegate protocol so we can WKWebView as a subview to mainView below in the loadView method.The UITextFieldDelegate does teh same for the texfield and the AwesomeFlo... does the same too.


// adding WkWebView as a private property - a UIView subclass designed to display web content
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UITextField *textField; // text field for the URL entry


// replaces the individual properties for the buttons now they will reside on the toolbar.
@property (nonatomic, strong) AwesomeFloatingToolbar *awesomeToolbar;


// property for the activity indicator
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, assign) NSUInteger frameCount;


@end

@implementation ViewController

#pragma mark - UIViewController

// this is the main container view in which to place all the subviews; created by overriding the
// loadview method
-(void) loadView {
    UIView *mainView = [UIView new];
    
    // add WKWebView as a subview to mainView
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;

    // build a text field and add it as subview of the main vew
    self.textField = [[UITextField alloc] init];
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.placeholder = NSLocalizedString(@"Website URL", @"Placeholder text for web browser URL field.");
    self.textField.backgroundColor = [UIColor colorWithWhite:220/225.0f alpha:1];
    self.textField.delegate = self;
    

    
    // reference to the new toolbar
    self.awesomeToolbar =[[AwesomeFloatingToolbar alloc] initWithFourTitles:@[KWebBrowserBackString, KWebBrowserForwardString, KWebBrowserStopString, KWebBrowserRefreshString]];
    NSLog(@"init of the toolbar line 88..: %@", KWebBrowserBackString);
    self.awesomeToolbar.delegate = self;
    


    
    // loop to add views needed for browser view, texfield, and buttons to the main view
//    for (UIView *viewToAdd in @[self.webView, self.textField, self.backButton, self.forwardButton
//                                , self.stopButton, self.reloadButton]) {
        for (UIView *viewToAdd in @[self.webView, self.textField, self.awesomeToolbar]){
        
        [mainView addSubview:viewToAdd];
   
    } // this loop replaces all the individual subview adds

    
    
    
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // keeps scrolling of pages from going under the navigation bar and behind the status bar keeping it visible all the time.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // set the acivity indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
    // test the indicator by unremarking the below line
    //[self.activityIndicator startAnimating];
    
    
    
}

// gives the web view a size; in this case the full size of the main view
// we do this in a seperate method after the initial loads because before this the main
// view is not guaranteed to have adjusted to any rotation or resizing events

-(void) viewDidLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    //self.webView.frame = self.view.frame;
    
    // first calculate some dimensions
    // sets the height of the URL bar into a variable
    static const CGFloat itemHeight = 50;
    // sets width to same as view width
    CGFloat width = CGRectGetWidth(self.view.bounds);

    
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
    
    
    
    
    // now assign the frames
    self.textField.frame = CGRectMake(0, 0, width, itemHeight); // set textfield frame starting at 0,0 on view and then uses width and height created previously
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight); // sets the browser frames

    self.awesomeToolbar.frame = CGRectMake(20, 100, 280, 60);
    
    
}

#pragma mark - UITextFieldDelegate


// method to handle changes to the URL field = accept a URL
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    NSString *URLString = textField.text;
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    // if the URL doesn't have a scheme entered with it we will assume the user meant http:// and add it in for them
    if (!URL.scheme){
        // the user didn't type http: or https:
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", URLString]];
        
    }
    
    if (URL){
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:request];
        
    }
    return NO;
    
}

#pragma mark - WKNavigationDelegate

-(void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self updateButtonsAndTitle];
    
}

-(void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self updateButtonsAndTitle];
    
}


// if web pages fail to load, capture the error
-(void) webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self webView:webView didFailNavigation:navigation withError:error];
    
}
// after web pages fail to load display the error to the user
-(void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if (error.code != NSURLErrorCancelled){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    [self updateButtonsAndTitle];
    
    
}

#pragma mark - Miscellaneous

// method to update the title when the webpage changes and make buttons accessile or not when they can be available to function
-(void) updateButtonsAndTitle {
    NSString *webpageTitle = [self.webView.title copy];
    if ([webpageTitle length]) {
        self.title = webpageTitle;
    }else{
        self.title = self.webView.URL.absoluteString;
        
    }
    // determine if a page is loading and run the indicator if it is
    if (self.webView.isLoading) {
        // start the indicator
        [self.activityIndicator startAnimating];
    } else{
        // stop the indicator
        [self.activityIndicator stopAnimating];
    }
    
//    // enable buttons if they can be used
//    self.backButton.enabled = [self.webView canGoBack];
//    self.forwardButton.enabled = [self.webView canGoForward];
//    self.stopButton.enabled = self.webView.isLoading;
//    
//    // for reload we need to ensure that the web view has an NSURLRequest with accompanying NSURL, otherwise there will be nothing to load
//    self.reloadButton.enabled = !self.webView.isLoading && self.webView.URL;
   
    [self.awesomeToolbar setEnabled:[self.webView canGoBack] forButtonWithTitle:KWebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webView canGoForward] forButtonWithTitle:KWebBrowserForwardString];
    [self.awesomeToolbar setEnabled:[self.webView isLoading] forButtonWithTitle:KWebBrowserStopString];
    [self.awesomeToolbar setEnabled:[self.webView isLoading] && self.webView.URL forButtonWithTitle:KWebBrowserRefreshString];
    
}

-(void) resetWebView {
    // removes old web view from the view hierarchy
    [self.webView removeFromSuperview];
    
    // creates a new empty web view and adds it back in
    WKWebView *newWebView = [[WKWebView alloc]init];
    newWebView.navigationDelegate = self;
    [self.view addSubview:newWebView];
    
    // clears teh URL field
    self.webView = newWebView;
    
//    // calls addButtonTargets method to point the buttons to the new web view
//    [self addButtonTargets];
    
    // updates the buttons and navigation title to heir proper state
    self.textField.text = nil;
    [self updateButtonsAndTitle];
    
}


#pragma mark - AwesomeFloatingToolbarDelegate

-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title {
    
    NSLog(@"In didSelectButtonWithTitle..%@", title);
    
    if ([title isEqual:NSLocalizedString(@"Back", @"Back command")]) {
        [self.webView goBack];
    } else if ([title isEqual:NSLocalizedString(@"Forward", @"Forward command")]) {
        [self.webView goForward];
    } else if ([title isEqual:NSLocalizedString(@"Stop", @"Stop command")]) {
        [self.webView stopLoading];
    } else if ([title isEqual:NSLocalizedString(@"Refresh", @"Reload command")]) {
        [self.webView reload];
    }
}

-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset{
    CGPoint startingPoint = toolbar.frame.origin; // get top-left corner point of where toolbar is located
    CGPoint newPoint = CGPointMake(startingPoint.x + offset.x, startingPoint.y + offset.y); // the new/future top-left corner calculated by adding the difference in x and the difference in y to the original top-left coordinate
    
    CGRect potentialNewFrame = CGRectMake(newPoint.x, newPoint.y, CGRectGetWidth(toolbar.frame), CGRectGetHeight(toolbar.frame)); // create a new CGRect that represents the toolbars potential new frame
    
    if (CGRectContainsRect(self.view.bounds, potentialNewFrame)) { // will return true/YES if the potentialNewFrame's (rect2) proposed bounds are contained completely within self.view.bounds (rect1) or NO if it is not which means it's trying to be placed outside the view
        toolbar.frame = potentialNewFrame;
        
    }
}



@end
