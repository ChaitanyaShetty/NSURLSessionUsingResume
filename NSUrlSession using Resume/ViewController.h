//
//  ViewController.h
//  NSUrlSession using Resume
//
//  Created by chaitanya on 05/10/16.
//  Copyright © 2016 chaitanya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLSessionDelegate, NSURLSessionDownloadDelegate>
{
    NSURLSession *_session;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *resumeButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) NSURLSessionDownloadTask *downLoadTask;
@property (strong, nonatomic) NSData *resumeData;

- (IBAction)Cancel:(id)sender;

- (IBAction)Resume:(id)sender;


@end

