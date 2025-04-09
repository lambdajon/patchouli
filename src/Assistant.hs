{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}

module Assistant (module Assistant) where

import Control.Monad.IO.Class (liftIO)

import Data.Kind (Type)
import Data.Text (Text)
import Data.Text qualified as T

import Hoogle (Target (..), defaultDatabaseLocation, searchDatabase, withDatabase)

import Telegram.Bot.API (Token (..), Update, defaultTelegramClientEnv)
import Telegram.Bot.Simple (BotApp (..), startBot_, (<#))
import Telegram.Bot.Simple qualified as TBS
import Telegram.Bot.Simple.UpdateParser (command, parseUpdate)

import Assistant.Env

type Model :: Type
type Model = ()

type Action :: Type
data Action
  = ActionHoogleSearch Text
  deriving stock (Show)

assistantBot :: BotApp Model Action
assistantBot =
  BotApp
    { botInitialModel = ()
    , botAction = flip updateToAction
    , botHandler = handleAction
    , botJobs = []
    }

updateToAction :: Model -> Update -> Maybe Action
updateToAction _ =
  parseUpdate $
    ActionHoogleSearch <$> command "hoogle"

displayTarget :: Target -> Text
displayTarget Target{..} = T.pack targetURL

handleAction :: Action -> Model -> TBS.Eff Action Model
handleAction action model = case action of
  ActionHoogleSearch str ->
    model <# do
      ts <- liftIO do
        dbpath <- defaultDatabaseLocation
        withDatabase dbpath \db ->
          pure . take 10 $ searchDatabase db (T.unpack str)
      let result = T.intercalate "\n\n" . map displayTarget $ ts
      pure result

run :: IO ()
run = do
  env <- loadBotEnv "config.toml"
  case env of
    (BotEnv (Token token)) -> do
      e <- defaultTelegramClientEnv $ Token token
      startBot_ assistantBot e
