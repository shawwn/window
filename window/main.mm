//
//  main.m
//  window
//
//  Created by BB on 3/20/19.
//  Copyright © 2019 Sweetiebird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#include <unistd.h>
// #include <stdio.h>
// #include <fcntl.h>
// #include <cstdlib>
// #include <cstring>
// #include <dlfcn.h>
// #include <errno.h>
#include <string>
#include <map>
#include <thread>
#include <v8.h>
#include <node.h>

using namespace v8;

int main(int argc, char * argv[]) {
    printf("argc: %d\n", argc);
    for (int i = 0; i < argc; i++) {
        printf("%s\n", argv[i]);
    }
    printf("----\n");
    /*
    if (argc > 1) {
        return node::Start(argc, argv);
    }*/

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
