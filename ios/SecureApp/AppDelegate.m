#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <TrustKit/TrustKit.h>
#import <TrustKit/TSKPinningValidator.h>
#import <TrustKit/TSKPinningValidatorCallback.h>
#import "JB.h"

#ifdef FB_SONARKIT_ENABLED
#import <FlipperKit/FlipperClient.h>
#import <FlipperKitLayoutPlugin/FlipperKitLayoutPlugin.h>
#import <FlipperKitUserDefaultsPlugin/FKUserDefaultsPlugin.h>
#import <FlipperKitNetworkPlugin/FlipperKitNetworkPlugin.h>
#import <SKIOSNetworkPlugin/SKIOSNetworkAdapter.h>
#import <FlipperKitReactPlugin/FlipperKitReactPlugin.h>

static void InitializeFlipper(UIApplication *application) {
  FlipperClient *client = [FlipperClient sharedClient];
  SKDescriptorMapper *layoutDescriptorMapper = [[SKDescriptorMapper alloc] initWithDefaults];
  [client addPlugin:[[FlipperKitLayoutPlugin alloc] initWithRootNode:application withDescriptorMapper:layoutDescriptorMapper]];
  [client addPlugin:[[FKUserDefaultsPlugin alloc] initWithSuiteName:nil]];
  [client addPlugin:[FlipperKitReactPlugin new]];
  [client addPlugin:[[FlipperKitNetworkPlugin alloc] initWithNetworkAdapter:[SKIOSNetworkAdapter new]]];
  [client start];
}
#endif

static const int kNVSBlurViewTag = 198490;//or wherever number you like

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef FB_SONARKIT_ENABLED
  InitializeFlipper(application);
#endif

  // Override TrustKit's logger method, useful for local debugging
  void (^loggerBlock)(NSString *) = ^void(NSString *message)
  {
    NSLog(@"TrustKit log: %@", message);
  };
  [TrustKit setLoggerBlock:loggerBlock];

  NSDictionary *trustKitConfig =
  @{
    // Swizzling because we can't access the NSURLSession instance used in React Native's fetch method
    kTSKSwizzleNetworkDelegates: @YES,
    kTSKPinnedDomains: @{
        @"medium.com" : @{
            kTSKIncludeSubdomains: @YES, // Pin all subdomains
            kTSKEnforcePinning: @YES, // Block connections if pinning validation failed
            kTSKDisableDefaultReportUri: @YES,
            kTSKPublicKeyHashes : @[
              @"zooUcFEIAUJy6siM7WCSQgLO2jXVxmVIioJQzArfWjE=",
              @"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=", // Fake backup key but we need to provide 2 pins
            ],
        },
    }};
  [TrustKit initSharedInstanceWithConfiguration:trustKitConfig];
  [TrustKit sharedInstance].pinningValidatorCallback = ^(TSKPinningValidatorResult *result, NSString *notedHostname, TKSDomainPinningPolicy *policy) {
    if (result.finalTrustDecision == TSKTrustEvaluationFailedNoMatchingPin) {
      NSLog(@"TrustKit certificate matching failed");
      // Add more logging here. i.e. Sentry, BugSnag etc
    }
  };
  
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"SecureApp"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  /*
    List function:
    BOOL isRunningOnMac => detecting running on MAC
    BOOL isJb() => detecting jailbreak
    BOOL isInjectedWithDynamicLibrary() => detecting inject with dynamic library
    BOOL isDebugged() => detecting it is being debugged
    BOOL isFromAppStore() => detecting app is from Appstore
    BOOL isSecurityCheckPassed() => result of all of function above that passed security check, make sure it is implemented in Production
  */
  // Jailbreak detection, if it is true, show alert, then exit app
  if (!isSecurityCheckPassed()) {
      UIAlertController *alertController = [UIAlertController
                                            alertControllerWithTitle:@"Jailbroken Device is Detected"
        message:@"You cannot use this app, bye ????"
        preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
        exit(1);
      }];
      [alertController addAction:cancelAction];
      [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
  }
  
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    TSKPinningValidator *pinningValidator = [[TrustKit sharedInstance] pinningValidator];
    // Pass the authentication challenge to the validator; if the validation fails, the connection will be blocked
    if (![pinningValidator handleChallenge:challenge completionHandler:completionHandler])
    {
        // TrustKit did not handle this challenge: perhaps it was not for server trust
        // or the domain was not pinned. Fall back to the default behavior
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)nvs_blurPresentedView
    {
        if ([self.window viewWithTag:kNVSBlurViewTag]){
            return;
        }
        [self.window addSubview:[self p_blurView]];
    }

    - (void)nvs_unblurPresentedView
    {
        [[self.window viewWithTag:kNVSBlurViewTag] removeFromSuperview];
    }

    #pragma mark - Private

    - (UIView *)p_blurView
    {
        UIView *snapshot = [self.window snapshotViewAfterScreenUpdates:NO];

        UIView *blurView = nil;
        if ([UIVisualEffectView class]){
            UIVisualEffectView *aView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            blurView        = aView;
            blurView.frame  = snapshot.bounds;
            [snapshot addSubview:aView];
        }
        else {
            UIToolbar *toolBar  = [[UIToolbar alloc] initWithFrame:snapshot.bounds];
            toolBar.barStyle    = UIBarStyleDefault;
            [snapshot addSubview:toolBar];
        }
        snapshot.tag = kNVSBlurViewTag;
        return snapshot;
    }

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self nvs_blurPresentedView];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self nvs_unblurPresentedView];
}

@end
