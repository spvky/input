window: Window_Type;
close_window: bool;
last_time: float64;

Action :: enum {
    Jump;
    Kick;
    Roll;
    Dive;
    Shoot;
}

buffer: Input_Buffer(Action);
my_theme: Overall_Theme;
font: *Dynamic_Font;
player_height: float32;

main :: () {
    init_window();
    ui_init();
    get_font_at_size("assets", "roboto.ttf", 16);
    my_theme.font = font;
    my_theme.label_theme.font = font;

    raw_ti := type_info(Action);
    ti := cast(*Type_Info_Enum)raw_ti;
    for ti.names {
        print("%\n", it);
    }

    register_input(*buffer, .Jump, .SPACEBAR);
    register_input(*buffer, .Kick, #char "K");
    while !close_window {
        update_window_events();
        now := seconds_since_init();
        raw_delta: float64 = now - last_time;
        delta := cast(float32)raw_delta;
        last_time = now;
        update(delta);
        render();
        reset_temporary_storage();
    }
}

init_window :: () {
    window = create_window(1920, 1080, "Input");
    set_render_target(window);
}

update :: (delta: float32) {
    update_buffer(*buffer, delta);
    if is_action_buffered(*buffer, .Jump) {
        // consume_action(*buffer, .Jump);
        // print("JUMPED!!\n");
    }
}

render :: () {
    clear_render_target(0.3, 0.1, 0.4, 1);
    draw_ui();
    swap_buffers(window);
}

draw_ui :: () {
    set_shader_for_color();
    buffer_gauge_width: float32 = 300;
    proc := default_theme_procs[0];
    my_theme = proc();
    set_default_theme(my_theme);
    y_pos: float32 = 800;
    for i: 0..buffer.MAP_SIZE - 1 {
        x_pos: float32 = (xx i * (320.0)) + 20;
        name := tprint("%", cast(Action)i);
        map := buffer.map[i];
        buffer_value := buffer.buffered[i];
        held := buffer.held[i];
        released := buffer.released[i];

        label_rect := get_rect(x_pos, y_pos, 300, 40);
        buffer_rect := get_rect(x_pos, y_pos - 100, 300, 40);
        buffer_percent: float32 = clamp(buffer_value / buffer.buffer_length, 0, 1);
        current_buffer_width: float32 = (buffer_percent * buffer_gauge_width) - 4;

        immediate_quad(.{x_pos, y_pos - 40}, .{x_pos + buffer_gauge_width, y_pos - 40}, .{x_pos + buffer_gauge_width, y_pos}, .{x_pos, y_pos}, .{1, 1, 1, 0.3});
        immediate_quad(.{x_pos + 2, y_pos - 38}, .{x_pos + current_buffer_width, y_pos - 38}, .{x_pos + current_buffer_width, y_pos - 2}, .{x_pos + 2, y_pos - 2}, .{0, 0, 0.5, 1});
        label(label_rect, name, *my_theme.label_theme);
        label(buffer_rect, tprint("%", buffer_value), *my_theme.label_theme);
    }
    draw_popups();
}

#import "Input";
#import "Simp";
#import "Window_Creation";
#import "Basic";
#import "GetRect";

#load "input.jai";
