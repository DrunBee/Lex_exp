%{
#include<stdio.h>
#include<string.h>
#define IDN 1

#define INT10 2
#define INT8 3
#define INT16 4

#define ADD 5
#define DEC 6
#define MUL 7
#define DIV 8
#define GT 9
#define LT 10
#define EQ 11
#define LPT 12
#define RPT 13
#define SEMI 14

#define IF 15
#define THEN 16
#define ELSE 17
#define WHILE 18
#define DO 19

#define REAL10 20
#define REAL8 21
#define REAL16 22

#define ERRORCHAR 23
%}

delim   [ \t\n]
ws  {delim}+
digit   [0-9]
letter  [A-Za-z_]
id  {letter}({letter}|{digit})*
number  {digit}+(\.{digit}+)?([eE][+-]?{digit}+)?

int8    (0([0-7])+)
int10   ([1-9]|[1-9]([0-9])+|0)
int16   (0[xX]([A-Fa-f0-9])+)

real8   (0([0-7])+\.([0-7])*)
real10  (([1-9]|[1-9]([0-9])+)\.[0-9]+|0\.([0-9])+)
real16  0[xX]([A-Fa-f0-9])+\.([A-Fa-f0-9])*

%%
{ws}    {;}
(while|while)   {return (WHILE);}
(do|do)    {return (DO);}
(if|if)         {return (IF);}
(then|then)         {return (THEN);}
(else|else)        {return (ELSE);}

{id}        {return (IDN);}


{int8}      {return (INT8);}
{int10}     {return (INT10);}
{int16}     {return (INT16);}

{real8}     {return (REAL8);}
{real10}    {return (REAL10);}
{real16}    {return (REAL16);}

"<"     {return (LT);}
">"             {return (GT);}
"="             {return (EQ);}
"+"             {return (ADD);}
"-"             {return (DEC);}
"*"             {return (MUL);}
"/"             {return (DIV);}
";"             {return (SEMI);}
"("             {return (LPT);}
")"             {return (RPT);}

.       {return (ERRORCHAR);}

%%
int yywrap(){
    return 1;
}

float octalToDecimal(char* octal) {
    int integer_part = 0;
    float decimal_part = 0;
    int i;
    
    for(i = 0; i < strlen(octal) && octal[i] != '.'; i++) {
        integer_part = integer_part * 8 + (octal[i] - '0');
    }
    
    if(i < strlen(octal) && octal[i] == '.') {
        i++;
        float temp = 0.125; 
        while(i < strlen(octal)) {
            decimal_part += (octal[i] - '0') * temp;
            temp /= 8;
            i++;
        }
    }
    float result=integer_part + decimal_part;
    return result;
}

float hexToDecimal(char* hex) {
    int integer_part = 0;
    float decimal_part = 0;
    int i;
    for(i = 2; hex[i] != '.' && hex[i] != '\0'; i++) {
        if(hex[i] >= '0' && hex[i] <= '9')
            integer_part = integer_part * 16 + (hex[i] - '0');
        else if(hex[i] >= 'A' && hex[i] <= 'F')
            integer_part = integer_part * 16 + (hex[i] - 'A' + 10);
        else if(hex[i] >= 'a' && hex[i] <= 'f')
            integer_part = integer_part * 16 + (hex[i] - 'a' + 10);
    }
    if(hex[i] == '.') {
        i++;
        float temp = 0.0625; 
        while(hex[i] != '\0') {
            if(hex[i] >= '0' && hex[i] <= '9')
                decimal_part += (hex[i] - '0') * temp;
            else if(hex[i] >= 'A' && hex[i] <= 'F')
                decimal_part += (hex[i] - 'A' + 10) * temp;
            else if(hex[i] >= 'a' && hex[i] <= 'f')
                decimal_part += (hex[i] - 'a' + 10) * temp;
            temp /= 16;
            i++;
        }
    }
    float result = integer_part + decimal_part;
    return result;
}

void writeout(int c){
    switch(c){
        case ERRORCHAR:fprintf(yyout,"ERRORCHAR    %s\n",yytext);
            break;
        case INT10:fprintf(yyout,"INT10    %s\n",yytext);
                        break;
        case INT16:
        {
            float num=hexToDecimal(yytext);
            char str[50];
            int n = sprintf(str, "%.20f", num); 
            while(str[n-1] == '0') { 
                str[n-1] = '\0';
                n--;
            }
            str[n-1] = '\0';
            fprintf(yyout,"INT16    %s\n",str);            
            break;
        }
        case INT8:
        {
            float num=octalToDecimal(yytext);
            char str[50];
            int n = sprintf(str, "%.20f", num); 
            while(str[n-1] == '0') { 
                str[n-1] = '\0';
                n--;
            }
            str[n-1] = '\0';
            fprintf(yyout,"INT8    %s\n",str);            
            break;
        }
        case WHILE:fprintf(yyout,"WHILE    _\n");
                        break; 
        case DO:fprintf(yyout,"DO    _\n");
                        break; 
        case IF:fprintf(yyout,"IF    _\n");
                        break; 
        case THEN:fprintf(yyout,"THEN    _\n");
                        break; 
        case ELSE:fprintf(yyout,"ELSE    _\n");
                        break; 
        case IDN:fprintf(yyout,"IDN    %s\n",yytext);
                        break; 
        case RPT:fprintf(yyout,")    _\n");
                        break; 
        case LPT:fprintf(yyout,"(    _\n");
                        break; 
        case SEMI:fprintf(yyout,";    _\n");
                        break; 
        case DIV:fprintf(yyout,"/    _\n");
                        break; 
        case MUL:fprintf(yyout,"*    _\n");
                        break; 
        case DEC:fprintf(yyout,"-    _\n");
                        break; 
        case ADD:fprintf(yyout,"+    _\n");
                        break; 
        case EQ:fprintf(yyout,"=    _\n");
                        break; 
        case GT:fprintf(yyout,">    _\n");
                        break; 
        case LT:fprintf(yyout,"<    _\n");
                        break; 
        case REAL8:
        {
            float num=octalToDecimal(yytext);
            char str[50];
            int n = sprintf(str, "%.20f", num); 
            while(str[n-1] == '0') { 
                str[n-1] = '\0';
                n--;
            }
            if(str[n-1] == '.') str[n-1] = '\0';
            fprintf(yyout,"INT8    %s\n",str);            
            break;
        }
        case REAL10:fprintf(yyout,"REAL10    %s\n",yytext);
                        break; 
        case REAL16:
        {
            float num=hexToDecimal(yytext);
            char str[50];
            int n = sprintf(str, "%.20f", num); 
            while(str[n-1] == '0') { 
                str[n-1] = '\0';
                n--;
            }
            if(str[n-1]=='.') str[n-1] = '\0';
            fprintf(yyout,"INT16    %s\n",str);            
            break;
        }
        default:break; 

        }
    return;
}

int main(int argc,char ** argv){
    int c;
    yyin=fopen("sample.txt","r");
    yyout=fopen("result.txt","w");
    while(c=yylex()){
        writeout(c);
    }
    fclose(yyin);
        fclose(yyout);
    return 0;
}