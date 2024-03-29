/* $Id$ -*- mode: c++ -*- */
/** \file scanner.ll Define the example Flex lexical scanner */

%{ /*** C/C++ Declarations ***/

#include <string>
#include "scanner.h"

/* import the parser's token type into a local typedef */
typedef decaf::Parser::token token;
typedef decaf::Parser::token_type token_type;

/* By default yylex returns int, we use token_type. Unfortunately yyterminate
 * by default returns 0, which is not of token_type. */
#define yyterminate() return token::END

/* This disables inclusion of unistd.h, which is not available under Visual C++
 * on Win32. The C++ scanner uses STL streams instead. */
#define YY_NO_UNISTD_H

%}

/*** Flex Declarations and Options ***/

/* enable c++ scanner class generation */
%option c++

/* change the name of the scanner class. results in "decafFlexLexer" */
%option prefix="decaf"

/* the manual says "somewhat more optimized" */
%option batch

/* enable scanner to generate debug output. disable this for release
 * versions. */
%option debug

/* no support for include files is planned */
%option yywrap nounput 

/* enables the use of start condition stacks */
%option stack

/* The following paragraph suffices to track locations accurately. Each time
 * yylex is invoked, the begin position is moved onto the end position. */
%{
    #define YY_USER_ACTION  yylloc->columns(yyleng);
%}

%% /*** Regular Expressions Part ***/


 /* code to place at the beginning of yylex() */
%{
    // reset location
    yylloc->step();
%}

[0-9][0-9]*         {yylval->integerVal = atoi(yytext); return token::decimal_literal;}
"class"             {yylval->stringVal = new std::string(yytext,yyleng); return token::CLASS;}
"Program"           {yylval->stringVal = new std::string(yytext,yyleng); return token::PROGRAM;}
"void"              {yylval->stringVal = new std::string(yytext,yyleng); return token::VOID;}
"callout"           {yylval->stringVal = new std::string(yytext,yyleng); return token::CALLOUT;}
"int"               {yylval->stringVal = new std::string(yytext,yyleng); return token::INT;}
"boolean"           {yylval->stringVal = new std::string(yytext,yyleng); return token::BOOLEAN;}
"for"               {yylval->stringVal = new std::string(yytext,yyleng); return token::FOR;}
"break"             {yylval->stringVal = new std::string(yytext,yyleng); return token::BREAK;}
"continue"          {yylval->stringVal = new std::string(yytext,yyleng); return token::CONTINUE;}
"if"                {yylval->stringVal = new std::string(yytext,yyleng); return token::IF;}
"else"              {yylval->stringVal = new std::string(yytext,yyleng); return token::ELSE;}
"return"            {yylval->stringVal = new std::string(yytext,yyleng); return token::RETURN;}
"true"              {yylval->stringVal = new std::string(yytext,yyleng); return token::TRUE;}
"false"             {yylval->stringVal = new std::string(yytext,yyleng); return token::FALSE;}

"0x"[0-9a-fA-F][0-9a-fA-F]*  {yylval->stringVal = new std::string(yytext,yyleng); return token::INT;}
['](\\n|\\t|\\'|\\\\|\\\"|[^\\"'])[']      {yylval->stringVal = new std::string(yytext,yyleng); return token::char_literal;}
["](\\n|\\t|\\'|\\\\|\\\"|[^\\"'])*["]    {yylval->stringVal = new std::string(yytext,yyleng); return token::string_literal;}
[a-zA-Z]([a-zA-Z]|[0-9])*               {yylval->stringVal = new std::string(yytext,yyleng); return token::ID;}

"+"                 {return static_cast<token_type>(*yytext);}
"-"                 {return static_cast<token_type>(*yytext);}
"*"                 {return static_cast<token_type>(*yytext);}
"/"                 {return static_cast<token_type>(*yytext);}
"("                 {return static_cast<token_type>(*yytext);}
")"                 {return static_cast<token_type>(*yytext);}
"%"                 {return static_cast<token_type>(*yytext);}
"}"                 {return static_cast<token_type>(*yytext);}
"{"                 {return static_cast<token_type>(*yytext);}
">"                 {return static_cast<token_type>(*yytext);}
"<"                 {return static_cast<token_type>(*yytext);}
"="                 {return static_cast<token_type>(*yytext);}
"!"                 {return static_cast<token_type>(*yytext);}
"&"                 {return static_cast<token_type>(*yytext);}
"|"                 {return static_cast<token_type>(*yytext);}
"["                 {return static_cast<token_type>(*yytext);}
"]"                 {return static_cast<token_type>(*yytext);}
";"                 {return static_cast<token_type>(*yytext);}
","                 {return static_cast<token_type>(*yytext);}
"'"                 {return static_cast<token_type>(*yytext);}
"\""                {return static_cast<token_type>(*yytext);}


 /* gobble up white-spaces */
[ \t\r]+    {
                yylloc->step();
            }

 /* gobble up end-of-lines */
\n          {
                yylloc->lines(yyleng);
                yylloc->step();
                return token::EOL;
            }





 /* pass all other characters up to bison */
.           {
                return static_cast<token_type>(*yytext);
            }


%% /*** Additional Code ***/

namespace decaf {

Scanner::Scanner(std::istream* in,
		         std::ostream* out)
: decafFlexLexer(in, out)
{
}

Scanner::~Scanner()
{
}

void Scanner::set_debug(bool b)
{
    yy_flex_debug = b;
}

}

/* This implementation of DecafFlexLexer::yylex() is required to fill the
 * vtable of the class DecafFlexLexer. We define the scanner's main yylex
 * function via YY_DECL to reside in the Scanner class instead. */

#ifdef yylex
#undef yylex
#endif

int decafFlexLexer::yylex()
{
    std::cerr << "in decafFlexLexer::yylex() !" << std::endl;
    return 0;
}

/* When the scanner receives an end-of-file indication from YY_INPUT, it then
 * checks the yywrap() function. If yywrap() returns false (zero), then it is
 * assumed that the function has gone ahead and set up `yyin' to point to
 * another input file, and scanning continues. If it returns true (non-zero),
 * then the scanner terminates, returning 0 to its caller. */

int decafFlexLexer::yywrap()
{
    return 1;
}

