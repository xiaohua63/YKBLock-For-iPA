//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  AntiAntiDebug.m
//  MonkeyDev
//
//  Created by AloneMonkey on 2016/12/10.
//  Copyright © 2017年 MonkeyDev. All rights reserved.
//

#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif
#import "fishhook.h"
#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>
typedef int (*ptrace_ptr_t)(int _request,pid_t _pid, caddr_t _addr,int _data);
typedef void* (*dlsym_ptr_t)(void * __handle, const char* __symbol);
typedef int (*syscall_ptr_t)(int, ...);
typedef int (*sysctl_ptr_t)(int *,u_int, void*, size_t*,void*, size_t);
static ptrace_ptr_t orig_ptrace = NULL;
static dlsym_ptr_t orig_dlsym = NULL;
static sysctl_ptr_t orig_sysctl = NULL;
static syscall_ptr_t orig_syscall = NULL;
static int (*origianl_uname)(struct utsname *);
int my_uname(struct utsname *value);

int my_uname(struct utsname *value) {
    int ret = origianl_uname(value);
    NSString *newModelName = [[NSUserDefaults standardUserDefaults] objectForKey:@"aadevice"];
    const char *newModelNameChar = newModelName.UTF8String;
    strcpy(value->machine, newModelNameChar);
    return ret;
}
static int (*orig_sysctlbyname)(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen);
int mysysctlbyname(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen);

int mysysctlbyname(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen){
    int ret = orig_sysctlbyname(name,oldp,oldlenp,newp,newlen);
    if (!strcmp(name,"hw.machine")) {
        NSString *strNSString = [[NSUserDefaults standardUserDefaults] objectForKey:@"aadevice"];
        if (oldp) {
            ret = orig_sysctlbyname(name,oldp,oldlenp,newp,newlen);
            const char* mechine = [strNSString cStringUsingEncoding:NSUTF8StringEncoding];
            *oldlenp = strlen(mechine) + 1;
            strcpy((char *)oldp,mechine);
        }else{
            ret = orig_sysctlbyname(name,oldp,oldlenp,newp,newlen);
            const char* mechine = [strNSString cStringUsingEncoding:NSUTF8StringEncoding];
            *oldlenp = strlen(mechine) + 1;
        }
    }else{
       ret = orig_sysctlbyname(name,oldp,oldlenp,newp,newlen);
    }
    return ret;
}
int my_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data);
void* my_dlsym(void* __handle, const char* __symbol);
int my_sysctl(int * name, u_int namelen, void * info, size_t * infosize, void * newinfo, size_t newinfosize);
int my_syscall(int code, va_list args);

int my_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data){
    if(_request != 31){
        return orig_ptrace(_request,_pid,_addr,_data);
    }
    
    NSLog(@"[AntiAntiDebug] - ptrace request is PT_DENY_ATTACH");
    
    return 0;
}

void* my_dlsym(void* __handle, const char* __symbol){
    if(strcmp(__symbol, "ptrace") != 0){
        return orig_dlsym(__handle, __symbol);
    }
    
    NSLog(@"[AntiAntiDebug] - dlsym get ptrace symbol");
    
    return my_ptrace;
}
typedef struct kinfo_proc _kinfo_proc;
int my_sysctl(int * name, u_int namelen, void * info, size_t * infosize, void * newinfo, size_t newinfosize){
    if(namelen == 4 && name[0] == CTL_KERN && name[1] == KERN_PROC && name[2] == KERN_PROC_PID && info && infosize && ((int)*infosize == sizeof(_kinfo_proc))){
        int ret = orig_sysctl(name, namelen, info, infosize, newinfo, newinfosize);
        struct kinfo_proc *info_ptr = (struct kinfo_proc *)info;
        if(info_ptr && (info_ptr->kp_proc.p_flag & P_TRACED) != 0){
            NSLog(@"[AntiAntiDebug] - sysctl query trace status.");
            info_ptr->kp_proc.p_flag ^= P_TRACED;
            if((info_ptr->kp_proc.p_flag & P_TRACED) == 0){
                NSLog(@"trace status reomve success!");
            }
        }
        return ret;
    }
    return orig_sysctl(name, namelen, info, infosize, newinfo, newinfosize);
}
int my_syscall(int code, va_list args){
    int request;
    va_list newArgs;
    va_copy(newArgs, args);
    if(code == 26){
#ifdef __LP64__
        __asm__(
                "ldr %w[result], [fp, #0x10]\n"
                : [result] "=r" (request)
                :
                :
                );
#else
        request = va_arg(args, int);
#endif
        if(request == 31){
            NSLog(@"[AntiAntiDebug] - syscall call ptrace, and request is PT_DENY_ATTACH");
            return 0;
        }
    }
    return orig_syscall(code, newArgs);
}
__attribute__((constructor)) static void entry(){
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"aadevice"]) {
        rebind_symbols((struct rebinding[1]){{"sysctlbyname", mysysctlbyname ,(void *)&orig_sysctlbyname}},1);
    }
    rebind_symbols((struct rebinding[1]){{"ptrace", my_ptrace, (void*)&orig_ptrace}},1);
    rebind_symbols((struct rebinding[1]){{"dlsym", my_dlsym, (void*)&orig_dlsym}},1);
    rebind_symbols((struct rebinding[1]){{"syscall", my_syscall, (void*)&orig_syscall}},1);
}

