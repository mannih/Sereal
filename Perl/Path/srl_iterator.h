#ifndef SRL_ITERATOR_H_
#define SRL_ITERATOR_H_

#include "EXTERN.h"
#include "perl.h"
#include "srl_reader_types.h"

typedef struct srl_stack * srl_stack_ptr;

/* the iterator main struct */
typedef struct {
    SRL_READER_STRUCT;
    srl_stack_ptr stack;
    UV first_tag_offset;
    SV *tmp_buf_owner;
}  srl_iterator_t;

srl_iterator_t *srl_build_iterator_struct(pTHX_ HV *opt);         /* constructor from options */
void srl_destroy_iterator(pTHX_ srl_iterator_t *iter);            /* explicit destructor */

void srl_set_document(pTHX_ srl_iterator_t *iter, SV *src);
void srl_reset(pTHX_ srl_iterator_t *iter);

UV srl_eof(pTHX_ srl_iterator_t *iter);
UV srl_next_n(pTHX_ srl_iterator_t *iter, UV next);
UV srl_step_n(pTHX_ srl_iterator_t *iter, UV step);
UV srl_parent(pTHX_ srl_iterator_t *iter);

UV srl_offset(pTHX_ srl_iterator_t *iter);
UV srl_object_count(pTHX_ srl_iterator_t *iter);
SV * srl_object_type(pTHX_ srl_iterator_t *iter);

IV srl_find_key(pTHX_ srl_iterator_t *iter, SV *name);
SV * srl_get_key(pTHX_ srl_iterator_t *iter);

SV * srl_decode(pTHX_ srl_iterator_t *iter);

#endif
