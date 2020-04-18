/*
 * Copyright (C) 2017-2020 Michael Wurm
 * Author: Super Easy Register Scripting Engine (SERSE)
 *
/* BlinkyLight register map */

#ifndef BLINKYLIGHT_H
#define BLINKYLIGHT_H

#include <stdint.h>

/* BlinkyLight AXI-Lite base address */
#define BLINKYLIGHT_BASE ((blinkylight_t *)0x40300000)

/* BlinkyLight register structure */
typedef struct
{
  const volatile uint32_t MAGIC_VALUE;
  volatile uint32_t LED_CONTROL;
  volatile uint32_t RAM[254];
} blinkylight_t;

#endif /* BLINKYLIGHT_H */
