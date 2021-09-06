/*
 * Copyright (c) 2015 Sergi Granell (xerpi)
 */

#include <arpa/inet.h>
#include <orbis/libSceNet.h>
#include <orbis/libSceSysmodule.h>
#include <orbis/libkernel.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>

#include "ftp.h"
#include <debugnet.h>
#include <netinet/in.h>

#define PS4_IP "192.168.0.6"
#define PS4_PORT 1337

extern int ftp_active;

int main(void) {
  // Init and resolve libraries
  sceSysmoduleLoadModuleInternal(SCE_SYSMODULE_INTERNAL_NET);
  sceSysmoduleLoadModuleInternal(SCE_SYSMODULE_INTERNAL_NETCTL);

  debugNetInit("192.168.0.20", 18198, 3);
  ftp_init(PS4_IP, PS4_PORT);
  
  while (ftp_active) {
    sceKernelUsleep(100 * 1000);
  }

  ftp_fini();

  return 0;
}
