//
//  ViewController.m
//  sso-test
//
//  Created by 李帅 on 2017/7/14.
//  Copyright © 2017年 company. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testsso];
}

- (void)testsso{
    NSString *SSOTicketUrlStr = @"http://192.168.1.110:8080/cas/v1/tickets";//此处替换对应url
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache"};
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[@"username=test1" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&password=1234567" dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SSOTicketUrlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    //拿到TGT
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"%@", httpResponse);
            NSString *TGT = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                                       @"cache-control": @"no-cache"};
            NSMutableData *postData = [[NSMutableData alloc] initWithData:[@"service=your-target-url" dataUsingEncoding:NSUTF8StringEncoding]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SSOTicketUrlStr,TGT]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
            [request setHTTPMethod:@"POST"];
            [request setAllHTTPHeaderFields:headers];
            [request setHTTPBody:postData];
            //拿到ST
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    NSLog(@"%@", error);
                } else {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    NSLog(@"%@", httpResponse);
                    NSString *ST = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    //SSO登录成功，应用内登录
//                    [AFNetworkTools get_JsonData_withUrl:@"http://192.168.1.110:8080/center/login/cas" parameters:@{@"ticket":ST} success:nil failure:nil];//请求登录
                }
            }];
            [dataTask resume];
        }
    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
