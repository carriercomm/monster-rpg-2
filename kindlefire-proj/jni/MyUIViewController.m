//
//  MyUIViewController.m
 //  Ballz
//
//  Created by Trent Gamblin on 11-06-19.
//  Copyright 2011 Nooskewl. All rights reserved.
//

#define ASSERT ALLEGRO_ASSERT
#include <allegro5/allegro.h>
#include <allegro5/internal/aintern_iphone.h>
#import "MyUIViewController.h"
#import <GameKit/GameKit.h>

extern bool modalViewShowing;
extern bool airplay_connected;
extern ALLEGRO_DISPLAY *display;
extern ALLEGRO_DISPLAY *controller_display;
UIWindow *al_iphone_get_window(ALLEGRO_DISPLAY *display);

@implementation MyUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	self.wantsFullScreenLayout = YES;

	UIScreen *screen = [UIScreen mainScreen];
		
	self.view = [[UIView alloc] initWithFrame:[screen bounds]];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	printf("viewDidLoad1\n");
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	printf("viewDidAppear1\n");
}
 */


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void) showAchievements
{
	GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
	if (achievements != nil)
	{
		achievements.achievementDelegate = self;
		UIWindow *window = al_iphone_get_window(airplay_connected ? controller_display : display);
		[window addSubview:self.view];
		[self presentModalViewController:achievements animated:NO];
		modalViewShowing = true;
	}
	[achievements release];
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	[self dismissModalViewControllerAnimated:YES];
	modalViewShowing = false;
}

@end


@implementation MyUIAlertViewDelegate  

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  
{  
	result = buttonIndex;  
}  

-(int)getResult  
{  
	return result;  
}  

@end;  

int CreateModalDialog(NSString *title,  
                      NSString *msg,   
                      NSString *ok,   
                      NSString *cancel)  
{  
	// Create an instance of a custom UIAlertViewDelegate that we use to capture  
	// the events generated by the UIAlertView  
	MyUIAlertViewDelegate *lpDelegate = [[MyUIAlertViewDelegate alloc] init];  
	
	// Construct and "show" the UIAlertView (message, title, cancel, ok are all  
	// NSString values created earlier in your code...)  
	UIAlertView *lpAlertView = [[UIAlertView alloc]   
				    initWithTitle:title   
				    message:msg   
				    delegate:lpDelegate   
				    cancelButtonTitle:cancel  
				    otherButtonTitles:ok, nil];  
	
	[lpAlertView performSelectorOnMainThread: @selector(show) withObject:nil waitUntilDone:YES];  

	// By the time this loop terminates, our delegate will have been   
	// called and we can get the result from the delegate (i.e. what button was pressed...)  
	while ((!lpAlertView.hidden) && (lpAlertView.superview!=nil))  
	{  
		al_rest(0.001);
		//[[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];  
		//Sleep(10);  
	}  
	
	// Grab the result from our delegate (via a custom property)  
	int nResult = [lpDelegate getResult];  
	
	// Tidy up!  
	[lpAlertView release];  
	[lpDelegate release];  
	
	//NSLog(@"Result: %d", nResult);  
	
	return nResult;  
}
