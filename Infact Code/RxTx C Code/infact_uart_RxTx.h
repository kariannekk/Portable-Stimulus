/****************************************************************************
 *                       infact_uart_RxTx.h
 *
 * Copyright 2008-2014 Mentor Graphics Corporation. All Rights Reserved
 ****************************************************************************/
#ifndef INCLUDED_infact_uart_RxTx_H
#define INCLUDED_infact_uart_RxTx_H
#include "infact_sdv_types.h"

//<sw_include,gen>
#include "uart_RxTx.h"
//</sw_include>

//<declarations,gen>
typedef struct infact_uart_RxTx_infact_uart_RxTx_item_c_c_s {
  uint64_t  payload;
  int64_t delay;
  int64_t kind;
} infact_uart_RxTx_infact_uart_RxTx_item_c_c_t;


typedef struct infact_uart_RxTx_fields_s {
  infact_uart_RxTx_infact_uart_RxTx_item_c_c_t  infact_uart_RxTx_item_c_inst;
} infact_uart_RxTx_fields_t;

#define infact_uart_RxTx_GRAPH_PARAMS
//</declarations>

//
// Test Component data structure
//
typedef struct infact_uart_RxTx_s {
  infact_sdv_te_mgr         *te_mgr;
  infact_sdv_te                       *te;
  infact_uart_RxTx_fields_t      fields;

} infact_uart_RxTx_t;

#ifdef __cplusplus
extern "C" {
#endif

//*******************************************************************
//* infact_uart_RxTx_create()
//*******************************************************************
infact_uart_RxTx_t *infact_uart_RxTx_create(
    infact_sdv_te_mgr   *te_mgr,
    const char        *inst_name
    infact_uart_RxTx_GRAPH_PARAMS);

//*******************************************************************
//* infact_uart_RxTx_delete()
//*******************************************************************
void infact_uart_RxTx_delete(infact_uart_RxTx_t *comp);

//*******************************************************************
//* infact_uart_RxTx_run()
//*******************************************************************
void infact_uart_RxTx_run(infact_uart_RxTx_t  *comp);


#ifdef __cplusplus
}
#endif

#ifdef UNDEFINED
//<trashcan,gen>
//</trashcan>
#endif

#endif /* INCLUDED_infact_uart_RxTx_H */
