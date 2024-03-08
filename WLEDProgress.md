moonraker.conf
```
[wled alias]
type: http
address: 192.168.1.169
initial_preset: 1
chain_count: 47
```
printer.cfg

```
[gcode_macro WLED_ON]
description: Turn WLED strip on using optional preset and resets led colors
gcode:
  {% set strip = params.STRIP|string %}
  {% set preset = params.PRESET|default(-1)|int %}

  {action_call_remote_method("set_wled_state",
                             strip=strip,
                             state=True,
                             preset=preset)}
```

```
[gcode_macro WLED_OFF]
description: Turn WLED strip off
gcode:
  {% set strip = params.STRIP|string %}

  {action_call_remote_method("set_wled_state",
                             strip=strip,
                             state=False)}
```

```
[gcode_macro _set_leds]
gcode:
    {% if printer.extruder.target == 0 %}
        # the extrude heater is off
    {% else %}
        # the extrude heater is on
        {% if printer.idle_timeout.state == "Printing" %}
            # we are printing
            # progress is in the display_status object
            {% set perc = printer.display_status.progress %}
            # set this to how many leds you have for your bar
            {% set numleds = 47 %}
            {% set last = (perc|float * numleds|float)|int %}
            {% for n in range(numleds) %}
                {% if n < last %}
                    SET_WLED STRIP=alias RED=0 GREEN=1 BLUE=0 TRANSMIT=0 index={ n + 1|int }
                {% else %}
                    SET_WLED STRIP=alias RED=1 GREEN=0 BLUE=0 TRANSMIT=0 index={ n + 1|int }
                {% endif %}
            {% endfor %}
            # now actually transmit it
            SET_WLED STRIP=alias RED=0.3 GREEN=0.3 BLUE=0.3 TRANSMIT=1 INDEX={ last + 1|int }
        {% endif %}
    {% endif %}
```

```
[gcode_macro SET_WLED]
description: SET_LED like functionality for WLED, applies to all active segments
gcode:
    {% set strip = params.STRIP|string %}
    {% set red = params.RED|default(0)|float %}
    {% set green = params.GREEN|default(0)|float %}
    {% set blue = params.BLUE|default(0)|float %}
    {% set white = params.WHITE|default(0)|float %}
    {% set index = params.INDEX|default(-1)|int %}
    {% set transmit = params.TRANSMIT|default(1)|int %}

    {action_call_remote_method("set_wled",
                               strip=strip,
                               red=red, green=green, blue=blue, white=white,
                               index=index, transmit=transmit)}
```

```
[delayed_gcode _update_leds_loop]
initial_duration: 5
gcode:
    _set_leds
    UPDATE_DELAYED_GCODE ID=_update_leds_loop DURATION=60
