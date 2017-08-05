module.exports =
class StatusBarManager
  animationDuration: 500
  count: 0

  constructor: (statusBar, @duplicateTimeDelay) ->
    @render()
    @tile = statusBar.addRightTile(
      item: @element
      priority: 100
    )

  render: ->
    @number = document.createElement('div')
    @number.textContent = @count

    @element = document.createElement('span')
    @element.classList.add('notifications-count')
    atom.tooltips.add(@element, title: "Notifications")
    @element.appendChild(@number)
    @element.addEventListener 'click', => atom.commands.dispatch(@element, "notifications:toggle-log")

    lastNotification = null
    for notification in atom.notifications.getNotifications()
      if lastNotification?
        # do not show duplicates unless some amount of time has passed
        timeSpan = notification.getTimestamp() - lastNotification.getTimestamp()
        unless timeSpan < @duplicateTimeDelay and notification.isEqual(lastNotification)
          @addNotification(notification)
      else
        @addNotification(notification)

      lastNotification = notification

  destroy: ->
    @tile.destroy()
    @tile = null

  addNotification: (notification) ->
    @element.setAttribute("last-type", notification.getType())
    @number.textContent = ++@count
    return if @number.classList.contains("new-notification")

    @number.classList.add("new-notification")
    setTimeout =>
      @number.classList.remove("new-notification")
    , @animationDuration
