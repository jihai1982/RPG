000100110509     H*----------------------------------------------------------------------+
000200110509     H*  (c) Copyright IBM Corp. 2010 All rights reserved.                   |
000300110509     H*                                                                      |
000400110509     H*  This sample program is owned by International Business Machines     |
000500110509     H*  Corporation or one of its subsidiaries ("IBM") and is copyrighted   |
000600110509     H*  and licensed, not sold.                                             |
000700110509     H*                                                                      |
000800110509     H*  You may copy, modify, and distribute this sample program in any     |
000900110509     H*  form without payment to IBM,  for any purpose including developing, |
001000110509     H*  using, marketing or distributing programs that include or are       |
001100110509     H*  derivative works of the sample program. Licenses to IBM patents     |
001200110509     H*  are expressly excluded from this license.                           |
001300110509     H*  The sample program is provided to you on an "AS IS" basis, without  |
001400110509     H*  warranty of any kind.  IBM HEREBY  EXPRESSLY DISCLAIMS ALL          |
001500110509     H*  WARRANTIES EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO |
001600110509     H*  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTIC- |
001700110509     H*  ULAR PURPOSE. Some jurisdictions do not allow for the exclusion or  |
001800110509     H*  limitation of implied warranties, so the above limitations or       |
001900110509     H*  exclusions may not apply to you.  IBM shall not be liable for any   |
002000110509     H*  damages you suffer as a result of using, modifying or distributing  |
002100110509     H*  the sample program or its derivatives.                              |
002200110509     H*                                                                      |
002300110509     H*  Each copy of any portion of this sample program or any derivative   |
002400110509     H*  work,  must include a the above copyright notice and disclaimer of  |
002500110509     H*  warranty.                                                           |
002600110509     H*                                                                      |
002700110509     H*----------------------------------------------------------------------+
002800110509     H ACTGRP('QILE')DFTACTGRP(*NO)
002900110509     H CVTOPT(*DATETIME)
003000110509     H DATFMT(*ISO)
003100110509     H ALWNULL(*USRCTL)
003200110509
003300110514     FEMPADDRSL1UF   E           K DISK
003400110509      //-------------------Rational Open Access Addition ----------------------
003500110509      // The handler keyword specifies the program/service program which will
003600110509      // now process the IO operations for this file
003700110510     F                                     handler('UPDHANDLER')
003800110509      //-----------------------------------------------------------------------
003900110509
004000110509     D i               S              5i 0
004100110509
004200110509     D*--------------------------------------------------
004300110510     D* Procedure name: UPDCHAIN
004400110509     D* Purpose:        Used to test the use of CHAIN for update
004500110509     D*                 This module uses the following RPG ops:
004600110509     D*                 CHAIN,  UPDATE,
004700110509     D*--------------------------------------------------
004800110510     D UPDCHAIN        PR
004900110514     D p_ADDRLINE1                   30    Varying
005000110514     D p_ADDRLINE2                         LIKE(p_ADDRLINE1)
005100110514     D p_ADDRLINE3                         LIKE(p_ADDRLINE1)
005200110514     D p_CITY                        15    Varying
005300110514     D p_STATE                       10    Varying
005400110514     D p_ZIPCODE                     10    Varying
005500110509     D p_EMPNO                             LIKE(EMPNO)
005600110509      //The following indicator array is passed based on parameter style
005700110509      // GENERAL WITH NULLS
005800110509     D p_Ind_Ary...
005900110514     D                                5i 0 DIM(7)
006000110509
006100110510     D UPDCHAIN        PI
006200110514     D p_ADDRLINE1                   30    Varying
006300110514     D p_ADDRLINE2                         LIKE(p_ADDRLINE1)
006400110514     D p_ADDRLINE3                         LIKE(p_ADDRLINE1)
006500110514     D p_CITY                        15    Varying
006600110514     D p_STATE                       10    Varying
006700110514     D p_ZIPCODE                     10    Varying
006800110509     D p_EMPNO                             LIKE(EMPNO)
006900110509     D p_Ind_Ary...
007000110514     D                                5i 0 DIM(7)
007100110514
007200110514     D inpRecord       Ds                  LIKEREC(EMPADDR:*INPUT)
007500110514
007600110509      /Free
007700110510       Monitor;
007800110510
007900110514        CHAIN(e) p_EMPNO  EMPADDRSL1 inpRecord;
008000110510        If %Found;
008100110510
008200110604          If p_Ind_Ary(1) = *Zero;
008300110604            inpRecord.ADDRLINE1 = p_ADDRLINE1;
008400110604          ENDIF;
008500110604          If p_Ind_Ary(2) = *Zero;
008600110604            inpRecord.ADDRLINE2 = p_ADDRLINE2;
008700110604          ENDIF;
008800110604          If p_Ind_Ary(3) = *Zero;
008900110604            inpRecord.ADDRLINE3 = p_ADDRLINE3;
009000110604          ENDIF;
009100110604          If p_Ind_Ary(4) = *Zero;
009200110604            inpRecord.CITY = p_CITY;
009300110604          ENDIF;
009400110604          If p_Ind_Ary(5) = *Zero;
009500110604            inpRecord.STATE = p_STATE;
009600110604          ENDIF;
009700110604          If p_Ind_Ary(6) = *Zero;
009800110604            inpRecord.ZIPCODE = p_ZIPCODE;
009900110604          ENDIF;
010000110514
010100110604          inpRecord.EMPNO = p_EMPNO;
010200110514
010300110604          Update(E) EMPADDR inpRecord;
010400110514
010500110510        ENDIF;
010600110514
010700110510       On-Error;
010800110510       ENDMON;
010900110510
011000110509       *INLR = *On;
011100110509       Return;
011200110509
011300110509      /End-Free
011400110509
011500110509
