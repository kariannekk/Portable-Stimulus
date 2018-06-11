/****************************************************************************
 *                      infact_uart_RxTx_static.c
 *
 * Copyright 2012 Mentor Graphics Corporation. All Rights Reserved
 * !!WARNING!! Generated automatically. Do not edit.
 ****************************************************************************/
#include "infact_uart_RxTx_static.h"
#include <stdlib.h>
#include <string.h>

typedef struct infact_sdv_action_info_s {
  const char    *name;
  infact_sdv_action_t action_type;
} infact_sdv_action_info;

typedef struct infact_sdv_action_invoke_s {
  uint32_t        id;
  uint64_t        val;
} infact_sdv_action_invoke;

typedef struct infact_sdv_engine_info_s {
  const char      *name;
  infact_sdv_action_info    *action_info;
  uint32_t      num_actions;
  infact_sdv_action_invoke  *action_invoke;
  uint32_t      num_action_invokes;
} infact_sdv_engine_info;

typedef struct infact_sdv_action_closure_s {
  union {
    infact_sdv_action_func_ptr              action;
    infact_sdv_signed_meta_action_func_ptr        signed_meta_action;
    infact_sdv_unsigned_meta_action_func_ptr      unsigned_meta_action;
    infact_sdv_signed_meta_action_import_func_ptr   signed_meta_action_import;
    infact_sdv_unsigned_meta_action_import_func_ptr   unsigned_meta_action_import;
  } m_fp;
  void        *m_ud;
} infact_sdv_action_closure;

typedef struct infact_sdv_static_te_s {
  infact_sdv_engine_info      *info;
  infact_sdv_action_closure   *closures;
  uint32_t        invoke_idx;
} infact_sdv_static_te;


/********************************************************************
 ********************************************************************/

/**
 * Information about each action in the sdv_uvm_smoke_eng test engine
 */
static infact_sdv_action_info infact_uart_RxTx_action_info[] = {
  {"infact_checkcov", INFACT_SDV_ACTION},
  {"do_item(infact_uart_RxTx_item_c_inst).end", INFACT_SDV_ACTION},
  {"infact_uart_RxTx_item_c_inst.do_RxTx", INFACT_SDV_ACTION},
  {"do_item(infact_uart_RxTx_item_c_inst).begin", INFACT_SDV_ACTION},
  {"init", INFACT_SDV_ACTION},
  {"infact_uart_RxTx_item_c_inst.kind", INFACT_SDV_SIGNED_META_ACTION},
  {"infact_uart_RxTx_item_c_inst.delay", INFACT_SDV_SIGNED_META_ACTION},
  {"infact_uart_RxTx_item_c_inst.payload", INFACT_SDV_UNSIGNED_META_ACTION}
};
/**
 * Invocation information for actions in the test engine infact_uart_RxTx
 */
