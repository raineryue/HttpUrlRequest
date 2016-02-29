//
//  ViewController.m
//  HttpUrlRequest
//
//  Created by Rainer on 16/2/26.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

/**
 *  请求按钮点击事件
 */
- (IBAction)submitClickAction:(id)sender {
    // Get请求网络数据（同步）
//    [self getHttpUrlRequestSynchronouse];
    
    // Post请求网络数据（同步）
//    [self postHttpUrlRequestSynchronouse];
    
    // Get请求网络数据（异步）
//    [self getHttpUrlRequestAsynchronouse];
    
    // Post请求网络数据（异步）
    [self postHttpUrlRequestAsynchronouse];
}

#pragma mark - 同步网络请求
/**
 *  Get请求网络数据（同步）
 */
- (void)getHttpUrlRequestSynchronouse {
    // 1.创建一个网络访问字符串
    NSString *urlString = @"http://api.hudong.com/iphonexml.do?type=focus-c";
    
    // 2.将字符串转换为NSURL对象
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 3.使用NSURL对象创建一个NSURLRequest请求对象
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    // 4.定义一个请求返回对象和错误对象
    NSURLResponse *response;
    NSError *error;
    
    // 5.使用请求对象发送同步链接并且接收返回收据
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // 6.将NSData数据转换成字符串数据
    NSString *returnDataString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"------------------------->returnData:{\n %@ \n};\n response:{\n %@ \n}; \n error:{\n %@ \n};", returnDataString, response, error);
}

/**
 *  Post请求网络数据（同步）
 */
- (void)postHttpUrlRequestSynchronouse {
    // 1.创建一个网络访问字符串
    NSString *urlString = @"http://api.hudong.com/iphonexml.do";
    
    // 2.将字符串转换为NSURL对象
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 3.使用NSURL对象创建一个NSURLRequest请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    // 4.设置请求头和请求体
    [request setHTTPMethod:@"POST"];
    
    NSString *prames = @"type=focus-c";
    NSData *data = [prames dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    // 5.定义一个请求返回对象和错误对象
    NSURLResponse *response;
    NSError *error;
    
    // 6.使用请求对象发送同步链接并且接收返回收据
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // 7.将NSData数据转换成字符串数据
    NSString *returnDataString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"------------------------->returnData:{\n %@ \n};\n response:{\n %@ \n}; \n error:{\n %@ \n};", returnDataString, response, error);
}

#pragma mark - 异步网络请求

/**
 *  Get请求网络数据（异步）
 */
- (void)getHttpUrlRequestAsynchronouse {
    NSURL *url = [NSURL URLWithString:@"http://api.hudong.com/iphonexml.do?type=focus-c"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

/**
 *  Post请求网络数据（异步）
 */
- (void)postHttpUrlRequestAsynchronouse {
    NSURL *url = [NSURL URLWithString:@"http://api.hudong.com/iphonexml.do"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    NSString *params = @"type=focus-c";
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - 异步请求代理

/**
 *  接收到服务器回应的时候调用此方法
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    self.receiveData = [NSMutableData data];
    
    NSLog(@"%s \n httpResponse:{statusCode:%u, allHeaderFields:%@}", __func__ , httpResponse.statusCode, httpResponse.allHeaderFields);
}

/**
 *  接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%s \n %@", __func__, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    [self.receiveData appendData:data];
}

/**
 *  数据传输完成之后调用此方法
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s \n %@", __func__, [[NSString alloc] initWithData:self.receiveData encoding:NSUTF8StringEncoding]);
    
    [self.connection cancel];
}

/**
 *  网络请求过程中出现任何错误时调用此方法（断网，链接超时时）会进入此方法
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%s", __func__);
    
    [self.connection cancel];
}


@end
