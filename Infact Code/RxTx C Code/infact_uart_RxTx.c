/****************************************************************************
 *                          infact_uart_RxTx.c
 *
 * Copyright 2012 Mentor Graphics Corporation. All Rights Reserved
 ****************************************************************************/
#include "infact_uart_RxTx.h"
#include <stdlib.h>
#include <string.h>


// SDV: Test-specific include

//<sw_user_data,gen>

//</sw_user_data>

//*******************************************************************
//* Action Methods
//*******************************************************************
//<action_methods>

//<action::infact_uart_RxTx_infact_checkcov::()>
//***************************************************************
// Action infact_checkcov
//***************************************************************
static void action_infact_checkcov(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
  (void) fields;
}
//</action::infact_uart_RxTx_infact_checkcov::()>



//<action::infact_uart_RxTx_init::()>
//***************************************************************
// Action init
//***************************************************************
static void action_init(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
  (void) fields;
}
//</action::infact_uart_RxTx_init::()>

















//<action::infact_uart_RxTx_do_item__infact_uart_RxTx_item_c_inst__end::()>
//***************************************************************
// Action do_item__infact_uart_RxTx_item_c_inst__end
//***************************************************************
static void action_do_item__infact_uart_RxTx_item_c_inst__end(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
  (void) fields;
}
//</action::infact_uart_RxTx_do_item__infact_uart_RxTx_item_c_inst__end::()>


//<action::infact_uart_RxTx_do_item__infact_uart_RxTx_item_c_inst__begin::()>
//***************************************************************
// Action do_item__infact_uart_RxTx_item_c_inst__begin
//***************************************************************
static void action_do_item__infact_uart_RxTx_item_c_inst__begin(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
  (void) fields;
}
//</action::infact_uart_RxTx_do_item__infact_uart_RxTx_item_c_inst__begin::()>
//<signed_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__delay::()>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__delay
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__delay(void *ud, int64_t meta_val)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    fields->infact_uart_RxTx_item_c_inst.delay = meta_val;
      (void) fields;
}
//</signed_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__delay::()>
//<unsigned_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__payload::()>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__payload
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__payload(void *ud, uint64_t meta_val)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    fields->infact_uart_RxTx_item_c_inst.payload = meta_val;
      (void) fields;
}
//</unsigned_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__payload::()>




//<signed_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__kind::()>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__kind
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__kind(void *ud, int64_t meta_val)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    fields->infact_uart_RxTx_item_c_inst.kind = meta_val;
      (void) fields;
}
//</signed_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__kind::()>


//<action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__do_RxTx::(##457b5f5a7d3f445a9c7524c43eeee046)>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__do_RxTx
//* sw_action_stmt = do_RxTx(fields->infact_uart_RxTx_item_c_inst.payload, fields->infact_uart_RxTx_item_c_inst.kind, fields->infact_uart_RxTx_item_c_inst.delay);
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__do_RxTx(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    do_RxTx(fields->infact_uart_RxTx_item_c_inst.payload, fields->infact_uart_RxTx_item_c_inst.kind, fields->infact_uart_RxTx_item_c_inst.delay);
  (void) fields;
}
//</action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__do_RxTx::(##457b5f5a7d3f445a9c7524c43eeee046)>
//</action_methods>

//<create_engines,gen>
/********************************************************************
 * infact_uart_RxTx_create_engines()
********************************************************************/
static void infact_uart_RxTx_create_engines(
    infact_uart_RxTx_t  *comp,
    const char        *inst_name
    infact_uart_RxTx_GRAPH_PARAMS)
{
    infact_sdv_te_mgr *te_mgr = comp->te_mgr;
    {
        infact_sdv_te *te;
        te = te_mgr->register_test_engine(
                te_mgr,
                "infact_uart_RxTx",
                inst_name,
                "infact_uart_RxTx",
                0,
                "" /* TODO: parameters */);
        comp->te = te;
        // Register action methods
        te->register_action_func(
           te,
           "infact_checkcov",
           &action_infact_checkcov,
           comp);
        te->register_action_func(
           te,
           "do_item(infact_uart_RxTx_item_c_inst).end",
           &action_do_item__infact_uart_RxTx_item_c_inst__end,
           comp);
        te->register_action_func(
           te,
           "infact_uart_RxTx_item_c_inst.do_RxTx",
           &action_infact_uart_RxTx_item_c_inst__do_RxTx,
           comp);
        te->register_action_func(
           te,
           "do_item(infact_uart_RxTx_item_c_inst).begin",
           &action_do_item__infact_uart_RxTx_item_c_inst__begin,
           comp);
        te->register_action_func(
           te,
           "init",
           &action_init,
           comp);
        te->register_signed_meta_action_func(
           te,
           "infact_uart_RxTx_item_c_inst.kind",
           &action_infact_uart_RxTx_item_c_inst__kind,
           comp);
        te->register_signed_meta_action_func(
           te,
           "infact_uart_RxTx_item_c_inst.delay",
           &action_infact_uart_RxTx_item_c_inst__delay,
           comp);
        te->register_unsigned_meta_action_func(
           te,
           "infact_uart_RxTx_item_c_inst.payload",
           &action_infact_uart_RxTx_item_c_inst__payload,
           comp);
    }
}

