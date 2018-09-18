{-# LANGUAGE RecordWildCards #-}

import Data.Typeable

{- |
 - Pi-lib expressions. 
 -
 - These will be used futurely by the parser, and will be returned according to the tokens found in the imp program.
-}
data Identifier = Id String deriving Show
data Expr = Aexp Aexpr | Bexp Bexpr | Idtf Identifier | Kw Keyword deriving Show
data Aexpr = Num Int | Sum Aexpr Aexpr | Sub Aexpr Aexpr | Mul Aexpr Aexpr deriving Show
data Bexpr = Boo Bool | Eq Bexpr Bexpr | Not Bexpr deriving Show
data Statement = Exp Expr | Command Cmd deriving Show
data Cmd = Assign Identifier Expr | Loop Bexpr Cmd | CSeq Cmd Cmd deriving Show
data Keyword = KWSum | KWMul | KWSub | KWEq | KWNot deriving Show

data Value = Bo { bval :: Bool } | In { ival :: Int} deriving Show
{- |
 - Automata definition
 -}
type ValueStack = [Value]
type ControlStack = [Expr]
data ExpPiAut = ExpPiAut { val :: ValueStack,
                           cnt :: ControlStack
                         } deriving Show
{- |
 - automata functions evaluation
-}
eval :: ExpPiAut -> ExpPiAut
eval (ExpPiAut v []) = ExpPiAut v []
eval (ExpPiAut v c) = case (head c) of
                           Aexp (Sum aex1 aex2) -> eval ExpPiAut {cnt = Aexp aex1 : Aexp aex2 : Kw KWSum : tail c, val = v} 
                           Aexp (Sub aex1 aex2) -> eval ExpPiAut {cnt = Aexp aex1 : Aexp aex2 : Kw KWSub : tail c, val = v}
                           Aexp (Mul aex1 aex2) -> eval ExpPiAut {cnt = Aexp aex1 : Aexp aex2 : Kw KWMul : tail c, val = v}
                           Bexp (Eq  exp1 exp2) -> eval ExpPiAut {cnt = Bexp exp1 : Bexp exp2 : Kw KWEq  : tail c, val = v} 
                           Bexp (Not ex)        -> eval ExpPiAut {cnt = Bexp ex : Kw KWNot : tail c, val = v}
                           Aexp (Num ival)      -> eval ExpPiAut {cnt = tail c, val = In ival : v}
                           Bexp (Boo bval)      -> eval ExpPiAut {cnt = tail c, val = Bo bval : v}
                           Kw KWSum             -> eval ExpPiAut {cnt = tail c, val = In (ival (head v) + ival (head (tail v))) : tail (tail v)}
                           Kw KWSub             -> eval ExpPiAut {cnt = tail c, val = In (ival (head v) - ival (head (tail v))) : tail (tail v)}
                           Kw KWMul             -> eval ExpPiAut {cnt = tail c, val = In (ival (head v) * ival (head (tail v))) : tail (tail v)}
                           Kw KWEq              -> eval ExpPiAut {cnt = tail c, val = Bo (bval (head v) == bval (head (tail v))) : tail (tail v)}
                           Kw KWNot             -> eval ExpPiAut {cnt = tail c, val = Bo (not (bval (head v))) : tail v}
{- 
evalSum aut exp exp = aut&cnt 
aut@(ExpPiAut { cnt = cnts@(ControlStack) }) = aut {cnt = cnt ++ exp1 ++ exp2}
-}
