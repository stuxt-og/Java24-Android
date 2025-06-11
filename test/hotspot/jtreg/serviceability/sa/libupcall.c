/*
 * Copyright (c) 2024, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */

#include <jni.h>

#ifndef _LP64
typedef void (*upcall_func)(void);

upcall_func upcall_from_jlong(jlong upcallAddr) {
    unsigned int low = (unsigned int)(upcallAddr & 0xFFFFFFFF);
    unsigned int high = (unsigned int)((upcallAddr >> 32) & 0xFFFFFFFF);

    (void)high;
    return (upcall_func)(unsigned long long)low;
}
#endif

JNIEXPORT void JNICALL
Java_LingeredAppWithFFMUpcall_callJNI(JNIEnv *env, jclass cls, jlong upcallAddr) {
#ifdef _LP64
  upcall_func upcall = (upcall_func)upcallAddr;
#else
  upcall_func upcall = upcall_from_jlong(upcallAddr);
#endif
  upcall();
} 
