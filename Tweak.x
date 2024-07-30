#import <Foundation/Foundation.h>

%hook NRMAURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSString *url = dataTask.currentRequest.URL.absoluteString;
    if (![url isEqualToString:@"https://cms.icabanken.se/apps/startup?expand=*"]) {
        return %orig;
    }

    NSMutableDictionary *payload = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
    payload[@"items"] = [NSArray new];
    NSData *newData = [NSJSONSerialization dataWithJSONObject:payload options:kNilOptions error:nil];
    %orig(session, dataTask, newData);
}

%end
