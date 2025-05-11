/****************************************************************************
 *
 * ftconfig.h
 *
 *   Minimal FreeType configuration file for Godot Engine CMake build.
 *
 * Copyright (C) 1996-2023 by
 * David Turner, Robert Wilhelm, and Werner Lemberg.
 *
 * This file is part of the FreeType project, and may only be used,
 * modified, and distributed under the terms of the FreeType project
 * license, LICENSE.TXT.  By continuing to use, modify, or distribute
 * this file you indicate that you have read the license and
 * understand and accept it fully.
 *
 */


#ifndef FTCONFIG_H_
#define FTCONFIG_H_

/* Basic config for all platforms */
#define FT_CONFIG_MODULES_H  <freetype/config/ftmodule.h>
#define FT_CONFIG_OPTIONS_H  <freetype/config/ftoption.h>

/* Standard integer types */
#include <stdint.h>
#include <stddef.h>

/* Define to 1 if you have the <dlfcn.h> header file. */
#ifndef _WIN32
#define HAVE_DLFCN_H 1
#endif

/* Platform specific details */
#if defined(_WIN32) || defined(_WIN64)
  #define FT_EXPORT(x)  __declspec(dllexport) x
  #define FT_CALLBACK_DEF(x)  x __cdecl
#else
  #define FT_EXPORT(x)  x
  #define FT_CALLBACK_DEF(x)  x
#endif

/* System includes */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>

/* Define integer types */
typedef int8_t    FT_Int8;
typedef uint8_t   FT_UInt8;
typedef int16_t   FT_Int16;
typedef uint16_t  FT_UInt16;
typedef int32_t   FT_Int32;
typedef uint32_t  FT_UInt32;
typedef int64_t   FT_Int64;
typedef uint64_t  FT_UInt64;

typedef FT_UInt32  FT_ULong;
typedef FT_Int32   FT_Long;

/* Calculate sizes of types */
#define FT_SIZEOF_INT    (sizeof(int))
#define FT_SIZEOF_LONG   (sizeof(long))

/* Integer limits */
#include <limits.h>

#define FT_CHAR_BIT    CHAR_BIT
#define FT_USHORT_MAX  USHRT_MAX
#define FT_INT_MAX     INT_MAX
#define FT_INT_MIN     INT_MIN
#define FT_UINT_MAX    UINT_MAX
#define FT_LONG_MAX    LONG_MAX
#define FT_ULONG_MAX   ULONG_MAX

#endif /* FTCONFIG_H_ */


/* END */
