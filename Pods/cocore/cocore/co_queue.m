//
//  co_queue.c
//  coobjc
//
//  Copyright © 2018 Alibaba Group Holding Limited All rights reserved.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

#include "co_queue.h"
#import <pthread/pthread.h>
#import <mach/mach.h>

dispatch_queue_t co_get_current_queue() {
    if ([NSThread isMainThread]) {
        return dispatch_get_main_queue();
    }
    thread_identifier_info_data_t tiid;
    thread_t thread = mach_thread_self();
    mach_msg_type_number_t cnt = THREAD_IDENTIFIER_INFO_COUNT;
    kern_return_t kr = thread_info(thread,
                                   THREAD_IDENTIFIER_INFO, (thread_info_t)&tiid, &cnt);
    if (kr == KERN_SUCCESS) {
        if (tiid.dispatch_qaddr == thread) {
            return NULL;
        }

        if (tiid.dispatch_qaddr != 0) {
            return *(__unsafe_unretained dispatch_queue_t*)(void*)tiid.dispatch_qaddr;
        }
        return NULL;
    }
    return NULL;
}
