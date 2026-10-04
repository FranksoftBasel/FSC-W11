1445:01A1 B408          MOV     AH,08
1445:01A3 CD13          INT     13
1445:01A5 7223          JB      01CA
1445:01A7 8AC1          MOV     AL,CL
1445:01A9 243F          AND     AL,3F
1445:01AB 98            CBW
1445:01AC 8ADE          MOV     BL,DH
1445:01AE 8AFC          MOV     BH,AH
1445:01B0 43            INC     BX
1445:01B1 F7E3          MUL     BX
1445:01B3 8BD1          MOV     DX,CX
1445:01B5 86D6          XCHG    DL,DH
1445:01B7 B106          MOV     CL,06
1445:01B9 D2EE          SHR     DH,CL
1445:01BB 42            INC     DX
1445:01BC F7E2          MUL     DX
1445:01BE 39560A        CMP     [BP+0A],DX


1445:01C1 7723          JA      01E6         <<<<   EB 23
1445:01C3 7205          JB      01CA
1445:01C5 394608        CMP     [BP+08],AX
1445:01C8 731C          JAE     01E6
1445:01CA B80102        MOV     AX,0201
1445:01CD BB007C        MOV     BX,7C00
1445:01D0 8B4E02        MOV     CX,[BP+02]
1445:01D3 8B5600        MOV     DX,[BP+00]
1445:01D6 CD13          INT     13
1445:01D8 7351          JAE     022B
1445:01DA 4F            DEC     DI
1445:01DB 744E          JZ      022B
1445:01DD 32E4          XOR     AH,AH
1445:01DF 8A5600        MOV     DL,[BP+00]
1445:01E2 CD13          INT     13
