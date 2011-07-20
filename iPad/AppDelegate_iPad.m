//
//  AppDelegate_iPad.m
//  test2
//
//  Created by Jean-Pascal Coutris on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPad.h"

@implementation AppDelegate_iPad

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
	
	mLoader =[[PDFImageLoader alloc]init];
	mLoader.delegate = self;
	[mLoader start];
	
	mCurrentPage = 1;
	
	mPDFLoader = [[PDFLoader alloc]initWithPath:@"mobile.pdf"];
	[mPDFLoader openPDF];
	
	mRead = YES;
	
	mImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)] autorelease];
	[window addSubview:mImageView];
	
	[self tick];
    [self.window makeKeyAndVisible];
    
    return YES;
}


-(void)tick
{
	
	
	static int h =0;
	
	NSLog(@"Loading page n° %d",mCurrentPage);
	PDFPage* lPage = [mPDFLoader pageAtIndex:mCurrentPage];
	
	[mLoader loadImageForPage:lPage outRect:window.bounds];
	
	if(mRead)
	{
	
		mCurrentPage++;
		
		if(mCurrentPage >=mPDFLoader.pageCount)
		{
			mRead =NO;
		}
	}else
	{
		
	
		mCurrentPage--;
		
		if(mCurrentPage ==1)
		{
			mRead =NO;
		}
	}
	
	NSLog(@"LoadPage %d",h );

	
	h++;
	
	[self performSelector:@selector(tick) withObject:nil afterDelay:2];
}

-(void)pdfImageLoader:(PDFImageLoader*)pLoader image:(UIImage*)pImage fromPage:(PDFPage*)pPage
{
	//UIImage* lImage = [pPage imageForRect:mImageView.bounds];
	
	NSLog(@"recu page %d",pPage.pageIndex);
	//mImageView.image =pImage;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
