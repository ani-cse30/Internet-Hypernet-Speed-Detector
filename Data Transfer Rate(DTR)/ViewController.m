//
//  ViewController.m
//  Data Transfer Rate(DTR)
//
//  Created by Anindya Das on 11/1/16.
//  Copyright © 2016 AppsInception. All rights reserved.
//

#import "ViewController.h"
#import <ifaddrs.h>
#import <net/if.h>
@interface ViewController ()

@end
static NSString *const DTRUpload = @"upload";
static NSString *const DTRDownload = @"download";
static NSString *const DTRDownloadRate = @"download_rate";
static NSString *const DTRUploadRate = @"upload_rate";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Internet/Hypernet Speed Detector";
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(aTime) userInfo:nil repeats:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)aTime
{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSDictionary *data=[ViewController DataCounters];
        _totalUpload.text=[data objectForKey:@"upload"];
        _totalDownload.text=[data objectForKey:@"download"];
        _uploaRate.text=[data objectForKey:@"upload_rate"];
        _downloadRate.text=[data objectForKey:@"download_rate"];

    }];
    }

+(NSDictionary*)DataCounters
{
    BOOL interfaceflag=0;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    
    u_int32_t WiFiSent = 0;
    u_int32_t WiFiReceived = 0;
    u_int32_t WWANSent = 0;
    u_int32_t WWANReceived = 0;
    
    if (getifaddrs(&addrs) == 0)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                if(ifa_data != NULL)
                {
                    // NSLog(@"Interface name %s: sent %tu received %tu",cursor->ifa_name,ifa_data->ifi_obytes,ifa_data->ifi_ibytes);
                }
                
                NSString *name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
                if ([name hasPrefix:@"en"])
                {
                    interfaceflag=1;
                    const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                    if(ifa_data != NULL)
                    {
                        WiFiSent += ifa_data->ifi_obytes;
                        WiFiReceived += ifa_data->ifi_ibytes;
                    }
                    
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                    if(ifa_data != NULL)
                    {
                        WWANSent += ifa_data->ifi_obytes;
                        WWANReceived += ifa_data->ifi_ibytes;
                    }
                    
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    return interfaceflag? @{DTRUpload:[self transformedValue:[NSNumber numberWithUnsignedInt:WiFiSent]],
                            DTRDownload:[self transformedValue:[NSNumber numberWithUnsignedInt:WiFiReceived]],DTRUploadRate:[self uploadRate:[NSNumber numberWithUnsignedInt:WiFiSent]],DTRDownloadRate:[self downloadRate:[NSNumber numberWithUnsignedInt:WiFiReceived]]}:@{DTRUpload:[self transformedValue:[NSNumber numberWithUnsignedInt:WWANSent]],
                                                                                                                                                                                                                                                                             DTRDownload:[self transformedValue:[NSNumber numberWithUnsignedInt:WWANReceived]],DTRUploadRate:[self uploadRate:[NSNumber numberWithUnsignedInt:WWANSent]],DTRDownloadRate:[self downloadRate:[NSNumber numberWithUnsignedInt:WWANReceived]]};
    
}

+ (id)transformedValue:(id)value
{
    
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}
+ (id)uploadRate:(id)value
{
    double convertedValue = [value doubleValue]-[[NSUserDefaults standardUserDefaults]                                                                                                                                                                           doubleForKey:@"PreUploadData"];
    [[NSUserDefaults standardUserDefaults] setDouble:[value doubleValue] forKey:@"PreUploadData"];
    return [self transformedValue:[NSString stringWithFormat:@"%4.2f",convertedValue]];}
+ (id)downloadRate:(id)value
{
    
    double convertedValue = [value doubleValue]-[[NSUserDefaults standardUserDefaults]                                                                                                                                                                           doubleForKey:@"PreDownloadData"];
    [[NSUserDefaults standardUserDefaults] setDouble:[value doubleValue] forKey:@"PreDownloadData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [self transformedValue:[NSString stringWithFormat:@"%4.2f",convertedValue]];
}
@end
