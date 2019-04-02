//
//  ViewController.m
//  window
//
//  Created by BB on 3/20/19.
//  Copyright © 2019 Sweetiebird. All rights reserved.
//


#include <node.h>

#import "ViewController.h"

void nodeStart(void);
void nodeStartAsync(void);





@interface KSCustomOperation : NSOperation
{
    BOOL executing;
    BOOL finished;
}

@property  (strong) NSDictionary *mainDataDictionary;
-(id)initWithData:(id)dataDictionary;
@end

/***********************************************
 CUSTOM OPERATION IMPLEMENTATION
 **********************************************/
@implementation KSCustomOperation
-(id)initWithData:(id)dataDictionary
{
    if (self = [super init])
    {
        _mainDataDictionary = dataDictionary;
        executing = NO;
        finished = NO;
        
    }
    return self;
}

-(void)start
{
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

-(void)main
{
    //This is the method that will do the work
    @try {
        NSLog(@"Custom Operation - Main Method isMainThread?? ANS = %@",[NSThread isMainThread]? @"YES":@"NO");
        NSLog(@"Custom Operation - Main Method [NSThread currentThread] %@",[NSThread currentThread]);
        NSLog(@"Custom Operation - Main Method Try Block - Do Some work here");
        NSLog(@"Custom Operation - Main Method The data that was passed is %@",_mainDataDictionary);
        
        for (int i = 0; i<5; i++)
        {
            NSLog(@"i%d",i);
            //sleep(1); //Never put sleep in production code until and unless the situation demands. A sleep is induced here to demonstrate a scenario that takes some time to complete
        }
        
        [self willChangeValueForKey:@"isExecuting"];
        executing = NO;
        [self didChangeValueForKey:@"isExecuting"];
        
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Catch the exception %@",[exception description]);
    }
    @finally {
        NSLog(@"Custom Operation - Main Method - Finally block");
    }
}

-(BOOL)isConcurrent
{
    return YES;    //Default is NO so overriding it to return YES;
}

-(BOOL)isExecuting{
    return executing;
}

-(BOOL)isFinished{
    return finished;
}
@end


//#include <node.h>

@interface ViewController ()

@end

@implementation ViewController

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
  CGPoint location = [recognizer locationInView:[recognizer.view superview]];

  printf("touch\n");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Logout"
                                 message:@"starting node"
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:
     [UIAlertAction
      actionWithTitle:@"Yes"
      style:UIAlertActionStyleDefault
      handler:^(UIAlertAction * action) {
          //Handle your yes please button action here
          nodeStartAsync();
      }]];
    [self presentViewController:alert animated:YES completion:nil];

    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap = 
      [[UITapGestureRecognizer alloc] initWithTarget:self 
                                              action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

@end

#include <assert.h>
#include <pthread.h>

void* PosixThreadMainRoutine(void* data)
{
    // Do some work here.
    nodeStart();
    
    return NULL;
}

void nodeStartAsync()
{
    // Create the thread using POSIX routines.
    pthread_attr_t  attr;
    pthread_t       posixThreadID;
    int             returnVal;
    
    returnVal = pthread_attr_init(&attr);
    assert(!returnVal);
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    assert(!returnVal);
    
    int     threadError = pthread_create(&posixThreadID, &attr, &PosixThreadMainRoutine, NULL);
    
    returnVal = pthread_attr_destroy(&attr);
    assert(!returnVal);
    if (threadError != 0)
    {
        printf("thread error!");
        // Report an error.
        exit(42); // TODO
    }
}

void nodeStart(void) {
    const char* args[] = {
        "--jitless",
        "-e",
        "console.log('Node start!!');                                                       \
        setTimeout(()=>{ console.log(\"prevent exit \"); }, 1000000000); \
        var fuse=Math.floor(Math.random()*3000);                       \
        console.log(`Self-destructing in ${fuse} milliseconds`);        \
        setTimeout(()=>{                                                \
        console.log('ka-BOOM');                                       \
        process.exit(42);                                       \
        }, fuse);                                                       \
        ",        0};
    
    node::Start(sizeof(args)/sizeof(const char*)-1, (char**)args);
}
