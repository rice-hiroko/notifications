module.exports =
class StatusBarManager
  animationDuration: 500
  count: 0

  constructor: (statusBar) ->

    # TODO: add displayed notifications

    @number = document.createElement('div')
    @number.textContent = @count

    @element = document.createElement('span')
    @element.classList.add('notifications-count')
    atom.tooltips.add(@element, title: "Notifications")
    @element.appendChild(@number)
    @element.addEventListener 'click', => atom.commands.dispatch(@element, "notifications:toggle-log")
    # @element.addEventListener 'animationend', (e) => @element.classList.remove("new-notification") if e.animationName is "new-notification"

    @tile = statusBar.addRightTile(
      item: @element
      priority: 100
    )

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
