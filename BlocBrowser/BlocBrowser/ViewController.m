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


@interface ViewController () <WKNavigationDelegate, UITextFieldDelegate> // The navigation delegate declares that the controller conforms to WKNavigationDelegate protocol so we can WKWebView as a subview to mainView below in the loadView method.The UITextFieldDelegate does teh same for the texfield.

// adding WkWebView as a private property - a UIView subclass designed to display web content
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UITextField *textField; // text field for the URL entry
// directional buttons for the browser movement
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *reloadButton;

// property for the activity indicator
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


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
    //self.textField.placeholder = NSLocalizedString(@"Website URL", @"Placeholder text for web browser URL field.");
    self.textField.placeholder = NSLocalizedString(@"Website URL or Search String", @"Placeholder text for web browser URL field.");
    
    self.textField.backgroundColor = [UIColor colorWithWhite:220/225.0f alpha:1];
    self.textField.delegate = self;
    
    // establish buttons for browser movement
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.forwardButton setEnabled:NO];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton setEnabled:NO];
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.reloadButton setEnabled:NO];
    
    [self.backButton setTitle:NSLocalizedString(@"Back", @"Back command") forState:UIControlStateNormal];
    [self.backButton addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forwardButton setTitle:NSLocalizedString(@"Forward", @"Forward command") forState:UIControlStateNormal];
    [self.forwardButton addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stopButton setTitle:NSLocalizedString(@"Stop", @"Stop command") forState:UIControlStateNormal];
    [self.stopButton addTarget:self.webView action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reloadButton setTitle:NSLocalizedString(@"Reload", @"Reload comment") forState:UIControlStateNormal];
    [self.reloadButton addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
 
    
//    // hard coded for testing to make the web view load wikipedia.org when the view loads
//    NSString *urlString = @"http://wikipedia.org";
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];

    
    // loop to add views needed for browser view, texfield, and buttons to the main view
    for (UIView *viewToAdd in @[self.webView, self.textField, self.backButton, self.forwardButton
                                , self.stopButton, self.reloadButton]) {
        [mainView addSubview:viewToAdd];
   
    } // this loop replaces all the individual subview adds remarked out below
//    [mainView addSubview:self.webView];
//    // add textfield as a subview
//    [mainView addSubview:self.textField];
//    
//    // add buttons as subviews
//    [mainView addSubview:self.backButton];
//    [mainView addSubview:self.forwardButton];
//    [mainView addSubview:self.stopButton];
//    [mainView addSubview:self.reloadButton];
    
    
    
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

    // sets height of browser view to height of main view minus the height of URL bar and minus another height to accomodate the browser movement buttons
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight - itemHeight;
    // set a width to be used for the width of the browser movement buttons
    CGFloat buttonwidth = CGRectGetWidth(self.view.bounds) / 4;
    
    
    // now assign the frames
    self.textField.frame = CGRectMake(0, 0, width, itemHeight); // set textfield frame starting at 0,0 on view and then uses width and height created previously
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight); // sets the browser frames
    
    // loop to handle the positioning of each button
    CGFloat currentButtonX = 0;
    
    for (UIButton *thisButton in @[self.backButton, self.forwardButton, self.stopButton, self.reloadButton]) {
        thisButton.frame = CGRectMake(currentButtonX, CGRectGetMaxY(self.webView.frame), buttonwidth, itemHeight);
        currentButtonX  += buttonwidth;
        
        
    }
  
}

#pragma mark - UITextFieldDelegate

// method to handle changes to the URL field = accept a URL
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    // set a variable to hold final URL string being built
    NSURL *finalURL = nil;
    // test for any white spaces in the string entered
    NSRange spaces = [textField.text rangeOfCharacterFromSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    // if blank spaces are found then fill them with plus sign
    if (spaces.location != NSNotFound) {
        NSString *checkStringForSpaces = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        // then append the new string to a google search
        NSString *URLSearchString = checkStringForSpaces;
        NSURL *searchURL = [NSURL URLWithString:
                        [NSString stringWithFormat:@"http://www.google.com/search?q=%@", URLSearchString]];
        // fill the newly built string into a variable to use outside the if statement
        finalURL = searchURL;
    }
    // if no white spaces then build string from user input and check for scheme
    if (spaces.location == NSNotFound) {
        NSString *URLString = textField.text;
        NSURL *URL = [NSURL URLWithString:URLString];
        if (!URL.scheme){
            // the user didn't type http: or https:
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", URLString]];
        }
        // fill the newly built string into a variable to use outside the if statement
        finalURL = URL;
    }
    
        // if we have a newly built string then submit to the view for loading
        if (finalURL){
            NSURLRequest *request = [NSURLRequest requestWithURL:finalURL];
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
    
    // enable buttons if they can be used
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    self.stopButton.enabled = self.webView.isLoading;
    self.reloadButton.enabled = !self.webView.isLoading;
    
    
    
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
