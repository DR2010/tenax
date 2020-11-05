*****************************************************************************
* arquivo locproc.prg  -  procedimentos e funcoes                           *
*                                                                           *
* modulo integrante do sistema loctel   -   gomes & nunes advogados         *
*                                                                           *
* data inicial: novembro/1993                                               *
*                                                                           *
* autores: - roberto peter                                                  *
*          - marcio nunes                                                   *
*****************************************************************************



***************************************************************************
function realca
***************************************************************************

parameters x,y,msg,mascara

set color to w+/n

if valtype(msg)="c" .or. valtype(msg)="d"
   @ x,y say msg
elseif valtype(msg)="n"
   @ x,y say msg pict "&mascara."
endif

set color to

return (.t.)

***************************************************************************
function extenso
***************************************************************************

   parameters numero

   if  numero <= 0
        store " " to linha1,linha2,linha3
       return(.f.)
   endif
   n01="um "
   n02="dois "
   n03="tres "
   n04="quatro "
   n05="cinco "
   n06="seis "
   n07="sete "
   n08="oito "
   n09="nove "
   n00=" "
   n10="dez "
   n11="onze "
   n12="doze "
   n13="treze "
   n14="quatorze "
   n15="quinze "
   n16="dezesseis "
   n17="dezessete "
   n18="dezoito "
   n19="dezenove "
   n20="vinte "
   n30="trinta "
   n40="quarenta "
   n50="cinquenta "
   n60="sessenta "
   n70="setenta "
   n80="oitenta "
   n90="noventa "
   n000=" "
   n100="cento "
   n200="duzentos "
   n300="trezentos "
   n400="quatrocentos "
   n500="quinhentos "
   n600="seiscentos "
   n700="setecentos "
   n800="oitocentos "
   n900="novecentos "
   mil="mil "
   milhao="milhao "
   milhoes="milhoes "
   moeda="reais "
   moeda1="real "
   centavo="centavo "
   centavos="centavos "
   numero1=str(numero,13,2)
   cents=str((numero-int(numero))*100,2)
   numero=int(numero)
   contador=1
   p1=substr(numero1,2,3)
   p2=substr(numero1,5,3)
   p3=substr(numero1,8,3)
   p4=cents
   texto1=""
   texto2=""
   texto3=""
   texto4=""
   linha1=""
   linha2=""
   linha3=""
   if val(p1)>0
      status1=iif(val(p1)>1,"2","1")
   else
      status1=" "
   endif
   do while contador <=4
      item=str(contador,1)
      grupo= "p"+str(contador,1)
      extenso=iif(&grupo="000","",ltrim(&grupo))
      do case
         case len(extenso)=3
            if extenso="100"
               texto&item=texto&item+"cem "
               contador=contador+1
               loop
            endif
            if substr(extenso,len(extenso)-2+1)="00"
               tab="n"+substr(extenso,1,1)+"00"
               texto&item=texto&item+&tab
               contador=contador+1
               loop
            endif
            tab="n"+substr(extenso,1,1)+"00"
            texto&item=&tab +"e "
            dezena=val(substr(extenso,len(extenso)-2+1))
            if dezena <20
               tab="n"+substr(extenso,len(extenso)-2+1)
               texto&item=texto&item+&tab
               contador=contador+1
               loop
            else
               tab="n"+substr(extenso,2,1)+"0"
               texto&item=texto&item+ &tab
               tab="n0"+substr(extenso,len(extenso)-1+1)
               unidade_ext=val(substr(extenso,len(extenso)-1+1))
               if unidade_ext > 0
                  texto&item=texto&item +iif(val(extenso)>10,"e ","")
               endif
               texto&item=texto&item+iif(tab="n00"," ",&tab)
            endif
         case len(extenso)=2
            dezena=val(substr(extenso,len(extenso)-2+1))
            if dezena < 20
               tab="n"+ substr(extenso,len(extenso)-2+1)
               texto&item=texto&item+&tab
               contador=contador+1
               loop
            else
               tab="n"+ substr(extenso,1,1)+"0"
               texto&item=texto&item + &tab
               tab="n0" + substr(extenso,len(extenso)-1+1)
               unidade_ext1=val(substr(extenso,len(extenso)-1+1))
               if unidade_ext1 > 0
                  texto&item=texto&item + "e "
               endif
               texto&item=texto&item+iif(tab="n00"," ",&tab)
            endif
         case len(extenso)=1
            tab="n0" + substr(extenso,len(extenso)-1+1)
            texto&item=texto&item + iif(tab="n00"," ",&tab)
         otherwise
            texto&item=""
      endcase
      contador=contador+1
   enddo
   final = iif(len(texto1)=0,"",texto1 + ;
           iif(status1="1",milhao,milhoes)) +;
           iif(len(texto2)=0,"", texto2 + mil ) +;
      texto3 + iif(val(p2+p3)=0,"de ","")
   final = final + iif(val(p1+p2+p3)=0,"",iif(val(p1+p2+p3)=1,moeda1,moeda))
   final = final + iif(val(p4)=0,"",;
                   iif(val(p1+p2+p3)=0,"","e ") + ;
   texto4 + (iif(val(p4)=1,centavo,centavos)))

   ********************* ajusta extenso ********************
   m->linha=66
   texto1=final
   pinicial=1
   pfinal=m->linha
   teste=.t.
   item="1"
   if len(texto&item) > m->linha
      do while val(item)<=3
         do while pfinal<len(texto&item)
            branco=substr(texto&item,pfinal,1)
            if branco <> " "
               pfinal=pfinal-1
               loop
            else
               exit
            endif
         enddo
         linha&item=substr(texto&item,1,pfinal)
         itemv=item
         item=str(val(item)+1,1)
         texto&item=substr(texto&itemv,len(texto&itemv)-(len(texto&itemv)-pfinal)+1)
      enddo
   else
      linha1=final
   endif
   linha1=linha1+replicate(" ",m->linha-len(linha1))
   linha2=linha2+replicate(" ",m->linha-len(linha2))
   linha3=linha3+replicate(" ",m->linha-len(linha3))

