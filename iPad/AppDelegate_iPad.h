//
//  AppDelegate_iPad.h
//  test2
//
//  Created by Jean-Pascal Coutris on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFLoader.h"
#import "PDFImageLoader.h"

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	PDFLoader* mPDFLoader;
	uint mCurrentPage;
	
	bool mRead;
	PDFImageLoader * mLoader;
	UIImageView * mImageView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

