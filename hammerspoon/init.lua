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

hs.hotkey.bind({"cmd"}, "`", mountApp("Alacritty"))

hs.notify.new(
    {
        title = "Hammerspoon",
        informativeText = "Hammerspoon is ready",
        autoWithdraw = true,
        hasActionButton = false
    }
):send()