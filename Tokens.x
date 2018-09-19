{
module Tokens where
}

%wrapper "basic"

$digit = 0-9			-- digits
$alpha = [a-zA-Z]		-- alphabetic characters

tokens :-

  $white+			;
  "--".*			;
  $digit+			{ \s -> TokenInt(read s) }
  \=                            { \s -> TokenEq }
  \+                            { \s -> TokenPlus }
  \-                            { \s -> TokenMinus }
  \*                            { \s -> TokenTimes }
  \/                            { \s -> TokenDiv }
  \(                            { \s -> TokenLParen }
  \)                            { \s -> TokenRParen }
  \!                            { \s -> TokenNot }

{
-- Each action has type :: String -> Token

-- The token type:
data Token = TokenEq
           | TokenPlus
           | TokenMinus
           | TokenTimes
           | TokenDiv
           | TokenLParen
           | TokenRParen
           | TokenNot 
           | TokenInt Int
           | TokenBool Bool
         deriving (Eq,Show)

scanTokens = alexScanTokens
--main::IO ()

--main = do
  --s <- getContents
  --let x = alexScanTokens s
  --mapM_ print x
}
