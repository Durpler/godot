/****************************************************************************
 *
 * ftoption.h
 *
 *   Minimal FreeType configuration options for Godot Engine CMake build.
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

#ifndef FTOPTION_H_
#define FTOPTION_H_

/* Godot-specific configuration options */
#define FT_CONFIG_OPTION_USE_BROTLI 0
#define FT_CONFIG_OPTION_USE_HARFBUZZ 0
#define FT_CONFIG_OPTION_USE_ZLIB 0
#define FT_CONFIG_OPTION_USE_BZIP2 0
#define FT_CONFIG_OPTION_USE_PNG 0

/* Basic configuration options */
#define FT_CONFIG_OPTION_SYSTEM_ZLIB 0
#define FT_CONFIG_OPTION_NO_ASSEMBLER 1
#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING 1
#define FT_CONFIG_OPTION_INCREMENTAL 1

/* Enable various font formats */
#define TT_CONFIG_OPTION_EMBEDDED_BITMAPS 1
#define TT_CONFIG_OPTION_POSTSCRIPT_NAMES 1
#define TT_CONFIG_OPTION_SFNT_NAMES 1
#define TT_CONFIG_OPTION_BYTECODE_INTERPRETER 1
#define T1_CONFIG_OPTION_POSTSCRIPT_NAMES 1
#define T1_CONFIG_OPTION_NO_AFM 1
#define CFF_CONFIG_OPTION_OLD_ENGINE 0
#define FT_CONFIG_OPTION_POSTSCRIPT_NAMES 1

/* Type definition options */
#define FT_RENDER_POOL_SIZE 16384L
#define FT_MAX_MODULES 32

#endif /* FTOPTION_H_ */


/* END */
