function openApp(name)
  app = hs.application.find(name)

  if app and app:isFrontmost() then
      app:hide()
      return
  end

  hs.application.launchOrFocus(name)
end

function mountApp(appName)
  return function()
      openApp(appName)
  end
end

-- Disable animation
hs.window.animationDuration = 0

-- Open app faster
hs.hotkey.bind({"cmd"}, "`", mountApp("Alacritty"))

-- Notify if config is built
hs.notify.new({
        title = "Hammerspoon",
        informativeText = "Hammerspoon is ready",
        autoWithdraw = true,
        hasActionButton = false
    }
):send()
