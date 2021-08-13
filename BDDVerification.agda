module BDDVerification where

open import AgdaAsciiPrelude.AsciiPrelude

private variable
  l l' l1 l2 l3 : Level
  A B C D : Set l
  F G H V M : Set l -> Set l'

UnitCon : Set (lsuc l ~U~ lsuc l')
UnitCon {l = l} {l' = l'} = Set l -> Set l'

record MonadVar (M : UnitCon {l} {l}) (V : UnitCon {l} {l}) : Set (lsuc l) where
  field
    new : A -> M (V A)
    modify : V A -> (A -> A and B) -> M B

  read : V A -> M A
  read = flip modify (\ x -> x , x)

  write : V A -> A -> M T
  write p x = modify p (\ _ -> x , top)

open MonadVar {{...}} public

{-
sth : {_ : MonadVar M V} -> M T
sth = do
  x <- new --new mv
  k <- read x
-}
--wieso nicht: write : V A -> A -> M () ? weil () in Agda was anderes ist als in Haskell. Das () in Haskell hei-t hier T
--warum auch immer O_0 -> () ist das absurd-pattern. Das wird benutzt wenn es irgendwo keinen Wert geben kann.

--ich muss mal eben was ausprobieren...

-- woah, du dokumentierst ja, was ist da kaputt?
-- der code ist noch nicht schön genug

{-
--was ich hier versuche: Das problem ist, dass man das assignment nur partiell kennt. das ist super nervig wenn man damit beweise führen will. Meine Lösung: Die Monade schleppt indiziert eine Liste mit sich, in der einfach die assignments drin stehen. Da neuere assignments eher oben sind kommt man an die hoffentlich schneller ran.

--read : (v : V A) -> (i v === k) -> M i i (exists a st a === k)
write : (v : V A) -> (a : A) -> M i (v ->> a :: filter (\ (v' ->> _) -> True $ v' == v) i) ()

Alternatively:
new : (a : A) -> M d (fst $ mkNew d a) (snd $ mkNew d a)
modify : (v : V A) -> (f : A -> A and B) -> M d (fst $ mdfy d c f) (snd $ mdfy d c f)

-}