static infact_sdv_action_invoke infact_uart_RxTx_action_invoke[] = {
    {4, 0},   //init
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 0},   //infact_uart_RxTx_item_c_inst.payload
    {6, 5},   //infact_uart_RxTx_item_c_inst.delay
    {5, 1},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 216},   //infact_uart_RxTx_item_c_inst.payload
    {6, 7},   //infact_uart_RxTx_item_c_inst.delay
    {5, 1},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 2},   //infact_uart_RxTx_item_c_inst.payload
    {6, 17},   //infact_uart_RxTx_item_c_inst.delay
    {5, 1},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 197},   //infact_uart_RxTx_item_c_inst.payload
    {6, 9},   //infact_uart_RxTx_item_c_inst.delay
    {5, 0},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 253},   //infact_uart_RxTx_item_c_inst.payload
    {6, 5},   //infact_uart_RxTx_item_c_inst.delay
    {5, 0},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 88},   //infact_uart_RxTx_item_c_inst.payload
    {6, 12},   //infact_uart_RxTx_item_c_inst.delay
    {5, 0},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 0},   //infact_uart_RxTx_item_c_inst.payload
    {6, 19},   //infact_uart_RxTx_item_c_inst.delay
    {5, 0},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 255},   //infact_uart_RxTx_item_c_inst.payload
    {6, 10},   //infact_uart_RxTx_item_c_inst.delay
    {5, 1},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 2},   //infact_uart_RxTx_item_c_inst.payload
    {6, 14},   //infact_uart_RxTx_item_c_inst.delay
    {5, 0},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 125},   //infact_uart_RxTx_item_c_inst.payload
    {6, 3},   //infact_uart_RxTx_item_c_inst.delay
    {5, 1},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 179},   //infact_uart_RxTx_item_c_inst.payload
    {6, 16},   //infact_uart_RxTx_item_c_inst.delay
    {5, 1},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 253},   //infact_uart_RxTx_item_c_inst.payload
    {6, 3},   //infact_uart_RxTx_item_c_inst.delay
    {5, 1},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 159},   //infact_uart_RxTx_item_c_inst.payload
    {6, 16},   //infact_uart_RxTx_item_c_inst.delay
    {5, 0},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 255},   //infact_uart_RxTx_item_c_inst.payload
    {6, 13},   //infact_uart_RxTx_item_c_inst.delay
    {5, 0},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 1},   //infact_uart_RxTx_item_c_inst.payload
    {6, 9},   //infact_uart_RxTx_item_c_inst.delay
    {5, 1},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 1},   //infact_uart_RxTx_item_c_inst.payload
    {6, 1},   //infact_uart_RxTx_item_c_inst.delay
    {5, 0},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 14},   //infact_uart_RxTx_item_c_inst.payload
    {6, 18},   //infact_uart_RxTx_item_c_inst.delay
    {5, 1},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 254},   //infact_uart_RxTx_item_c_inst.payload
    {6, 13},   //infact_uart_RxTx_item_c_inst.delay
    {5, 0},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 31},   //infact_uart_RxTx_item_c_inst.payload
    {6, 10},   //infact_uart_RxTx_item_c_inst.delay
    {5, 0},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
    {3, 0},   //do_item(infact_uart_RxTx_item_c_inst).begin
    {7, 254},   //infact_uart_RxTx_item_c_inst.payload
    {6, 12},   //infact_uart_RxTx_item_c_inst.delay
    {5, 1},   //infact_uart_RxTx_item_c_inst.kind
    {2, 0},   //infact_uart_RxTx_item_c_inst.do_RxTx
    {1, 0},   //do_item(infact_uart_RxTx_item_c_inst).end
    {0, 0},   //infact_checkcov
};
/**
 * Information about all test engines supported by this component
 */
static infact_sdv_engine_info prv_engine_info[] = {
  {
    "infact_uart_RxTx",
    infact_uart_RxTx_action_info,
    sizeof(infact_uart_RxTx_action_info)/sizeof(infact_sdv_action_info),
    infact_uart_RxTx_action_invoke,
    sizeof(infact_uart_RxTx_action_invoke)/sizeof(infact_sdv_action_invoke)
  }
};


/****************************************************************************
 * Implementation Methods
 ****************************************************************************/

/********************************************************************
 * strmatch()
 ********************************************************************/
static int32_t strmatch(
    const char *s1,
    const char *s2) {
  int32_t s1_len = strlen(s1);
  int32_t i;
  int32_t res = 0;
  if(s1_len != strlen(s2)) {
    return res;
  }
  res = 1;
  for(i=0; i < s1_len; i++) {
    if(s1[i] != s2[i]) {
      res &= 0;
    }
  }
  return res;
}



/********************************************************************
 * find_action()
 ********************************************************************/
static int32_t find_action(
  infact_sdv_action_info    *action_info,
  uint32_t          num_actions,
  const char          *name,
  infact_sdv_action_t     action_type)
{
  int32_t idx = -1;
  uint32_t i;

  for (i=0; i<num_actions; i++) {
    if (action_info[i].action_type == action_type &&
      strmatch(name, action_info[i].name)) {
      idx = i;
      break;
    }
  }

  return idx;
}

/********************************************************************
 * register_action_func()
 ********************************************************************/
static void infact_uart_RxTx_static_register_action_func(
    infact_sdv_te         *te,
    const char            *name,
    infact_sdv_action_func_ptr    fp,
    void              *ud)
{
  //printf("> infact_uart_RxTx_static_register_action_func(%s)\n", name);
  infact_sdv_static_te *te_prv = (infact_sdv_static_te *)te->m_prv_data;
  int32_t idx;

  idx = find_action(
    te_prv->info->action_info,
    te_prv->info->num_actions,
    name,
    INFACT_SDV_ACTION);

  if (idx != -1) {
    te_prv->closures[idx].m_fp.action = fp;
    te_prv->closures[idx].m_ud = ud;
  }
}

