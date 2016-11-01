//
//  ViewController.h
//  Data Transfer Rate(DTR)
//
//  Created by Anindya Das on 11/1/16.
//  Copyright © 2016 AppsInception. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *uploaRate;
@property (strong, nonatomic) IBOutlet UILabel *downloadRate;
@property (strong, nonatomic) IBOutlet UILabel *totalUpload;
@property (strong, nonatomic) IBOutlet UILabel *totalDownload;

@end

