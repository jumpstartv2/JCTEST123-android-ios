//
//  IGCAPIClient.m
//  IGCTemplate
//
//  Created by Jason Jon E. Carreos on 05/09/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "IGCAPIClient.h"

#pragma mark -  Class Extension

@interface IGCAPIClient ()

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *authHeader;
@property (nonatomic, strong) NSString *rootURL;

@end

@implementation IGCAPIClient

#pragma mark - Public Methods

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IGCAPIKey"];
    self.authHeader = nil;  // TODO From custom OAuth instance object
    self.rootURL = @"";
    
    return self;
}

- (instancetype)initWithRootURL:(NSString *)rootURL authHeader:(NSString *)authHeader {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"XDSAPIKey"];
    self.authHeader = authHeader;
    self.rootURL = rootURL;
    
    return self;
}

- (void)getRequestToLink:(NSString *)link
           authenticated:(BOOL)authenticated
              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSURLRequest *request = [self requestFor:link
                                      method:kIGCAPIHTTPMethodGet
                               authenticated:authenticated];
    
    [self performAuthenticatedTask:authenticated
                       withRequest:[request mutableCopy]
                        completion:completion];
}

- (void)performAuthenticatedTask:(BOOL)isAuthenticated
                     withRequest:(NSMutableURLRequest *)request
                      completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data,
                                                                                     NSURLResponse * _Nullable response,
                                                                                     NSError * _Nullable error) {
        NSDictionary *responseDict;
        
        if (error) {
            return;
        }
        
        responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions
                                                         error:nil];
        
        completion(response, responseDict, error);
    }];
    
    [task resume];
}

- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                      authenticated:(BOOL)authenticated {
    return [self requestFor:endpoint
                     method:method
                 bodyParams:nil
                queryParams:nil
              authenticated:authenticated];
}

- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                         bodyParams:(NSDictionary *)params
                      authenticated:(BOOL)authenticated {
    return [self requestFor:endpoint
                     method:method
                 bodyParams:params
                queryParams:nil
              authenticated:authenticated];
}

- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                        queryParams:(NSDictionary *)params
                      authenticated:(BOOL)authenticated {
    return [self requestFor:endpoint
                     method:method
                 bodyParams:nil
                queryParams:params
              authenticated:authenticated];
}

- (NSMutableURLRequest *)requestFor:(NSString *)endpoint
                             method:(NSString *)method
                         bodyParams:(NSDictionary *)bodyParams
                        queryParams:(NSDictionary *)queryParams
                      authenticated:(BOOL)authenticated {
    NSURL *url;
    NSMutableURLRequest *request;
    
    NSAssert(self.rootURL && self.rootURL.length > 0, @"Root API is required");
    
    if (![endpoint containsString:self.rootURL]) {
        endpoint = [NSString stringWithFormat:@"%@/%@/", self.rootURL, endpoint];
    }
    
    url = [NSURL URLWithString:endpoint];
    
    if (queryParams) {
        url = [self url:endpoint queryParameters:queryParams];
    }
    
    request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.HTTPMethod = method;
    request.HTTPShouldHandleCookies = NO;
    request.timeoutInterval = 30.0;
    
    if (bodyParams) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyParams
                                                           options:(NSJSONWritingOptions)0
                                                             error:nil];
    }
    
    // Header fields
    [request setValue:kIGCAPIContentTypeJSON forHTTPHeaderField:@"Accept"];
    
    if (![method isEqualToString:kIGCAPIHTTPMethodGet]) {
        [request setValue:kIGCAPIContentTypeJSON forHTTPHeaderField:@"Content-Type"];
    }
    
    if (self.authHeader && authenticated) {
        [request setValue:self.authHeader forHTTPHeaderField:@"Authorization"];
    }
    
    return request;
}

#pragma mark - Private Methods

- (NSURL *)url:(NSString *)url queryParameters:(NSDictionary *)params {
    NSMutableArray *queryItems = [NSMutableArray array];
    NSURLComponents *components = [NSURLComponents componentsWithString:url];
    
    for (NSString *key in params) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:params[key]]];
    }
    
    components.queryItems = queryItems;
    
    return components.URL;
}

@end