/********************************************************************
 * register_signed_meta_action_func()
 ********************************************************************/
static void infact_uart_RxTx_static_register_signed_meta_action_func(
    infact_sdv_te             *te,
    const char                *name,
    infact_sdv_signed_meta_action_func_ptr  fp,
    void                  *ud)
{
  infact_sdv_static_te *te_prv = (infact_sdv_static_te *)te->m_prv_data;
  int32_t idx;

  idx = find_action(
    te_prv->info->action_info,
    te_prv->info->num_actions,
    name,
    INFACT_SDV_SIGNED_META_ACTION);

  if (idx != -1) {
    te_prv->closures[idx].m_fp.signed_meta_action = fp;
    te_prv->closures[idx].m_ud = ud;
  }
}

/********************************************************************
 * register_unsigned_meta_action_func()
 ********************************************************************/
static void infact_uart_RxTx_static_register_unsigned_meta_action_func(
    infact_sdv_te             *te,
    const char                *name,
    infact_sdv_unsigned_meta_action_func_ptr  fp,
    void                  *ud)
{
  infact_sdv_static_te *te_prv = (infact_sdv_static_te *)te->m_prv_data;
  int32_t idx;

  idx = find_action(
    te_prv->info->action_info,
    te_prv->info->num_actions,
    name,
    INFACT_SDV_UNSIGNED_META_ACTION);

  if (idx != -1) {
    te_prv->closures[idx].m_fp.unsigned_meta_action = fp;
    te_prv->closures[idx].m_ud = ud;
  }
}

/********************************************************************
 * register_signed_meta_action_import_func()
 ********************************************************************/
static void infact_uart_RxTx_static_register_signed_meta_action_import_func(
    infact_sdv_te             *te,
    const char                *name,
    infact_sdv_signed_meta_action_import_func_ptr fp,
    void                  *ud)
{
  infact_sdv_static_te *te_prv = (infact_sdv_static_te *)te->m_prv_data;
  int32_t idx;

  idx = find_action(
    te_prv->info->action_info,
    te_prv->info->num_actions,
    name,
    INFACT_SDV_UNSIGNED_META_ACTION_IMPORT);

  if (idx != -1) {
    te_prv->closures[idx].m_fp.signed_meta_action_import = fp;
    te_prv->closures[idx].m_ud = ud;
  }
}

/********************************************************************
 * register_unsigned_meta_action_import_func()
 ********************************************************************/
static void infact_uart_RxTx_static_register_unsigned_meta_action_import_func(
    infact_sdv_te             *te,
    const char                *name,
    infact_sdv_unsigned_meta_action_import_func_ptr fp,
    void                  *ud)
{
  infact_sdv_static_te *te_prv = (infact_sdv_static_te *)te->m_prv_data;
  int32_t idx;

  idx = find_action(
    te_prv->info->action_info,
    te_prv->info->num_actions,
    name,
    INFACT_SDV_UNSIGNED_META_ACTION_IMPORT);

  if (idx != -1) {
    te_prv->closures[idx].m_fp.unsigned_meta_action_import = fp;
    te_prv->closures[idx].m_ud = ud;
  }
}

/********************************************************************
 * run()
 ********************************************************************/
