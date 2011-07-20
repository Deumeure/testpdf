//
//  ImageLoader.m
//  ImageLoader
//
//  Created by Mac5 on 09/08/10.
//  Copyright 2010 Anuman Interactive. All rights reserved.
//

#import "PDFImageLoader.h"
#import "InvocationUtil.h"

@interface PDFImageLoader (Private)

-(void)loadImageThreadFunc;



@end

@implementation PDFImageLoader

-(id)init
{
	mLockObject=[[NSObject alloc]init];
	self.isWorking=NO;
	return self;
}

-(void)loadImageThreadFunc
{
	
	NSAutoreleasePool* lPool =[[NSAutoreleasePool alloc]init];
	
	NSLog(@"Thread démarré");
	
	while (self.isWorking) 
	{
		
		NSArray* lArgs =[mWorkingQueue pop];
	
		//On récupère les arguments
		PDFPage* lPage =(PDFPage*)[lArgs objectAtIndex:0];
		NSString* lKey =(NSString*)[lArgs objectAtIndex:1];
		
		CGRect lRect = CGRectFromString(lKey);
		
		UIImage* lImage = [lPage imageForRect:lRect];
		
//		NSArray * lArray = [[NSArray alloc]initWithObjects:lPage,lImage,nil];
//		[self performSelectorOnMainThread:@selector(raiseImage:) withObject:lArray waitUntilDone:NO];
//		
//		
		NSInvocation* lInvoc = createInvocation(self,@selector(raiseImage:page:));
		[lInvoc setArgument:&lImage atIndex:2];
		[lInvoc setArgument:&lPage atIndex:3];
		
		[lInvoc performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
		
		
	}
	
	[lPool release];
}
-(void)raiseImage:(UIImage*)pImage page:(PDFPage*)pPage
{
		[mDelegate pdfImageLoader:self image:pImage fromPage:pPage];
}

-(void)raiseImage:(NSMutableArray*)lArgs
{
	
	UIImage* lImage =(UIImage*)[lArgs objectAtIndex:1];
	PDFPage* lPage =(PDFPage*)[lArgs objectAtIndex:0];

	
	[lArgs release];
	
	[mDelegate pdfImageLoader:self image:lImage fromPage:lPage];
	
}

//Demmarre l'imageLoader
-(void)start
{

	//Protéger pour ne pas rentrer deux foi
	@synchronized (mLockObject)
	{
		if(!self.isWorking)
		{
			mWorkingQueue = [[BlockingQueue alloc]init];
			
			self.isWorking=YES;
			[NSThread detachNewThreadSelector:@selector(loadImageThreadFunc) toTarget:self withObject:nil];
			
		}
	}
}

//Ajoute une image à la file d'attente
-(void)loadImageForPage:(PDFPage*)pPage outRect:(CGRect)pRect
{

		NSArray* lArray =[NSArray arrayWithObjects:pPage,NSStringFromCGRect(pRect),nil];
	
		[mWorkingQueue push:lArray];

}


@synthesize isWorking = mIsWorking;
@synthesize delegate = mDelegate;

@end
