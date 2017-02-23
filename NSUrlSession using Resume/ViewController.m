//
//  ViewController.m
//  NSUrlSession using Resume
//
//  Created by chaitanya on 05/10/16.
//  Copyright © 2016 chaitanya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addObserver:self forKeyPath:@"resumeData" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"downLoadTask" options:NSKeyValueObservingOptionNew context:NULL];
    

//    [self.cancelButton setHidden:YES];
//    [self.resumeButton setHidden:YES];
//    
    
    self.downLoadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:@"http://cdn.tutsplus.com/mobile/uploads/2014/01/5a3f1-sample.jpg"]];
    
    
    [self.downLoadTask resume];
    //    [self.cancelButton setHidden:YES];
//    [self.resumeButton setHidden:YES];
//    
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    [sessionConfiguration setAllowsCellularAccess:YES];
//    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
//    
//    // Create Session
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//    
//    // Send Request
//    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"];
//    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
//    }] resume];
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSURLSession *)session {
    if (!_session) {
        // Create Session Configuration
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // Create Session
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    
    return _session;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cancelButton setHidden:YES];
        [self.progressView setHidden:YES];
        [self.imageView setImage:[UIImage imageWithData:data]];
    });
    
    // Invalidate Session
    [session finishTasksAndInvalidate];
}




- (IBAction)Resume:(id)sender {
    if (!self.resumeData) return;
    
    // Hide Resume Button
    [self.resumeButton setHidden:YES];
    
    // Create Download Task
    self.downLoadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    
    // Resume Download Task
    [self.downLoadTask resume];
    
    // Cleanup
    [self setResumeData:nil];
    
}


- (IBAction)Cancel:(id)sender {
    
    if (!self.downLoadTask) return;
    
    // Hide Cancel Button
    [self.cancelButton setHidden:YES];
    
    [self.downLoadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if (!resumeData) return;
        [self setResumeData:resumeData];
        [self setDownLoadTask:nil];
    }];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"resumeData"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resumeButton setHidden:(self.resumeData == nil)];
        });
        
    } else if ([keyPath isEqualToString:@"downLoadTask"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cancelButton setHidden:(self.downLoadTask == nil)];
        });
    }
}

@end
