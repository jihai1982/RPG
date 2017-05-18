000100110203     H*noMain
000200101230     H ACTGRP('QILE')DFTACTGRP(*NO)
000300101230     H ALWNULL(*USRCTL)
000400110604     H CVTOPT(*DATETIME : *VARCHAR)
000500110510     H DATFMT(*ISO)
000600101231
000700110514     FrcdFile_t IF   E           K DISK    TEMPLATE
000800110514     F                                     EXTDESC('EMPADDRESS')
000900110514     F                                     RENAME(empAddr:rcdFormat)
001000110509
001100110514     D rcdFormat_t...
001200110514     D                 DS                  LIKEREC(rcdFormat)
001300110509     D                                     TEMPLATE
001400110509
001500110605     D keys_t          DS                  LIKEREC(rcdFormat:*KEY)
001600110605     D                                     TEMPLATE
001700110605
001800110605     D Ind_Array_t...
001900110605     D                 S              5i 0 DIM(7)
002000110605     D                                     TEMPLATE
002100110514
002101110605      //stateinfo data structure template
002200110531     D rpgSI_t...
002300110514     D                 DS                  TEMPLATE
002400110529     D  OLD_ROW_p                      *
002600110605     D stateInfo_t...
002700110605     D                 Ds                  TEMPLATE
002800110605     D                                     QUALIFIED
002900110605     D sqlRow                              LIKEDS(rcdFormat_t)
003000110511     D*--------------------------------------------------
003100110207     D*
003200110207     D* Procedure name: Handler_file_processing
003300110207     D* Purpose:        Defines a list of parameters passed by the system w...
003400110207     D*                          hen SPECIAL is used as the device type in RPG
003500110207     D* Returns:
003600110207     D*--------------------------------------------------
003700110510     D UPDHANDLER      PR
003800110531     D rpgIO...
003900110203     D                                     LIKEDS(QrnOpenAccess_T)
004000110203
004100110207     D*--------------------------------------------------
004200110207     D* Local procedures
004300110207     D*--------------------------------------------------
004400110207      //RPG Operation Handlers
004500110509
004600110531     D Handle_Open     PR                  LIKE(rpgIO.rpgStatus)
004700110531     D rpgIO...
004800110509     D                                     LIKEDS(QrnOpenAccess_T)
004900110509
005000110531     D Handle_Chain    PR                  LIKE(rpgIO.rpgStatus)
005100110531     D rpgIO...
005200110509     D                                     LIKEDS(QrnOpenAccess_T)
005300110208
005400110531     D Handle_Update   PR                  LIKE(rpgIO.rpgStatus)
005500110531     D rpgIO...
005600110509     D                                     LIKEDS(QrnOpenAccess_T)
005700110208
005800110531     D Handle_Close    PR                  LIKE(rpgIO.rpgStatus)
005900110531     D rpgIO...
006000110509     D                                     LIKEDS(QrnOpenAccess_T)
006100110531     D rpgIO_Open_One_Time_Inz...
006200110531     D                 PR                  LIKE(rpgIO.rpgStatus)
006300110510
006400110521     D Prepare_SQL_Statement...
006500110509     D                 PR              N
006600110509     D  SQL_String                10000     Varying
006700110509
006800110521     D Fetch_First_From_Open_SQL_Cursor...
006900110509     D                 PR              N
007000110514     D  p_EMPNO                              LIKE(rcdFormat_t.EMPNO)
007100110514     D  inputBuffer...
007200110509     D                                 *
007300110605     D  IndAry                        5i 0 DIM(%elem(Ind_Array_t))
007400110509
007500110528     D Update_Columns_Using_Extended_Indicators...
007600110509     D                 PR              N
007700110604     D  updRcd...
007800110514     D                                      LIKEDS(rcdFormat_t)
007900110509     D  Ind_Ary...
008000110605     D                                      LIKE(Ind_Array_t)
008100110605     D                                      DIM(%elem(Ind_Array_t))
008200110509     D*--------------------------------------------------
008300110509     D* External procedures
008400110509     D*--------------------------------------------------
008500110509     D Get_Key_Column_Names...
008600110509     D                 PR              N
008700110509     D  In_System_Table_Name...
008800110509     D                               10A   Const
008900110509     D  In_System_Table_Schema...
009000110509     D                               10A   Const
009100110509     D  SQL_Clause...
009200110509     D                             1000A   VARYING
009300110509     D  SQL_Column_Separator...
009400110509     D                               10A   VARYING Const
009500110509     D  Key_Pointer...
009600110509     D                                 *
009700110509     D  Number_Of_Keys...
009800110509     D                               10u 0 Options(*NOPASS)
009900110509
010000110207     D*--------------------------------------------------
010100110207     D* Main procedure
010200110207     D*--------------------------------------------------
010300110510     D UPDHANDLER      PI
010400110531     D rpgIO...
010500110203     D                                     LIKEDS(QrnOpenAccess_T)
010600110203
010700110529      /COPY QOAR/QRPGLESRC,QRNOPENACC
010800061223      /FREE
010900110511        EXEC SQL
011000110511         SET OPTION SQLCA = *NO,
011100110604                    DATFMT = *ISO, TIMFMT = *ISO,
011200110604                    EXTIND = *YES,
011300110604                    NAMING = *SYS;
011400110511
011500110531       rpgIO.rpgStatus = *Zero;
011600101108
011700101009       select;
011800110531         when rpgIO.rpgOperation = QrnOperation_OPEN;
011900110531                rpgIO.rpgStatus = Handle_Open(rpgIO);
012000110531         when rpgIO.rpgOperation = QrnOperation_CHAIN;
012100110531                rpgIO.rpgStatus = Handle_Chain(rpgIO);
012200110531         when rpgIO.rpgOperation = QrnOperation_UPDATE;
012300110531              rpgIO.rpgStatus = Handle_Update(rpgIO);
012400110531         when rpgIO.rpgOperation = QrnOperation_CLOSE;
012500110531              rpgIO.rpgStatus = Handle_Close (rpgIO);
012600101022         Other;
012700101022       ENDSL;
012800101009
012900110203       //If unrecoveralbe error then shutdown handler
013000110531       If rpgIO.rpgStatus = 1299;
013100110203         *INLR = *On;
013200110203       ENDIF;
013300110129
013400061223       return;
013500061223
013600061223      /END-FREE
013700110108
013800110108     P*--------------------------------------------------
013900110108     P* Procedure name: Handle_Open
014000110108     P* Purpose:
014100110108     P* Returns:
014200110108     P*--------------------------------------------------
014300110108     P Handle_Open     B
014400110531     D Handle_Open     PI                  LIKE(rpgIO.rpgStatus)
014500110531     D rpgIO...
014600110509     D                                     LIKEDS(QrnOpenAccess_T)
014700110108
014800110108     D* Local fields
014900110531     D retField        S                   LIKE(rpgIO.rpgStatus)
015000110509     D SQLString       S          10000    Varying
015100110604     D TableReference...
015200110604     D                 S             21    Varying
015300110108
015400110108      /FREE
015500110129       retField = *Zero;
015600110129
015700110128       Monitor;
015800110203
015900110531       retField = rpgIO_Open_One_Time_Inz();
016000110531       rpgIO.stateInfo = %Alloc(%Size(rpgSI_t));
016100110509
016200110604       If rpgIO.externalFile.library = '*LIBL';
016300110604         TableReference = rpgIO.externalFile.name;
016400110604       Else;
016500110604         TableReference = %TRIMR(rpgIO.externalFile.library) + '/'
016600110604                        + %TRIMR(rpgIO.externalFile.name) ;
016700110604       ENDIF;
016800110604
016900110604       SQLString = 'SELECT * FROM ' + %TRIMR(TableReference)
017000110604                 + ' WHERE EMPNO = ? FOR FETCH ONLY';
017100110511
017200110521       IF Prepare_SQL_Statement(SQLString) = *On;
017300110514          retField = 1299;
017400110509       Else;
017500110509       ENDIF;
017600110509
017700110128       On-Error;
017800110514          retField = 1299;
017900110128       ENDMON;
018000110108
018100110108       RETURN retField;
018200110108
018300110108      /END-FREE
018400110108     P Handle_Open     E
018500110108
018600110207     P*--------------------------------------------------
018700110207     P* Procedure name: Handle_Chain
018800110207     P* Purpose:
018900110207     P* Returns:
019000110207     P*--------------------------------------------------
019100110207     P Handle_Chain    B
019200110531     D Handle_Chain    PI                  LIKE(rpgIO.rpgStatus)
019300110531     D rpgIO...
019400110509     D                                     LIKEDS(QrnOpenAccess_T)
019500110509
019600110207     D* Local fields
019700110531     D retField        S                   LIKE(rpgIO.rpgStatus)
019800110605     D i               S              5i 0
019900110605     D keys            DS                  LIKEDS(keys_t)
020000110531     D                                     BASED(rpgIO.key)
020100110604     D inpRcd          DS                  LIKEDS(rcdFormat_t)
020200110604     D                                     BASED(rpgIO.inputBuffer)
020300110604     D OLD_ROW         DS                  LIKEDS(rcdFormat_t)
020400110604     D                                     BASED(rpgSI.OLD_ROW_p)
020500110604     D rpgSI...
020600110604     D                 DS                  LIKEDS(rpgSI_t)
020700110604     D                                     BASED(rpgIO.stateInfo)
020800110605     D IndAry          S              5i 0 DIM(%elem(Ind_Array_t))
020900110605     D InpNullMap      S               N   DIM(%elem(Ind_Array_t))
021000110605     D                                     BASED(rpgIO.inputNullMap)
021100110207
021200110509      /FREE
021300110604       retField = *Zero;
021400110604
021500110604       Monitor;
021600110604
021700110604       rpgIO.found = *Off;
021800110605       If Fetch_First_From_Open_SQL_Cursor (keys.EMPNO
021900110531         :rpgIO.inputBuffer
022000110605         :IndAry
022100110509          );
022200110509       Else;
022300110604         rpgSI.Old_Row_p = %Alloc(rpgIO.inputBufferLen);
022400110604         OLD_ROW = inpRcd;
022500110605         //Map null indicators
022600110605         InpNullMap = *Off;
022700110605         For i = 1 to rpgIO.inputNullMapLen;
022800110605           If indAry(i) <> *Zero;
022900110605              InpNullMap(i) = *On;
023000110605           ENDIF;
023100110605         ENDFOR;
023200110605
023300110604         rpgIO.found = *On;
023400110509       ENDIF;
023500110509
023600110604       On-Error;
023700110604          retField = 1299;
023800110604       ENDMON;
023900110604
024000110207       RETURN retField;
024100110207
024200110207      /END-FREE
024300110207     P Handle_Chain    E
024400110129
024500110208     P*--------------------------------------------------
024600110208     P* Procedure name: Handle_Update
024700110208     P* Purpose:        Process the RPG Update Operation
024800110208     P* Returns:
024900110208     P*--------------------------------------------------
025000110208     P Handle_Update   B
025100110531     D Handle_Update   PI                  LIKE(rpgIO.rpgStatus)
025200110531     D rpgIO...
025300110509     D                                     LIKEDS(QrnOpenAccess_T)
025400110208
025500110208     D* Local fields
025600110531     D retField        S                   LIKE(rpgIO.rpgStatus)
025700110514     D i               S              5i 0
025800110514     D OLD_ROW         DS                  LIKEDS(rcdFormat_t)
025900110531     D                                     BASED(rpgSI.OLD_ROW_p)
026000110604     D updRcd          DS                  LIKEDS(rcdFormat_t)
026100110531     D                                     BASED(rpgIO.outputBuffer)
026200110604     D updIndAry...
026300110605     D                 S                   LIKE(Ind_Array_t)
026400110605     D                                     DIM(%elem(Ind_Array_t))
026500110531     D rpgSI...
026600110531     D                 DS                  LIKEDS(rpgSI_t)
026700110531     D                                     BASED(rpgIO.stateInfo)
026800110509
026900110208      /FREE
027000110514
027100110604       updIndAry = -7;
027200110514
027300110604       If updRcd.ADDRLINE1 <> OLD_ROW.ADDRLINE1;
027400110514         SELECT;
027500110605         WHEN updRcd.ADDRLINE1 = '<NULL>';
027600110626             updIndAry(1) = -1;
027700110605         WHEN updRcd.ADDRLINE1 = '<DEFAULT>';
027800110604             updIndAry(1) = -5;
027900110514         OTHER;
028000110604             updIndAry(1) = *Zero;
028100110514         ENDSL;
028200110514       ENDIF;
028300110604       If updRcd.ADDRLINE2 <> OLD_ROW.ADDRLINE2;
028400110514         SELECT;
028500110605         WHEN updRcd.ADDRLINE2 = '<NULL>';
028600110626             updIndAry(2) = -1;
028700110605         WHEN updRcd.ADDRLINE2 = '<DEFAULT>';
028800110604             updIndAry(2) = -5;
028900110514         OTHER;
029000110604             updIndAry(2) = *Zero;
029100110514         ENDSL;
029200110514       ENDIF;
029300110604       If updRcd.ADDRLINE3 <> OLD_ROW.ADDRLINE3;
029400110514         SELECT;
029500110605         WHEN updRcd.ADDRLINE3 = '<NULL>';
029600110626             updIndAry(3) = -1;
029700110605         WHEN updRcd.ADDRLINE3 = '<DEFAULT>';
029800110604             updIndAry(3) = -5;
029900110514         OTHER;
030000110604             updIndAry(3) = *Zero;
030100110514
030200110514         ENDSL;
030300110514       ENDIF;
030400110604       If updRcd.CITY <> OLD_ROW.CITY;
030500110514         SELECT;
030600110605         WHEN updRcd.CITY = '<NULL>';
030700110626             updIndAry(4) = -1;
030800110605         WHEN updRcd.CITY = '<DEFAULT>';
030900110604             updIndAry(4) = -5;
031000110514         OTHER;
031100110604             updIndAry(4) = *Zero;
031200110514
031300110514         ENDSL;
031400110514       ENDIF;
031500110604       If updRcd.STATE <> OLD_ROW.STATE;
031600110514         SELECT;
031700110605         WHEN updRcd.STATE = '<NULL>';
031800110626             updIndAry(5) = -1;
031900110605         WHEN updRcd.STATE = '<DEFAULT>';
032000110604             updIndAry(5) = -5;
032100110514         OTHER;
032200110604             updIndAry(5) = *Zero;
032300110514
032400110514         ENDSL;
032500110514       ENDIF;
032600110604       If updRcd.ZIPCODE <> OLD_ROW.ZIPCODE;
032700110514         SELECT;
032800110605         WHEN updRcd.ZIPCODE = '<NULL>';
032900110626             updIndAry(6) = -1;
033000110605         WHEN updRcd.ZIPCODE = '<DEFAULT>';
033100110604             updIndAry(6) = -5;
033200110514         OTHER;
033300110604             updIndAry(6) = *Zero;
033400110514
033500110514         ENDSL;
033600110514       ENDIF;
033700110510
033800110604       If Update_Columns_Using_Extended_Indicators (updRcd
033900110604                                    :updIndAry);
034000110514          RetField = 1299;
034100110509       EndIf;
034200110509
034300110208       RETURN retField;
034400110208
034500110208      /END-FREE
034600110208     P Handle_Update   E
034700110208
034800110129     P*--------------------------------------------------
034900110129     P* Procedure name: Handle_Close
035000110129     P* Purpose:
035100110129     P* Returns:
035200110129     P*--------------------------------------------------
035300110129     P Handle_Close    B
035400110531     D Handle_Close    PI                  LIKE(rpgIO.rpgStatus)
035500110531     D rpgIO...
035600110509     D                                     LIKEDS(QrnOpenAccess_T)
035700110129
035800110129     D* Local fields
035900110531     D retField        S                   LIKE(rpgIO.rpgStatus)
036000110129
036100110129      /FREE
036200110129       retField = *Zero;
036300110129
036400110604       EXEC SQL CLOSE rpgIOInp_C1;
036500110514
036600110531       Dealloc rpgIO.stateInfo;
036700110129
036800110129       RETURN retField;
036900110129
037000110129      /END-FREE
037100110129     P Handle_Close    E
037200110129
037300110206
037400110207     P*--------------------------------------------------
037500110531     P* Procedure name: rpgIO_Open_One_Time_Inz
037600110207     P* Purpose:
037700110207     P* Returns:
037800110207     P*--------------------------------------------------
037900110531     P rpgIO_Open_One_Time_Inz...
038000110207     P                 B
038100110531     D rpgIO_Open_One_Time_Inz...
038200110531     D                 PI                  LIKE(rpgIO.rpgStatus)
038300110207
038400110207     D* Local fields
038500110531     D retField        S                   LIKE(rpgIO.rpgStatus)
038600110207
038700110207      /FREE
038800110207       retField = *Zero;
038900110207
039000110207
039100110207        //IO Feedback information
039200110531        rpgIO.openFeedback = %Alloc(80);
039300110531        rpgIO.ioFeedback = %Alloc(160);
039400110531        rpgIO.deviceFeedback = %Alloc(126);
039500110531        rpgIO.openFeedbackLen = 80;
039600110531        rpgIO.ioFeedbackLen = 160;
039700110531        rpgIO.deviceFeedbackLen = 126;
039800110207
039900110531        rpgIO.functionKey = *Zero;
040000110207
040100110207        RETURN retField;
040200110207
040300110207      /END-FREE
040400110531     P rpgIO_Open_One_Time_Inz...
040500110207     P                 E
040600110521     P Prepare_SQL_Statement...
040700110509     P                 B                   EXPORT
040800110521     D Prepare_SQL_Statement...
040900110509     D                 PI              N
041000110509     D  p_SQL_String              10000    Varying
041100110509
041200110509     D* Local fields
041300110509     D retField        S               N
041400110509     D v_SQL_String    S          10000    Varying
041500110509
041600110509      /FREE
041700110509       RetField = *Off;
041800110528       SqlState = '00000';
041900110509
042000110514       v_SQL_String = p_SQL_String;
042100110514
042200110509       EXEC SQL
042300110604         Prepare rpgIOInp_S1 FROM :v_SQL_String;
042400110514       If SqlState = '00000';
042500110514         EXEC SQL
042600110604          Declare rpgIOInp_C1 SCROLL CURSOR FOR
042700110604          rpgIOInp_S1;
042800110514         If SqlState <> '00000';
042900110514           RetField = *ON;
043000110514         EndIf;
043100110514       Else;
043200110509         RetField = *ON;
043300110509       EndIf;
043400110509
043500110509       Return retField;
043600110509      /END-FREE
043700110521     P Prepare_SQL_Statement...
043800110509     P                 E
043900110509
044000110521     P FETCH_FIRST_FROM_OPEN_SQL_CURSOR...
044100110509     P                 B                   EXPORT
044200110521     D FETCH_FIRST_FROM_OPEN_SQL_CURSOR...
044300110509     D                 PI              N
044400110605     D p_Key1                              LIKE(rcdFormat_t.EMPNO)
044500110514     D inputBuffer...
044600110509     D                                 *
044700110605     D IndAry                         5i 0 DIM(%elem(Ind_Array_t))
044800110509
044900110509     D* Local fields
045000110509     D retField        S               N
045100110509
045200110514     D inpRcd          DS                  LIKEDS(rcdFormat_t)
045300110514     D                                     BASED(inputBuffer)
045400110605     D IndAry_v        S              5i 0 DIM(%elem(Ind_Array_t))
045500110509
045600110509      /FREE
045700110509        RetField = *Off;
045800110605        IndAry_v = IndAry;
045900110509
046000110514       EXEC SQL
046100110605        OPEN  rpgIOInp_C1 USING :p_Key1;
046200110514       If SqlState = '00000';
046300110514         EXEC SQL
046400110605           Fetch FIRST FROM rpgIOInp_C1 INTO :inpRcd:IndAry_v;
046500110514           If SqlState = '00000';
046600110605             IndAry = IndAry_v;
046700110604           Else;
046800110604             RetField = *ON;
046900110514           EndIf;
047000110514       Else;
047100110514         RetField = *ON;
047200110514       EndIf;
047300110509
047400110604       RETURN retField;
047500110509
047600110509      /END-FREE
047700110521     P FETCH_FIRST_FROM_OPEN_SQL_CURSOR...
047800110509     P                 E
047900110514
048000110528     P Update_Columns_Using_Extended_Indicators...
048100110509     P                 B                   EXPORT
048200110528     D Update_Columns_Using_Extended_Indicators...
048300110509     D                 PI              N
048400110604     D  updRcd...
048500110514     D                                      LIKEDS(rcdFormat_t)
048600110509     D  Ind_Ary...
048700110605     D                                      LIKE(Ind_Array_t)
048800110605     D                                      DIM(%elem(Ind_Array_t))
048900110509     D* Local fields
049000110509     D retField        S               N
049100110509     D Ind_Ary_Ptr     S               *
049200110509
049300110509     D Ind_Ary_DS      DS                  BASED(Ind_Ary_Ptr)
049400110509     D   Ind_Ary_1                    5i 0
049500110509     D   Ind_Ary_2                    5i 0
049600110509     D   Ind_Ary_3                    5i 0
049700110509     D   Ind_Ary_4                    5i 0
049800110509     D   Ind_Ary_5                    5i 0
049900110509     D   Ind_Ary_6                    5i 0
050000110509     D   Ind_Ary_7                    5i 0
050100110509
050200110509      /FREE
050300110509       Ind_Ary_Ptr = %Addr(Ind_Ary);
050400110509
050500110509       EXEC SQL
050600110514         UPDATE empAddress
050700110604           SET ADDRLINE1 = :updRcd.ADDRLINE1:Ind_Ary_1,
050800110604               ADDRLINE2 = :updRcd.ADDRLINE2:Ind_Ary_2,
050900110604               ADDRLINE3 = :updRcd.ADDRLINE3:Ind_Ary_3,
051000110604               CITY = :updRcd.CITY:Ind_Ary_4,
051100110604               STATE = :updRcd.STATE:Ind_Ary_5,
051200110604               ZIPCODE = :updRcd.ZIPCODE:Ind_Ary_6
051300110604           WHERE EMPNO = :updRcd.EMPNO;
051400110509
051500110509       If SqlCode < 0;
051600110509         RetField = *ON;
051700110509       EndIf;
051800110509
051900110509       RETURN retField;
052000110509
052100110509      /END-FREE
052200110528     P Update_Columns_Using_Extended_Indicators...
052300110509     P                 E
