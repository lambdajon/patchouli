{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Assistant () where

import Data.Kind (Type)
import Effectful (Dispatch (Dynamic), DispatchOf, Effect)
import Effectful.TH (makeEffect)

type Assistant :: (Type -> Type) -> Type -> Type
data Assistant :: Effect where
  ListResources :: Assistant m ()
  SearchBySignature :: String -> Assistant m ()
  SearchPackageByName :: String -> Assistant m ()

type instance DispatchOf Assistant = 'Dynamic

makeEffect ''Assistant