static void infact_uart_RxTx_static_run(infact_sdv_te *te) {
  uint32_t i, id;
  int64_t tmp_s;
  uint64_t tmp_u;
  infact_sdv_static_te *te_prv = (infact_sdv_static_te *)te->m_prv_data;
  const uint32_t num_action_invokes = te_prv->info->num_action_invokes;
  infact_sdv_action_invoke *action_invoke = te_prv->info->action_invoke;
  infact_sdv_action_info *action_info = te_prv->info->action_info;
  infact_sdv_action_closure *closures = te_prv->closures;

  //printf("> infact_uart_RxTx_static_run()\n");
  //printf("num_action_invokes=%d\n", num_action_invokes);
  for (i=0; i<num_action_invokes; i++) {
    id = action_invoke[i].id;
    //printf("Processing sw action: %s, id=%d, index=%d\n", sdv_uvm_smoke_eng_action_info[id].name, id, i);
    // Ignore unregistered action functions
    if (!closures[id].m_fp.action) {
      //printf("Ignoring unregistered action %s\n", sdv_uvm_smoke_eng_action_info[id].name);
      continue;
    }
    switch (action_info[id].action_type) {
      case INFACT_SDV_ACTION:
        //printf("Executing action %s\n", sdv_uvm_smoke_eng_action_info[id].name);
        closures[id].m_fp.action(closures[id].m_ud);
        break;
      case INFACT_SDV_SIGNED_META_ACTION:
        //printf("Executing signed meta action %s\n", sdv_uvm_smoke_eng_action_info[id].name);
        closures[id].m_fp.signed_meta_action(
          closures[id].m_ud, action_invoke[i].val);
        break;
      case INFACT_SDV_UNSIGNED_META_ACTION:
        //printf("Executing unsigned meta action %s\n", sdv_uvm_smoke_eng_action_info[id].name);
        closures[id].m_fp.unsigned_meta_action(
          closures[id].m_ud, action_invoke[i].val);
        break;
      case INFACT_SDV_SIGNED_META_ACTION_IMPORT:
        //printf("Executing signed meta action import %s\n", sdv_uvm_smoke_eng_action_info[id].name);
        tmp_s = action_invoke[i].val;
        closures[id].m_fp.signed_meta_action_import(
          closures[id].m_ud, &tmp_s);
        break;
      case INFACT_SDV_UNSIGNED_META_ACTION_IMPORT:
        //printf("Executing unsigned meta action import %s\n", sdv_uvm_smoke_eng_action_info[id].name);
        tmp_u = action_invoke[i].val;
        closures[id].m_fp.unsigned_meta_action_import(
          closures[id].m_ud, &tmp_u);
        break;
    }
  }
  //printf("< infact_uart_RxTx_static_run()\n");
}

/********************************************************************
 * register_test_engine()
 ********************************************************************/
static infact_sdv_te *infact_uart_RxTx_static_register_test_engine(
    infact_sdv_te_mgr *te_mgr,
    const char      *automaton_name,
    const char      *instance_name,
    const char      *module_name,
    uint32_t      number_of_parameters,
    const char      *parameters)
{
  uint32_t i;
  uint32_t n_engines = sizeof(prv_engine_info)/sizeof(infact_sdv_engine_info);
  infact_sdv_te *te;
  infact_sdv_static_te *te_prv;

  // Search for this engine
  for (i=0; i<n_engines; i++) {
    if (strmatch(automaton_name, prv_engine_info[i].name)) {
      break;
    }
  }

  if (i >= n_engines) {
    // Failed to find the engine
    return 0;
  }

  te = (infact_sdv_te *)malloc(sizeof(infact_sdv_te));
  te->m_te_mgr = te_mgr;
  te->register_action_func = &infact_uart_RxTx_static_register_action_func;
  te->register_signed_meta_action_func = &infact_uart_RxTx_static_register_signed_meta_action_func;
  te->register_unsigned_meta_action_func = &infact_uart_RxTx_static_register_unsigned_meta_action_func;
  te->register_signed_meta_action_import_func = &infact_uart_RxTx_static_register_signed_meta_action_import_func;
  te->register_unsigned_meta_action_import_func = &infact_uart_RxTx_static_register_unsigned_meta_action_import_func;
  te->run = &infact_uart_RxTx_static_run;

  te_prv =  (infact_sdv_static_te *)malloc(sizeof(infact_sdv_static_te));
  te_prv->info = &prv_engine_info[i];
  te_prv->closures = (infact_sdv_action_closure *)malloc(
    sizeof(infact_sdv_action_closure)*prv_engine_info[i].num_actions);
  memset(te_prv->closures, 0,
    sizeof(infact_sdv_action_closure)*prv_engine_info[i].num_actions);
  te_prv->invoke_idx = 0;
  te->m_prv_data = te_prv;

  return te;
}

int infact_uart_RxTx_static_init(
    infact_sdv_te_mgr   *te_mgr)
{
  te_mgr->register_test_engine = &infact_uart_RxTx_static_register_test_engine;
  return 0;
}

#ifdef UNDEFINED
//<trashcan,gen>
//</trashcan>
#endif