//</create_engines>

//<run_engines,gen>
/********************************************************************
 * infact_uart_RxTx_run_engines()
 ********************************************************************/
static void infact_uart_RxTx_run_engines(infact_uart_RxTx_t *comp)
{
  // TODO: generated code must spawn additional threads is required
  comp->te->run(comp->te);
}

//</run_engines>


/********************************************************************
 * infact_uart_RxTx_create()
 ********************************************************************/
infact_uart_RxTx_t *infact_uart_RxTx_create(
    infact_sdv_te_mgr       *te_mgr,
    const char          *inst_name
    infact_uart_RxTx_GRAPH_PARAMS)
{
  infact_uart_RxTx_t *comp =
      (infact_uart_RxTx_t *) malloc(
          sizeof(infact_uart_RxTx_t));
  memset(comp,
      0,
      sizeof(infact_uart_RxTx_t));
  comp->te_mgr = te_mgr;
  infact_uart_RxTx_create_engines(
      comp,
      inst_name infact_uart_RxTx_GRAPH_PARAMS);
  return comp;
}

/********************************************************************
 * infact_uart_RxTx_run()
 ********************************************************************/
void infact_uart_RxTx_run(infact_uart_RxTx_t *comp)
{
  infact_uart_RxTx_run_engines(comp);
}

/********************************************************************
 * infact_uart_RxTx_delete()
 ********************************************************************/
void infact_uart_RxTx_delete(infact_uart_RxTx_t *comp)
{
  // TODO: delete engines

  free(comp);
}

