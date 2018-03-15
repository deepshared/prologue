{-# LANGUAGE AllowAmbiguousTypes #-}

module Prologue.Type.Reflection (module Prologue.Type.Reflection, module X) where

import Type.Reflection as X (Typeable, TypeRep, SomeTypeRep, typeOf, typeRep, withTypeable)
import Data.Typeable   as X (Proxy(Proxy))

import Prelude
import Data.Kind
import Control.Lens
import Control.Lens.Utils
import Data.Convert
import qualified Type.Reflection as T


---------------------
-- === TypeRep === --
---------------------

-- === Accessing === --

someTypeRep :: forall a. Typeable a => SomeTypeRep
someTypeRep = T.someTypeRep (Proxy :: Proxy a) ; {-# INLINE someTypeRep #-}

typeOfProxy :: forall proxy a. Typeable a => proxy a -> TypeRep a
typeOfProxy _ = typeRep @a ; {-# INLINE typeOfProxy #-}


-- type family Typeables ls :: Constraint where
--     Typeables '[] = ()
--     Typeables (l ': ls) = (Typeable l, Typeables2 ls)

class Typeables (ls :: [*]) where someTypeReps :: [SomeTypeRep]
instance (Typeable l, Typeables ls) => Typeables (l ': ls) where
    someTypeReps = someTypeRep @l : someTypeReps @ls ; {-# INLINE someTypeReps #-}
instance Typeables '[] where
    someTypeReps = [] ; {-# INLINE someTypeReps #-}