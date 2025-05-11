/****************************************************************************
 *
 * ftheader.h
 *
 *   Basic FreeType header file for Godot Engine CMake build.
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


#ifndef FTHEADER_H_
#define FTHEADER_H_

/* Basic definitions for FreeType2 library. */
#define FT_BEGIN_HEADER
#define FT_END_HEADER

/* Godot-specific configuration */
#define FT_CONFIG_OPTION_USE_BROTLI 0
#define FT_CONFIG_OPTION_USE_HARFBUZZ 0
#define FT_CONFIG_OPTION_USE_ZLIB 0
#define FT_CONFIG_OPTION_USE_BZIP2 0
#define FT_CONFIG_OPTION_USE_PNG 0

#endif /* FTHEADER_H_ */


/* END */
