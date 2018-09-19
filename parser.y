{
module Grammar where
import Tokens
}

%name impParser
%tokentype { Token }
%error { parseError }

%token
    int { TokenInt $$ }
    bool { TokenBool $$ }
    '=' { TokenEq }
    '+' { TokenPlus }
    '-' { TokenMinus }
    '*' { TokenTimes }
    '/' { TokenDiv }
    '(' { TokenLParen }
    ')' { TokenRParen }
    '!' { TokenNot }

%right in
%nonassoc '>' '<'
%left '+' '-'
%left '*' '/'
%left NEG

%%

Expr : '(' Expr ')'          { $2 }
     | Aexpr                 { Aexpr $1 }
     | Bexpr                 { Bexpr $1 }

Aexpr : Aexpr '+' Aexpr      { Sum $1 $3 }
      | Aexpr '-' Aexpr      { Sub $1 $3 }
      | Aexpr '*' Aexpr      { Mul $1 $3 }
      | Aexpr '/' Aexpr      { Div $1 $3 } 
      | Num                  { Num $1 }

Bexpr : Bexpr '=' Bexpr      { Eq $1 $3 }
      | '!' Bexpr            { Not $1 }
      | Boo                  { Boo $1 }

Num : int                    { Int $1 }

Boo : bool                   { Bool $1 }


{

parseError :: [Token] -> a
parseError _ = error "Parse error"

data Expr = Aexp Aexpr | Bexp Bexpr | Idtf Identifier | Kw Keyword deriving Show
data Aexpr = Num Int | Sum Aexpr Aexpr | Sub Aexpr Aexpr | Mul Aexpr Aexpr deriving Show
data Bexpr = Boo Bool | Eq Bexpr Bexpr | Not Bexpr deriving Show
data Statement = Exp Expr | Command Cmd deriving Show
data Cmd = Assign Identifier Expr | Loop Bexpr Cmd | CSeq Cmd Cmd deriving Show
data Keyword = KWSum | KWMul | KWSub | KWEq | KWNot deriving Show
data Identifier = Id String deriving Show


}
