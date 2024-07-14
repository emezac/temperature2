Run: 
gem install gtk4 gobject-introspection
ruby advanced_temp.rb

Description

Temperature Converter MVC Application Summary

Overview
This application is a temperature converter that allows users to view and modify temperatures in Fahrenheit and Celsius. It features multiple views, including text-based inputs, a graphical thermometer, and a pocket watch-style thermometer.

Key Components and How They Work

Model (TemperatureModel):

Holds the current temperature data
Provides methods to get and set temperature in Fahrenheit and Celsius
Notifies observers (views) when the temperature changes


Controller (TemperatureController):

Acts as an intermediary between the model and views
Handles user input from views and updates the model accordingly


Views:

FahrenheitView and CelsiusView: Text-based inputs with raise/lower buttons
ThermometerView: Graphical representation of a mercury thermometer
PocketWatchThermometerView: Circular, clock-like representation of temperature


Application (TemperatureApp):

Creates instances of the model, controller, and views
Sets up the GTK application and manages window presentation



How It Works

The application starts by creating a single model and controller.
Multiple views are created, all observing the same model.
When a user interacts with any view (e.g., entering a temperature or clicking a button):

-The view notifies the controller of the change.
-The controller updates the model.
-The model notifies all views of the change.
-Each view updates its display to reflect the new temperature.


Main Purpose for Educating New Developers
This application serves as an excellent educational tool for new developers for several reasons:

MVC Pattern Demonstration:

Clearly separates concerns between Model (data), View (user interface), and Controller (logic).
Shows how multiple views can represent the same data differently.

Observer Pattern:

Demonstrates how multiple views can be updated automatically when the model changes.


GUI Programming:

Introduces concepts of event-driven programming and GUI creation using GTK.


Ruby Code: https://github.com/emezac/temperature2.git

Showcases object-oriented programming concepts in Ruby.
Demonstrates use of modules (Observable) and inheritance.

Extensibility:

Shows how new views can be easily added without changing the existing model or controller.


Real-world Application:

Provides a practical, relatable example of a working application.

Code Organization:

Illustrates how to structure a multi-class application.


Testing Opportunities:

Offers clear separation of concerns, making it easier to write unit tests for each component.

By studying and modifying this application, new developers can gain hands-on experience with important software design patterns, GUI programming, and Ruby language features, all within the context of a practical, real-world application.

Video : https://www.youtube.com/shorts/N4dySbcj_tw

Original implementation: https://csis.pace.edu/~bergin/mvc/mvcgui.html
