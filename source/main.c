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
#include <netinet/in.h>

#define PS4_IP "192.168.0.6"
#define PS4_PORT 1337

int netdbg_sock;

int main(void) {
  // Init and resolve libraries
  sceSysmoduleLoadModuleInternal(SCE_SYSMODULE_INTERNAL_NET);

  // Init netdebug
  struct sockaddr_in server;
  server.sin_len = sizeof(server);
  server.sin_family = AF_INET;
  // server.sin_addr.s_addr = IP(192, 168, 0, 4);
  inet_pton(AF_INET, PS4_IP, &(server.sin_addr.s_addr));

  server.sin_port = sceNetHtons(9023);
  memset(server.sin_zero, 0, sizeof(server.sin_zero));

  netdbg_sock = sceNetSocket("netdebug", AF_INET, SOCK_STREAM, 0);
  sceNetConnect(netdbg_sock, (struct sockaddr *)&server, sizeof(server));

  ftp_init(PS4_IP, PS4_PORT);

  // INFO("PS4 listening on IP %s Port %i\n", PS4_IP, PS4_PORT);

  while (1) {
    sceKernelUsleep(100 * 1000);
  }

  ftp_fini();

  return 0;
}
