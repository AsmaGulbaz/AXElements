framework 'Cocoa'
require   'AXElements/CoreExtensions'

##
# @todo Add inertial scrolling abilities
# @todo Bezier paths for movements
# @todo Random background movements (for a truer simulation)
module Mouse

  FPS     = 120.0
  QUANTUM = Rational(1.0,FPS)

  def current_position
    NSEvent.mouseLocation.carbonize!
  end

  def post event
    CGEventPost( KCGHIDEventTap, event )
    sleep QUANTUM
  end

  def move_to point, duration = 0.2
    current = current_position
    steps = (FPS * duration).floor
    xstep = ((point.x - current.x) / steps)
    ystep = ((point.y - current.y) / steps)
    steps.times do
      current.x += xstep
      current.y += ystep
      post CGEventCreateMouseEvent(nil,KCGEventMouseMoved,current,KCGMouseButtonLeft)
    end
    $stderr.puts 'Not moving anywhere' if current == point
    post CGEventCreateMouseEvent(nil,KCGEventMouseMoved,point,KCGMouseButtonLeft)
  end

  ##
  # Ideally this can be abbreviated to #left_mouse_down, #drag, #left_mouse_up
  def drag_to point, duration
    current = current_position
    post CGEventCreateMouseEvent(nil,KCGEventLeftMouseDown,current,KCGMouseButtonLeft)
    steps = (FPS * duration).floor
    xstep = ((point.x - current.x) / steps)
    ystep = ((point.y - current.y) / steps)
    steps.times do
      current.x += xstep
      current.y += ystep
      post CGEventCreateMouseEvent(nil,KCGEventLeftMouseDragged,current,KCGMouseButtonLeft)
    end
    $stderr.puts 'Not moving anywhere' if current == point
    post CGEventCreateMouseEvent(nil,KCGEventLeftMouseDragged,point,KCGMouseButtonLeft)
    post CGEventCreateMouseEvent(nil,KCGEventLeftMouseUp,point,KCGMouseButtonLeft)
  end

  ##
  # Scrolling too much or too little in a period of time will cause the
  # animation to look weird.
  #
  # Needs to support an additional argument for units (lines or pixels).
  #
  # Amount should be positive to scroll up or negative to scroll down.
  def scroll amount, duration = 0.2, units = KCGScrollEventUnitLine
    steps   = (FPS * duration).floor
    current = 0.0
    steps.times do |step|
      done     = (step+1).to_f / steps
      scroll   = ((done - current)*amount).floor
      post CGEventCreateScrollWheelEvent(nil,units,1,scroll)
      current += (scroll.to_f)/amount
    end
  end

end
