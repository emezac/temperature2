# advanced_temperature_converter_mvc.rb

require 'gtk4'
require 'observer'

# Model
class TemperatureModel
  include Observable

  def initialize
    @temperature_f = 32.0
  end

  def get_f
    @temperature_f
  end

  def get_c
    (@temperature_f - 32.0) * 5.0 / 9.0
  end

  def set_f(temp_f)
    @temperature_f = temp_f
    changed
    notify_observers
  end

  def set_c(temp_c)
    @temperature_f = temp_c * 9.0 / 5.0 + 32.0
    changed
    notify_observers
  end
end

# Controller
class TemperatureController
  def initialize(model)
    @model = model
  end

  def fahrenheit_changed(value)
    @model.set_f(value)
  end

  def celsius_changed(value)
    @model.set_c(value)
  end
end

# Base View
class BaseView
  attr_reader :window

  def initialize(model, controller)
    @model = model
    @controller = controller
    @model.add_observer(self)
  end

  def update
    raise NotImplementedError, "Subclasses must implement update method"
  end
end

# Fahrenheit View
class FahrenheitView < BaseView
  def initialize(model, controller)
    super(model, controller)
    create_ui
  end

  def create_ui
    @window = Gtk::Window.new
    @window.title = "Fahrenheit Temperature"
    @window.set_default_size(200, 100)

    vbox = Gtk::Box.new(:vertical, 5)
    @entry = Gtk::Entry.new
    @entry.text = @model.get_f.to_s
    @entry.signal_connect("activate") { @controller.fahrenheit_changed(@entry.text.to_f) }

    raise_button = Gtk::Button.new(label: "Raise")
    lower_button = Gtk::Button.new(label: "Lower")

    raise_button.signal_connect("clicked") { @controller.fahrenheit_changed(@model.get_f + 1) }
    lower_button.signal_connect("clicked") { @controller.fahrenheit_changed(@model.get_f - 1) }

    vbox.append(@entry)
    hbox = Gtk::Box.new(:horizontal, 5)
    hbox.append(raise_button)
    hbox.append(lower_button)
    vbox.append(hbox)

    @window.child = vbox
    @window.set_visible(true)
  end

  def update
    @entry.text = format("%.1f", @model.get_f)
  end
end

# Celsius View
class CelsiusView < BaseView
  def initialize(model, controller)
    super(model, controller)
    create_ui
  end

  def create_ui
    @window = Gtk::Window.new
    @window.title = "Celsius Temperature"
    @window.set_default_size(200, 100)

    vbox = Gtk::Box.new(:vertical, 5)
    @entry = Gtk::Entry.new
    @entry.text = @model.get_c.to_s
    @entry.signal_connect("activate") { @controller.celsius_changed(@entry.text.to_f) }

    raise_button = Gtk::Button.new(label: "Raise")
    lower_button = Gtk::Button.new(label: "Lower")

    raise_button.signal_connect("clicked") { @controller.celsius_changed(@model.get_c + 1) }
    lower_button.signal_connect("clicked") { @controller.celsius_changed(@model.get_c - 1) }

    vbox.append(@entry)
    hbox = Gtk::Box.new(:horizontal, 5)
    hbox.append(raise_button)
    hbox.append(lower_button)
    vbox.append(hbox)

    @window.child = vbox
    @window.set_visible(true)
  end

  def update
    @entry.text = format("%.1f", @model.get_c)
  end
end

# Thermometer View
class ThermometerView < BaseView
  def initialize(model, controller)
    super(model, controller)
    create_ui
  end

  def create_ui
    @window = Gtk::Window.new
    @window.title = "Temperature Gauge"
    @window.set_default_size(100, 300)

    @drawing_area = Gtk::DrawingArea.new
    @drawing_area.set_draw_func { |_, cr, width, height| draw(cr, width, height) }

    @window.child = @drawing_area
    @window.set_visible(true)
  end

  def draw(cr, width, height)
    # Draw thermometer outline
    cr.set_source_rgb(0, 0, 0)
    cr.rectangle(width/2 - 10, 10, 20, height - 20)
    cr.stroke

    # Draw mercury
    cr.set_source_rgb(1, 0, 0)
    temperature_range = 100.0  # Assuming a range of -50°F to 150°F
    zero_point = height - 30   # Bottom of the thermometer
    scale_factor = (height - 40) / temperature_range

    mercury_height = (@model.get_f + 50) * scale_factor  # +50 to handle negative temperatures
    mercury_height = [mercury_height, height - 40].min  # Cap the height

    cr.rectangle(width/2 - 8, zero_point - mercury_height, 16, mercury_height)
    cr.fill

    # Draw temperature markings
    cr.set_source_rgb(0, 0, 0)
    cr.set_font_size(10)
    [-50, 0, 50, 100, 150].each do |temp|
      y = zero_point - (temp + 50) * scale_factor
      cr.move_to(width/2 + 15, y)
      cr.show_text(temp.to_s + "°F")
      cr.move_to(width/2 - 15, y)
      cr.line_to(width/2 + 15, y)
      cr.stroke
    end
  end

  def update
    @drawing_area.queue_draw
  end
end

# Main application
class TemperatureApp < Gtk::Application
  def initialize
    super('com.example.TemperatureConverter', :flags_none)

    signal_connect :activate do |application|
      model = TemperatureModel.new
      controller = TemperatureController.new(model)

      fahrenheit_view = FahrenheitView.new(model, controller)
      celsius_view = CelsiusView.new(model, controller)
      thermometer_view = ThermometerView.new(model, controller)

      # Ensure the application stays alive as long as any window is open
      [fahrenheit_view, celsius_view, thermometer_view].each do |view|
        view.window.application = application
        view.window.present
      end
    end
  end
end

if __FILE__ == $0
  puts "Running the Temperature Converter application..."
  app = TemperatureApp.new
  app.run
end
