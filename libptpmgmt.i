/* SPDX-License-Identifier: LGPL-3.0-or-later
   SPDX-FileCopyrightText: Copyright 2021 Erez Geva */

/* Library Swig header file
 *
 * @author Erez Geva <ErezGeva2@@gmail.com>
 * @copyright 2021 Erez Geva
 *
 */

/* Module name */
#ifdef SWIGPERL
%module PtpMgmtLib  /* Perl only */
#else
%module ptpmgmt
#endif /* SWIGPERL */

/* Headers and namespace for moudle source code */
%{
    #include "sock.h"
    #include "json.h"
    #include "ver.h"
    #include "init.h"
    #include "msgCall.h"
    using namespace ptpmgmt;
%}

/* Handle multithreads support */
#ifdef SWIG_USE_MULTITHREADS
%nothread;
#define SWIG_THREAD_START %thread
#define SWIG_THREAD_END %nothread
#endif

/* Include standatd types and SWIG macroes */
/* From /usr/share/swig./ */
%include "stdint.i"
%include "cpointer.i"
/* From /usr/share/swig././  */
%include "std_string.i"
%include "std_vector.i"
%include "argcargv.i"
/* The type is POSIX only, not standard! */
%apply long { ssize_t };
/* initialize variables for argcargv
 * Bug fix in SWIG 4.1 */
%typemap(arginit) (int ARGC, char **ARGV){$1 = 0; $2 = nullptr;}
/* Support Options::parse_options in scripts */
%apply (int ARGC, char **ARGV) {(int argc, char *const argv[])}

/*************************************************************************
 * Handle ignores and renames per script language.
 * Users of a script language should look here
 *  for the specific ignores and renames.
 * Each ignored operator overlaod have an alternative function
 * Warn codes defined in: swig/Source/Include/swigwarn.h
 *   SWIGWARN_PARSE_KEYWORD          314
 *   SWIGWARN_TYPE_UNDEFINED_CLASS   401
 *   SWIGWARN_IGNORE_OPERATOR_PLUSEQ 365
 *   SWIGWARN_LANG_IDENTIFIER        503
 *   SWIGWARN_LANG_OVERLOAD_SHADOW   509
 *   SWIGWARN_RUBY_WRONG_NAME        801
 ************************************************************************/
/*****
 * Ruby
 *********/
#ifdef SWIGRUBY
/* Ignore Wrong constant name.
 * Ruby capitalize first letter! */
%warnfilter(SWIGWARN_RUBY_WRONG_NAME) clockType_e;
%warnfilter(SWIGWARN_RUBY_WRONG_NAME) implementSpecific_e;
/* Operator overload ignored.
 * Scripts can use Binary::append() */
%warnfilter(SWIGWARN_IGNORE_OPERATOR_PLUSEQ) Binary::operator+=;
#endif /* SWIGRUBY */
/*****
 * PHP
 *********/
#ifdef SWIGPHP
/* PHP rename to c_empty */
%warnfilter(SWIGWARN_PARSE_KEYWORD) Binary::empty;
/* PHP rename to c_list */
#define _ptpmList(n) %warnfilter(SWIGWARN_PARSE_KEYWORD) n::list;
_ptpmList(ACCEPTABLE_MASTER_TABLE_t)
_ptpmList(SLAVE_RX_SYNC_TIMING_DATA_t)
_ptpmList(SLAVE_RX_SYNC_COMPUTED_DATA_t)
_ptpmList(SLAVE_TX_EVENT_TIMESTAMPS_t)
_ptpmList(SLAVE_DELAY_TIMING_DATA_NP_t)
_ptpmList(SLAVE_RX_SYNC_TIMING_DATA_t)
/* PHP rename c_interface */
%warnfilter(SWIGWARN_PARSE_KEYWORD) PORT_PROPERTIES_NP_t::interface;
/* Operator overload ignored.
 * Scripts can use Binary::append() */
%warnfilter(SWIGWARN_LANG_IDENTIFIER) Binary::operator+=;
#define SWIG_OPERS_LANG_IDENTIFIER
#endif /* SWIGPHP */
/*****
 * Tcl
 *********/
#ifdef SWIGTCL
/* Operator overload ignored.
 * Scripts can use Binary::append() */
%warnfilter(SWIGWARN_IGNORE_OPERATOR_PLUSEQ) Binary::operator+=;
#define SWIG_OPERS_LANG_IDENTIFIER
#endif /* SWIGTCL */
/*****
 * PHP and Tcl ignore operators overload
 *********/
#ifdef SWIG_OPERS_LANG_IDENTIFIER
/* Operator overload ignored.
 * Scripts can use Buf::get() */
%warnfilter(SWIGWARN_LANG_IDENTIFIER) Buf::operator();
/* Operator overload ignored.
 * Scripts can use class eq() method */
