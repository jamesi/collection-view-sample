//
//  AppDelegate.m
//  CollectionViewSample
//
//

#import "AppDelegate.h"

#import "ViewControllerASDK.h"
#import "ViewControllerUIKit.h"

@interface AppDelegate ()

@property (nonatomic, readonly) UIViewController *rootViewController;

@end

@implementation AppDelegate

@synthesize rootViewController = _rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    [self.window setRootViewController:self.rootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController *)rootViewController
{
    if (!_rootViewController) {
        UIViewController *viewControllerASDK = [[ASNavigationController alloc] initWithRootViewController:[ViewControllerASDK new]];
        UIViewController *viewControllerUIKit = [[ASNavigationController alloc] initWithRootViewController:[ViewControllerUIKit new]];
        
        UITabBarController *tabController = [[UITabBarController alloc] init];
        [tabController addChildViewController:viewControllerASDK];
        [tabController addChildViewController:viewControllerUIKit];
        
        _rootViewController = tabController;
    }
    return _rootViewController;
}

@end