return(.t.)

*************************************************************************
function backup
*************************************************************************
*
* autor: marcio da cunha nunes
* data : 31/08/1993
*
* objetivo: realizar rotina de backup de arquivos do tipo [.dbf] sem a
*   necessidade de recorrer ao programa backup.com do dos, que pode ser
*   inexistente como tambem dar problema de versao de sistema operacional.
*
* obs.: 1) esta funcao esta' executando o comando pack antes da copia.
*       2) esta funcao tem que obrigatoriamente ser compilada pelo clipper 5.0
*
* sintaxe: backup(<vetor_nome_arquivos> , <drive_destino> , <arq_informacao>)
*
* exemplo de utilizacao:
*
*                          declare arqs[3]
*                                  arqs[1] = "a.dbf"
*                                  arqs[2] = "b.dbf"
*                                  arqs[3] = "c.dbf"
*
*                          backup(arqs,"a:\","info_br.dbf")
*
*                             -----------//------------
*
* vetor montado pela funcao (ex.):
*
*      nome    drive+nome   tamanho  tamanho minimo
*     ----------------------------------------------
*      a.dbf   a:\a.dbf      100         08
*      b.dbf   a:\b.dbf      540         25
*      c.dbf   a:\c.dbf      320         14
*
*-----------------------------------------------------------------------*

parameters nomearqs, drive, arqinfo


if drive="a:\"
   store 1 to num
else
   store 2 to num
endif

if !file(arqinfo)
   declare vetarq[3]
   vetarq[1] = "n_disco   /n/03/00"
   vetarq[2] = "nome_arq  /c/12/00"
   vetarq[3] = "inicio    /c/01/00"
   criadbf(arqinfo,vetarq)
else
   use (arqinfo)
   zap
   use
endif

store len(nomearqs) to n_arqs

declare vetor[n_arqs,4],linha_aux[1,4]

store 0 to tam_total,flag

* monta o vetor 4x4 - ainda desordenado.
for x=1 to n_arqs

  store nomearqs[x] to vetor[x,1]

  store (upper(drive)+nomearqs[x]) to vetor[x,2]

   use (nomearqs[x])
   pack
   go top

   store header()+(recsize()*lastrec())+1 to vetor[x,3]

   store header()+recsize()+1 to vetor[x,4]

   store (vetor[x,3] + tam_total) to tam_total

   close

next

release nomearqs


* ordena o vetor por ordem ascendente de tamanho; assim realizamos o menor
* numero de quebras em disco dos arquivos a serem copiados. - metodo bolha.
*
for i=1 to n_arqs-1

       if (vetor[i,3] > vetor[i+1,3])

          * gera um vetor (linha_aux) p/ uso do metodo bolha.
         for x=1 to 4
              store vetor[i,x] to linha_aux[1,x]
          next

          * transfere os dados da proxima linha corrente p/ a linha corrente.
            for y=1 to 4
              store vetor[i+1,y] to vetor[i,y]
          next

        * transfere os dados contidos no vetor linha_aux p/ a posicao
          * correta - proxima linha do vetor principal.
        for z=1 to 4
              store linha_aux[1,z] to vetor[i+1,z]
          next

       endif

next

release linha_aux


* realiza copia dos arquivos do vetor ja' ordenado e n discos.
*
store 1 to cont_arqs, cont_byte
store 1 to vn_disco
store .t. to troca,continua

do while  (cont_byte < tam_total)

   use (arqinfo)
   append blank
   replace n_disco  with vn_disco
   replace nome_arq with vetor[cont_arqs,1]
   replace inicio   with "s"

   use (vetor[cont_arqs,1])

   if (troca)
      troca_disco(vn_disco,"backup")

      if (continua=.f.)
                        return(.f.)
      endif

      * apaga todo o conteudo do diskette................
      declare vetdir[adir(drive+"*.*")]
      adir(drive+"*.*",vetdir)
     store adir(drive+"*.*") to tam_vetor
       for x=1 to tam_vetor
         delete file (drive+vetdir[x])
      next
      release vetdir
      *..................................................

   endif

   store .f. to troca

   do while !eof()

      if (troca=.t.)

         store (vn_disco +1) to vn_disco
         troca_disco(vn_disco,"backup")

         if (continua=.f.)
                             return(.f.)
         endif

         * apaga todo o conteudo do diskette................
         declare vetdir[adir(drive+"*.*")]
         adir(drive+"*.*",vetdir)
        store adir(drive+"*.*") to tam_vetor
           for x=1 to tam_vetor
            delete file (drive+vetdir[x])
         next
         release vetdir
         *..................................................

        store recno() to flag
        use (arqinfo)
         append blank
          replace n_disco  with vn_disco,;
                nome_arq with vetor[cont_arqs,1],;
                inicio with "n"
         use (vetor[cont_arqs,1])
         go (flag)

      endif

     * calcula o numero de registros a ser copiado no diskette, deixando
     * 10 kbytes de margem de espaco.
     *
     store ((diskspace(num)-10000)-header())/recsize() to n_registros

      store vetor[cont_arqs,2] to nome_arq

      copy next n_registros to &nome_arq.

      skip

      store .t. to troca

   enddo

    store (cont_byte + vetor[cont_arqs,3]) to cont_byte

   if (cont_arqs = n_arqs)
      exit
   else
      store (cont_arqs + 1) to cont_arqs
   endif

   * se o espaco do disco a for menor que a estrutura+registro do proximo
   * arquivo, executar aviso 'coloque disco numero (x) no drive (y)...
   *
   if diskspace(num) < vetor[cont_arqs,4]
      store .t. to troca
   else
      store .f. to troca
      loop
   endif

enddo

return(.t.)


*************************************************************************
function restore
*************************************************************************
*
* autor: marcio da cunha nunes
* data : 31/08/1993
*
* objetivo: realizar rotina de restore de arquivos do tipo [.dbf] sem a
*   necessidade de recorrer ao programa restore.com do dos, que pode ser
*   inexistente como tambem dar problema de versao de sistema operacional.
*
* sintaxe: restore (<arquivo_informacao> , <drive_origem> , <drive_destino>)
*
* exemplo de utilizacao:
*
*                       restore("info_br.dbf","a:\","c:\teste")
*
*-----------------------------------------------------------------------*
parameters arq_info, drvorigem, drvdestino

store .t. to troca,continua

use (arq_info)

do while !eof()

   store n_disco to vn_disco

   if (troca=.t.)
      troca_disco(vn_disco,"restore")

      if (continua=.f.)
                        return(.f.)
      endif

   endif

    store alltrim(drvorigem+nome_arq)      to nome_arq_origem
    store alltrim(drvdestino+"\"+nome_arq) to nome_arq_destino

   if (inicio="s")
       copy file (nome_arq_origem) to (nome_arq_destino)
   elseif (inicio="n")
       store recno() to flag_info
       use (nome_arq_destino)
       append from (nome_arq_origem)
      use (arq_info)
        go (flag_info)
   endif

   skip

   if (n_disco<>vn_disco)
      store .t. to troca
   else
      store .f. to troca
   endif

enddo

return(.t.)


*****************************************************************************
function troca_disco
*****************************************************************************
*
* parametros:  numero---> numero do disco.
*              processo-> backup ou restore.

parameters numero,processo

caixa(09,15,13,64)
@ 10,34 say "             "
@ 11,18 say "coloque disco numero " + alltrim(str(numero))+" e tecle <enter>..."
tone(200,1)
tone(200,1)
inkey(0)

if lastkey()=27
   store .f. to continua
        erro("processo interompido !!!")
   return(continua)
endif

set color to w+*/n
@ 10,34 say "a g u a r d e"
set color to

if upper(processo)="backup"
     @ 11,18 say "copiando arquivos p/ disco numero " + alltrim(str(numero)) + "...     "
elseif upper(processo)="restore"
     @ 11,18 say "restaurando arquivos do disco numero " + alltrim(str(numero)) + "...    "
endif

return(.t.)

***********************************************************************
function criadbf
***********************************************************************

parameters arquivo,vetor

n_campos = len(vetor)

create arqtemp

public vcampo, vtipo, vcomp, vdec

x=1
for x=1 to n_campos

    nome_campo = substr(vetor[x],1,10)

   tipo_campo = substr(vetor[x],12,1)

    tam_campo  = substr(vetor[x],14,2)

   dec_campo  = substr(vetor[x],17,2)

    append blank

    replace field_name  with nome_campo

    replace field_type  with tipo_campo

    replace field_len   with val(tam_campo)

    replace field_dec   with val(dec_campo)

next x

create (arquivo) from arqtemp

delete file arqtemp.dbf

return(.t.)

*******************************************************************************
function caixa
parameters ls,cs,li,ci
*
* objetivo..: desenha uma caixa com sombra nas coordenadas.
* parƒmetros:
*   ls, cs  -> coordenadas do cando superior direito
*   li, ci  -> coordenadas do canto inferior esquerdo
*
* obs.: declarar variavel 'carac_sombra' no modulo principal como publica.
*       e atribuir um numero a ela.
*******************************************************************************

vtela=savescreen(ls+1,cs+2,li+1,ci+2)

if len(vtela)>2048
   vtela=transform(substr(vtela,1,2048),replicate("x"+chr(carac_sombra),1000))+;
          transform(substr(vtela,2049),replicate("x"+chr(carac_sombra),1000))
else
   vtela=transform(vtela,replicate("x"+chr(carac_sombra),len(vtela)/2))
endif

restscreen(ls+1,cs+2,li+1,ci+2,vtela)

@ ls,cs clear to li,ci
@ ls,cs to li,ci

return(.t.)

***************************************************************************
function erro
* marcio nunes - 13.05.93
***************************************************************************

parameters msg

store 12 to li
store 20 to ci
store 17to lf
store 60 to cf
store 14 to li_msg
tela_anterior=savescreen(li,ci,lf+1,cf+2)
set cursor off
store len(alltrim(msg)) to tam_msg
store "tecle algo p/ retornar..." to msg_aux
store len(msg_aux) to tam_tecle_algo
store (cf-ci) to coluna_central
store int( tam_msg/2 ) to centro_msg
store int( tam_tecle_algo/2 ) to centro_tecle_algo
set color to (cor_erro)
caixa(li,ci,lf,cf)
@ li_msg,(coluna_central - centro_msg) say msg
@ (lf-1),(coluna_central - centro_tecle_algo) say msg_aux
tone(200,2)
inkey(0)
set color to
restscreen(li,ci,lf+1,cf+2,tela_anterior)
set cursor on
return(.t.)