%warnfilter(SWIGWARN_LANG_IDENTIFIER) Binary::operator==;
%warnfilter(SWIGWARN_LANG_IDENTIFIER) ClockIdentity_t::operator==;
%warnfilter(SWIGWARN_LANG_IDENTIFIER) PortIdentity_t::operator==;
%warnfilter(SWIGWARN_LANG_IDENTIFIER) PortAddress_t::operator==;
%warnfilter(SWIGWARN_LANG_IDENTIFIER) ClockTime::operator==;
/* Operator overload ignored.
 * Scripts can use class less() method */
%warnfilter(SWIGWARN_LANG_IDENTIFIER) Binary::operator<;
%warnfilter(SWIGWARN_LANG_IDENTIFIER) ClockIdentity_t::operator<;
%warnfilter(SWIGWARN_LANG_IDENTIFIER) PortIdentity_t::operator<;
%warnfilter(SWIGWARN_LANG_IDENTIFIER) PortAddress_t::operator<;
%warnfilter(SWIGWARN_LANG_IDENTIFIER) ClockTime::operator<;
/* Operator overload ignored.
 * Scripts can use class add() method */
%warnfilter(SWIGWARN_LANG_IDENTIFIER) ClockTime::operator+;
/* Operator overload ignored.
 * Scripts can use class subt() method */
%warnfilter(SWIGWARN_LANG_IDENTIFIER) ClockTime::operator-;
#endif /* SWIG_OPERS_LANG_IDENTIFIER */

/* Mark base sockets as non-abstract classes */
%feature("notabstract") SockBase;
%feature("notabstract") SockBaseIf;
/* library code */
%include "cfg.h"
%include "ptp.h"
%include "sock.h"
%include "bin.h"
%include "buf.h"
%include "types.h"
%include "mngIds.h" /* Add Management TLVs enumerator */
%include "proc.h"
%include "sig.h"
%include "msg.h"
%include "json.h"
%include "ver.h"
%include "opt.h"
%include "init.h"
/* Handle management vectors inside structures
 * See documenting of XXXX_v classes in mngIds.h and
 *  Doxygen generated documents
 */
#define _ptpmMkVec(n) %template(n##_v) std::vector<n##_t>
_ptpmMkVec(FaultRecord);
_ptpmMkVec(ClockIdentity);
_ptpmMkVec(PortAddress);
_ptpmMkVec(AcceptableMaster);
_ptpmMkVec(LinuxptpUnicastMaster);
_ptpmMkVec(PtpEvent);
/* Handle signalig vectors inside structures
 * See documenting of SigXXXX classes in mngIds.h and
 *  Doxygen generated documents
 */
#define _ptpmMkRecVec(n, m) %template(n) std::vector<m##_rec_t>
_ptpmMkRecVec(SigTime, SLAVE_RX_SYNC_TIMING_DATA);
_ptpmMkRecVec(SigComp, SLAVE_RX_SYNC_COMPUTED_DATA);
_ptpmMkRecVec(SigEvent, SLAVE_TX_EVENT_TIMESTAMPS);
_ptpmMkRecVec(SigDelay, SLAVE_DELAY_TIMING_DATA_NP);
/* convert base management tlv to a specific management tlv structure
 * See documenting of conv_XXX functions in mngIds.h and
 *  Doxygen generated documents
 */
#define _ptpmCaseUF(n) %pointer_cast(BaseMngTlv*, n##_t*, conv_##n);
#define A(n, v, sc, a, sz, f) _ptpmCase##f(n)
%include "ids.h"
/* convert base signaling tlv to a specific signaling tlv structure
 * See documenting of conv_XXX functions in mngIds.h and
 *  Doxygen generated documents
 */
#define _ptpmSigCnv(n) %pointer_cast(BaseSigTlv*, n##_t*, conv_##n);
_ptpmSigCnv(ORGANIZATION_EXTENSION)
_ptpmSigCnv(PATH_TRACE)
_ptpmSigCnv(ALTERNATE_TIME_OFFSET_INDICATOR)
_ptpmSigCnv(ENHANCED_ACCURACY_METRICS)
_ptpmSigCnv(L1_SYNC)
_ptpmSigCnv(PORT_COMMUNICATION_AVAILABILITY)
_ptpmSigCnv(PROTOCOL_ADDRESS)
_ptpmSigCnv(SLAVE_RX_SYNC_TIMING_DATA)
_ptpmSigCnv(SLAVE_RX_SYNC_COMPUTED_DATA)
_ptpmSigCnv(SLAVE_TX_EVENT_TIMESTAMPS)
_ptpmSigCnv(CUMULATIVE_RATE_RATIO)
_ptpmSigCnv(SLAVE_DELAY_TIMING_DATA_NP)
%include "msgCall.i"