#ifdef UNDEFINED
//<trashcan,gen>
//<action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##2038a7e37f2a93a3eacc353b68866df3)>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__set_val
//* sw_action_stmt = set_val(fields->scen_eng.payload, fields->scen_eng.kind)
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__set_val(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    set_val(fields->scen_eng.payload, fields->scen_eng.kind)
  (void) fields;
}
//</action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##2038a7e37f2a93a3eacc353b68866df3)>
//<action::infact_uart_RxTx_set_val::(##2dec9fb36cf4061392f98d54e748d956)>
//***************************************************************
// Action set_val
//* action_stmt = do_RxTx(${payload},${kind});
//***************************************************************
static void action_set_val(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
  (void) fields;
}
//</action::infact_uart_RxTx_set_val::(##2dec9fb36cf4061392f98d54e748d956)>
//<action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##2dec9fb36cf4061392f98d54e748d956)>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__set_val
//* action_stmt = do_RxTx(${payload},${kind});
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__set_val(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
  (void) fields;
}
//</action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##2dec9fb36cf4061392f98d54e748d956)>
//<action::infact_uart_RxTx_rxtx::()>
//***************************************************************
// Action rxtx
//***************************************************************
static void action_rxtx(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
  (void) fields;
}
//</action::infact_uart_RxTx_rxtx::()>
//<action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##3acd5bec93eaadfe443ffcf5af590c32)>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__set_val
//* action_stmt = do_RxTx(${payload},${kind});
//* sw_action_stmt = set_val(fields->scen_eng.payload, fields->scen_eng.kind)
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__set_val(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    set_val(fields->scen_eng.payload, fields->scen_eng.kind)
  (void) fields;
}
//</action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##3acd5bec93eaadfe443ffcf5af590c32)>
//<action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##bcd3df2e9f86c1d93a1a482205bc92bc)>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__set_val
//* action_stmt = do_RxTx(${payload},${kind});
//* sw_action_stmt = infact_uart_RxTx_item(fields->scen_eng.payload, fields->scen_eng.kind);
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__set_val(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    infact_uart_RxTx_item(fields->scen_eng.payload, fields->scen_eng.kind);
  (void) fields;
}
//</action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##bcd3df2e9f86c1d93a1a482205bc92bc)>
//<action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##a6eaf1775f138f2dc3d17035fc317804)>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__set_val
//* action_stmt = do_RxTx(${payload},${kind});
//* sw_action_stmt = set_val(fields->nfact_uart_RxTx_item.payload, fields->nfact_uart_RxTx_item.kind);
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__set_val(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    set_val(fields->infact_uart_RxTx_item.payload, fields->infact_uart_RxTx_item.kind);
  (void) fields;
}
//</action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##a6eaf1775f138f2dc3d17035fc317804)>
//<action::infact_uart_RxTx_set_val::(##ce0859f09d7952a794268b01ef645e07)>
//***************************************************************
// Action set_val
//* sw_action_stmt = set_val(fields->infact_uart_RxTx_item_c_inst.payload, fields->infact_uart_RxTx_item_c_inst.kind);
//***************************************************************
static void action_set_val(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    set_val(fields->infact_uart_RxTx_item_c_inst.payload, fields->infact_uart_RxTx_item_c_inst.kind);
  (void) fields;
}
//</action::infact_uart_RxTx_set_val::(##ce0859f09d7952a794268b01ef645e07)>
//<action::infact_uart_RxTx_set_val::(##f1f17b95ef08381211d172523358396c)>
//***************************************************************
// Action set_val
//* sw_action_stmt = do_RxTx(${payload},${kind});
//***************************************************************
static void action_set_val(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    do_RxTx(${payload},${kind});
  (void) fields;
}
//</action::infact_uart_RxTx_set_val::(##f1f17b95ef08381211d172523358396c)>
//<action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##54cdbab3e3a2ef69ce112a064218be10)>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__set_val
//* sw_action_stmt = do_RxTx(fields->infact_uart_RxTx_item_c_inst.payload, fields->infact_uart_RxTx_item_c_inst.kind);
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__set_val(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    do_RxTx(fields->infact_uart_RxTx_item_c_inst.payload, fields->infact_uart_RxTx_item_c_inst.kind);
  (void) fields;
}
//</action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__set_val::(##54cdbab3e3a2ef69ce112a064218be10)>
//<signed_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__stop_type::(##c32e5e6aacad4823a6fd7ba7ae0b9a15)>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__stop_type
//* field_type = stop_e
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__stop_type(void *ud, int64_t meta_val)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    fields->infact_uart_RxTx_item_c_inst.stop_type = meta_val;
  (void) fields;
}
//</signed_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__stop_type::(##c32e5e6aacad4823a6fd7ba7ae0b9a15)>
//<unsigned_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__stop_bits::()>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__stop_bits
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__stop_bits(void *ud, uint64_t meta_val)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    fields->infact_uart_RxTx_item_c_inst.stop_bits = meta_val;
      (void) fields;
}
//</unsigned_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__stop_bits::()>
//<unsigned_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__start_bit::()>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__start_bit
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__start_bit(void *ud, uint64_t meta_val)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    fields->infact_uart_RxTx_item_c_inst.start_bit = meta_val;
      (void) fields;
}
//</unsigned_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__start_bit::()>
//<signed_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__kind::(##a4db201001c621c4873eb986c594047b)>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__kind
//* field_type = kind_e
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__kind(void *ud, int64_t meta_val)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    fields->infact_uart_RxTx_item_c_inst.kind = meta_val;
  (void) fields;
}
//</signed_meta_action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__kind::(##a4db201001c621c4873eb986c594047b)>
//<action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__do_RxTx::(##54cdbab3e3a2ef69ce112a064218be10)>
//***************************************************************
// Action infact_uart_RxTx_item_c_inst__do_RxTx
//* sw_action_stmt = do_RxTx(fields->infact_uart_RxTx_item_c_inst.payload, fields->infact_uart_RxTx_item_c_inst.kind);
//***************************************************************
static void action_infact_uart_RxTx_item_c_inst__do_RxTx(void *ud)
{
  infact_uart_RxTx_t *comp = (infact_uart_RxTx_t *)ud;
  infact_uart_RxTx_fields_t *fields = &comp->fields;
    do_RxTx(fields->infact_uart_RxTx_item_c_inst.payload, fields->infact_uart_RxTx_item_c_inst.kind);
  (void) fields;
}
//</action::infact_uart_RxTx_infact_uart_RxTx_item_c_inst__do_RxTx::(##54cdbab3e3a2ef69ce112a064218be10)>
//</trashcan>
#endif
